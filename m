Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3IEWjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab3IEWjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:39:32 -0400
Message-ID: <1378420771.3246.269.camel@ul30vt.home>
Subject: Re: [PATCH] vfio: fix documentation
From: Alex Williamson <alex.williamson@redhat.com>
To: Zi Shen Lim <zishen.lim@linaro.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Thu, 05 Sep 2013 16:39:31 -0600
In-Reply-To: <1378419737-4154-1-git-send-email-zishen.lim@linaro.org>
References: <1378419737-4154-1-git-send-email-zishen.lim@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-05 at 15:22 -0700, Zi Shen Lim wrote:
> Signed-off-by: Zi Shen Lim <zishen.lim@linaro.org>
> ---

Applied.  Thanks!

Alex

>  Documentation/vfio.txt | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/vfio.txt b/Documentation/vfio.txt
> index d7993dc..b9ca023 100644
> --- a/Documentation/vfio.txt
> +++ b/Documentation/vfio.txt
> @@ -167,8 +167,8 @@ group and can access them as follows:
>  	int container, group, device, i;
>  	struct vfio_group_status group_status =
>  					{ .argsz = sizeof(group_status) };
> -	struct vfio_iommu_x86_info iommu_info = { .argsz = sizeof(iommu_info) };
> -	struct vfio_iommu_x86_dma_map dma_map = { .argsz = sizeof(dma_map) };
> +	struct vfio_iommu_type1_info iommu_info = { .argsz = sizeof(iommu_info) };
> +	struct vfio_iommu_type1_dma_map dma_map = { .argsz = sizeof(dma_map) };
>  	struct vfio_device_info device_info = { .argsz = sizeof(device_info) };
>  
>  	/* Create a new container */
> @@ -193,7 +193,7 @@ group and can access them as follows:
>  	ioctl(group, VFIO_GROUP_SET_CONTAINER, &container);
>  
>  	/* Enable the IOMMU model we want */
> -	ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_IOMMU)
> +	ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_IOMMU);
>  
>  	/* Get addition IOMMU info */
>  	ioctl(container, VFIO_IOMMU_GET_INFO, &iommu_info);
> @@ -229,7 +229,7 @@ group and can access them as follows:
>  
>  		irq.index = i;
>  
> -		ioctl(device, VFIO_DEVICE_GET_IRQ_INFO, &reg);
> +		ioctl(device, VFIO_DEVICE_GET_IRQ_INFO, &irq);
>  
>  		/* Setup IRQs... eventfds, VFIO_DEVICE_SET_IRQS */
>  	}



