Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab3C3UTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 16:19:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:43203 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab3C3UTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 16:19:12 -0400
Message-ID: <51573AAE.1000100@infradead.org>
Date: Sat, 30 Mar 2013 12:19:10 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial]treewide: Fix typos in printk
References: <1364660630-30763-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1364660630-30763-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/13 09:23, Masanari Iida wrote:
> Correct spelling typos in various part of printk.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/gpu/drm/i915/intel_dp.c                 | 2 +-
>  drivers/i2c/busses/i2c-puv3.c                   | 2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 2 +-
>  drivers/net/ethernet/atheros/atl1c/atl1c_hw.c   | 2 +-
>  drivers/scsi/lpfc/lpfc_bsg.c                    | 2 +-
>  drivers/scsi/osd/osd_initiator.c                | 2 +-
>  drivers/video/exynos/exynos_dp_core.c           | 4 ++--
>  tools/power/cpupower/debug/i386/intel_gsic.c    | 2 +-
>  8 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 662a185..6d84431 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -1975,7 +1975,7 @@ intel_dp_complete_link_train(struct intel_dp *intel_dp)
>  	}
>  
>  	if (channel_eq)
> -		DRM_DEBUG_KMS("Channel EQ done. DP Training successfull\n");
> +		DRM_DEBUG_KMS("Channel EQ done. DP Training successful\n");
>  
>  	intel_dp_set_link_train(intel_dp, DP, DP_TRAINING_PATTERN_DISABLE);
>  }
> diff --git a/drivers/i2c/busses/i2c-puv3.c b/drivers/i2c/busses/i2c-puv3.c
> index 261d7db..8acef65 100644
> --- a/drivers/i2c/busses/i2c-puv3.c
> +++ b/drivers/i2c/busses/i2c-puv3.c
> @@ -199,7 +199,7 @@ static int puv3_i2c_probe(struct platform_device *pdev)
>  
>  	adapter = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
>  	if (adapter == NULL) {
> -		dev_err(&pdev->dev, "can't allocate inteface!\n");
> +		dev_err(&pdev->dev, "can't allocate interface!\n");
>  		rc = -ENOMEM;
>  		goto fail_nomem;
>  	}
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index beb6dba..98a9c09 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -1312,7 +1312,7 @@ static inline int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev)
>  	int cnt;
>  
>  	spin_lock_irqsave(&dev->condlock, flags);
> -	mfc_debug(2, "Previos context: %d (bits %08lx)\n", dev->curr_ctx,
> +	mfc_debug(2, "Previous context: %d (bits %08lx)\n", dev->curr_ctx,
>  							dev->ctx_work_bits);
>  	new_ctx = (dev->curr_ctx + 1) % MFC_NUM_CONTEXTS;
>  	cnt = 0;
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
> index 21e261f..3ef7092 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
> @@ -810,7 +810,7 @@ int atl1c_power_saving(struct atl1c_hw *hw, u32 wufc)
>  	if (wufc & AT_WUFC_LNKC) {
>  		wol_ctrl |= WOL_LINK_CHG_EN | WOL_LINK_CHG_PME_EN;
>  		if (atl1c_write_phy_reg(hw, MII_IER, IER_LINK_UP) != 0) {
> -			dev_dbg(&pdev->dev, "%s: write phy MII_IER faild.\n",
> +			dev_dbg(&pdev->dev, "%s: write phy MII_IER failed.\n",
>  				atl1c_driver_name);
>  		}
>  	}
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index 32d5683..f5d1064 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -4741,7 +4741,7 @@ lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
>  	if (job->request_len <
>  	    sizeof(struct fc_bsg_request) + sizeof(struct dfc_mbox_req)) {
>  		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
> -				"2737 Mix-and-match backward compability "
> +				"2737 Mix-and-match backward compatibility "
>  				"between MBOX_REQ old size:%d and "
>  				"new request size:%d\n",
>  				(int)(job->request_len -
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index d8293f2..aa66361 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1049,7 +1049,7 @@ static struct bio *_create_sg_bios(struct osd_request *or,
>  
>  	bio = bio_kmalloc(GFP_KERNEL, numentries);
>  	if (unlikely(!bio)) {
> -		OSD_DEBUG("Faild to allocate BIO size=%u\n", numentries);
> +		OSD_DEBUG("Failed to allocate BIO size=%u\n", numentries);
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> index de9d4da..12bbede 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -976,14 +976,14 @@ static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
>  	}
>  
>  	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
> -		dev_err(dp->dev, "faild to get reg for dptx-phy\n");
> +		dev_err(dp->dev, "failed to get reg for dptx-phy\n");
>  		ret = -EINVAL;
>  		goto err;
>  	}
>  
>  	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
>  				&dp->enable_mask)) {
> -		dev_err(dp->dev, "faild to get enable-mask for dptx-phy\n");
> +		dev_err(dp->dev, "failed to get enable-mask for dptx-phy\n");
>  		ret = -EINVAL;
>  		goto err;
>  	}
> diff --git a/tools/power/cpupower/debug/i386/intel_gsic.c b/tools/power/cpupower/debug/i386/intel_gsic.c
> index 53f5293..d032c82 100644
> --- a/tools/power/cpupower/debug/i386/intel_gsic.c
> +++ b/tools/power/cpupower/debug/i386/intel_gsic.c
> @@ -66,7 +66,7 @@ int main (void)
>  		printf("ecx = 0x%.8x\n", r.ecx);
>  		printf("edx = 0x%.8x\n", r.edx);
>  		printf("Note also that some BIOS do not support the initial "
> -		       "GSIC call, but the newer\nspeeedstep-smi driver may "
> +		       "GSIC call, but the newer\nspeedstep-smi driver may "
>  		       "work.\nFor this, you need to pass some arguments to "
>  		       "the speedstep-smi driver:\n");
>  		printf("\tsmi_cmd=0x?? smi_port=0x?? smi_sig=1\n");
> 


-- 
~Randy
