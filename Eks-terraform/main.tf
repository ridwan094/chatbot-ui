# Mendapatkan subnet dari VPC dengan dua AZ berbeda
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected_vpc.id]
  }
}

# Cluster provision
resource "aws_eks_cluster" "example" {
  name     = "EKS_CLOUD"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = [
      "subnet-0a731a03b4d286577", # Subnet valid dengan Public IP
      "subnet-070655a70148eeba3"  # Subnet valid dengan Public IP
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
  ]
}

# Node group provision
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "Node-cloud"
  node_role_arn   = aws_iam_role.example1.arn
  subnet_ids      = [
    "subnet-0a731a03b4d286577", # Subnet valid dengan Public IP
    "subnet-070655a70148eeba3"  # Subnet valid dengan Public IP
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t2.medium"]

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}
