Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3GWKcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:32:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50245 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab3GWKcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:32:12 -0400
X-AuditID: cbfee68e-b7f276d000002279-55-51ee5b9cbe35
From: Inki Dae <inki.dae@samsung.com>
To: "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-samsung-soc@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, "'Cho KyongHo'" <pullip.cho@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Jiri Kosina'" <jkosina@suse.cz>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1374573694-30595-1-git-send-email-a.motakis@virtualopensystems.com>
In-reply-to: <1374573694-30595-1-git-send-email-a.motakis@virtualopensystems.com>
Subject: RE: [PATCH] iommu/exynos: add devices attached to the System MMU to an
 IOMMU group
Date: Tue, 23 Jul 2013 19:31:54 +0900
Message-id: <00d701ce878f$da099fe0$8e1cdfa0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6Hi6pwNy434O/dTJCUsdR9lhyWLgAAkiuA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSojs3+l2gwbFHzBZ37p5jtViw39pi
	95zFLBadszewW3w8dZzdYtPja6wWl3fNYbOYcX4fk8W/3oOMFif/9DJa7FzXye7A7fHk4Dwm
	jzvX9rB5nN+0htlj85J6j8k3ljN69G1ZxehxZsERdo+l944yenzeJOdx5egZpgCuKC6blNSc
	zLLUIn27BK6Mb70z2At2SlR0NH1nb2DsEuli5OSQEDCRWDtpGiOELSZx4d56ti5GLg4hgaWM
	Ej2zN7PCFH348AwqMZ1R4un6HywQzm9Gicnnm8Ha2QRUJSauuA9WJSKwglHi8I/bTCAOs8AM
	Jokf5z8ygVQJCQRIHOhvZgexOQWCJU7uvARmCwvESnQtvsQGYrMATdr45S1YPa+ArcSD9j1s
	ELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGXuYuQAulVd4tFfXZCwiICRxMHWb1AlIhL7Xrxj
	BLlHQmALh8SD8+vZIXYJSHybfIgFoldWYtMBZoiXJSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsW
	MLKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAhMDKf/PevbwXjzgPUhxmSg9ROZpUST84GJ
	Ja8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjClr
	f9c0fNu15fQmYeXVtybXz3Zck5v6+XOntEJ+Gfvah0rR9xReKd499NJ/7in9adqf/s56yDDn
	sq9nSKfq0hncmrIhxefKXmv7XRKS07Q7cnNB4NUrITx7El+lMk5VKlZ/F732X5iQ763rt9yW
	R74r3SdibLg12FVvHsuC4F0z/t0LiNHfdkOJpTgj0VCLuag4EQAzAly5IgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jQd050e8CDSZPsbC4c/ccq8WC/dYW
	u+csZrHonL2B3eLjqePsFpseX2O1uLxrDpvFjPP7mCz+9R5ktDj5p5fRYue6TnYHbo8nB+cx
	edy5tofN4/ymNcwem5fUe0y+sZzRo2/LKkaPMwuOsHssvXeU0ePzJjmPK0fPMAVwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzPjWO4O9YKdERUfTd/YGxi6RLkZODgkB
	E4kPH56xQdhiEhfurQeyuTiEBKYzSjxd/4MFwvnNKDH5fDMjSBWbgKrExBX3wapEBFYwShz+
	cZsJxGEWmMEk8eP8RyaQKiGBAIkD/c3sIDanQLDEyZ2XwGxhgViJrsWXwPaxAE3a+OUtWD2v
	gK3Eg/Y9bBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xl7mLkALpVXeLRX12QsIiAkcTB1m9Q
	JSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC
	084z6R2MqxosDjEKcDAq8fB6eL8NFGJNLCuuzD3EKMHBrCTCu1TqXaAQb0piZVVqUX58UWlO
	avEhxmSgRycyS4km5wNTYl5JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOFBNITS1KzU1MLUotg
	tjBxcEo1MCpqPead2R3HPM1AQ/4D54xJ372clzS2pIeyO3Zt2LvT8kTmjR1zPjd23dGtWei8
	Jntp9ZebpcqGGidEHQxTJn2P+3+JL6r8X9uHvBt1Dl+sQ1euaj90Nq+Cd88XscNzuzemHgv6
	/nLFpn27ZUPvqVTIPj2h0/7Eu+2e+d/l85ZfST69L18nb4MSS3FGoqEWc1FxIgBfIC0EfwMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-samsung-soc-owner@vger.kernel.org [mailto:linux-samsung-soc-
> owner@vger.kernel.org] On Behalf Of Antonios Motakis
> Sent: Tuesday, July 23, 2013 7:02 PM
> To: linux-arm-kernel@lists.infradead.org;
iommu@lists.linux-foundation.org;
> linux-samsung-soc@vger.kernel.org
> Cc: kvmarm@lists.cs.columbia.edu; Antonios Motakis; Cho KyongHo; Joerg
> Roedel; Sachin Kamat; Jiri Kosina; Wei Yongjun; open list
> Subject: [PATCH] iommu/exynos: add devices attached to the System MMU to
> an IOMMU group
> 
> IOMMU groups are expected by certain users of the IOMMU API,
> e.g. VFIO. Since each device is behind its own System MMU, we
> can allocate a new IOMMU group for each device.
> 
> This patch depends on Cho KyongHo's patch series titled "[PATCH v7 00/12]
> iommu/exynos: Fixes and Enhancements of System MMU driver with DT",
> applied on a Linux 3.10.1 kernel. It has been tested on the Arndale board.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/iommu/exynos-iommu.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 51d43bb..9f39eaa 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -1134,6 +1134,28 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct
> iommu_domain *domain,
>  	return phys;
>  }
> 
> +static int exynos_iommu_add_device(struct device *dev)
> +{
> +	struct iommu_group *group;
> +	int ret;
> +
> +	group = iommu_group_alloc();

Is that correct? I don't see why you allocate a group object every time
add_device callback is called. That doesn't have any meaning we have to use
iommu group feature. I think the implementation should be one more devices
per a group. So I guess a given device object should be wrapped by higher
device object than the given device object. For a good example, you can
refer to intel-iommu.c file.

Thanks,
Inki Dae

> +	if (IS_ERR(group)) {
> +		dev_err(dev, "Failed to allocate IOMMU group\n");
> +		return PTR_ERR(group);
> +	}
> +
> +	ret = iommu_group_add_device(group, dev);
> +	iommu_group_put(group);
> +
> +	return ret;
> +}
> +
> +static void exynos_iommu_remove_device(struct device *dev)
> +{
> +	iommu_group_remove_device(dev);
> +}
> +
>  static struct iommu_ops exynos_iommu_ops = {
>  	.domain_init = &exynos_iommu_domain_init,
>  	.domain_destroy = &exynos_iommu_domain_destroy,
> @@ -1142,6 +1164,8 @@ static struct iommu_ops exynos_iommu_ops = {
>  	.map = &exynos_iommu_map,
>  	.unmap = &exynos_iommu_unmap,
>  	.iova_to_phys = &exynos_iommu_iova_to_phys,
> +	.add_device	= exynos_iommu_add_device,
> +	.remove_device	= exynos_iommu_remove_device,
>  	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
>  };
> 
> --
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-
> soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

