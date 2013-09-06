Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750815Ab3IFIFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 04:05:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18710 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3IFIFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 04:05:12 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-17-52298caf0987
To: undisclosed-recipients:;
Message-id: <52298CC3.8020308@samsung.com>
Date: Fri, 06 Sep 2013 17:05:23 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: sdhci: add support for pre_req and post_req
References: <1378447313-12935-1-git-send-email-chanho.min@lge.com>
In-reply-to: <1378447313-12935-1-git-send-email-chanho.min@lge.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWyRsSkWHd9j2aQwc35HBaXd81hszjyv5/R
	gcnj8ya5AMYoLpuU1JzMstQifbsErozpSyYwFXwxqvizeDZbA+ND9S5GTg4JAROJne/fMUHY
	YhIX7q1n62Lk4hASWMooMf34QhaYosWNLYwQiUWMEr3zH7CDJEQEZCTmzn7MCpF4zSjxed4E
	sFG8AloSW9o2ASU4OFgEVCX6enVAwmwCOhLbvx0HKxEVCJN48WoXM0S5oMSPyffAljELWEv8
	/NHKCmILC7hKnNmyjg3EFhJwkphw8g2YzSngLNHcO5Mdol5HYn/rNDYIW15i85q3zCD3SAh0
	s0scODUVbBmLgIDEt8mHWEDukRCQldh0gBniMUmJgytusExgFJuF5IxZSMbOQjJ2ASPzKkbR
	1ILkguKk9CJDveLE3OLSvHS95PzcTYzA6Dj971nvDsbbB6wPMSYDrZzILCWanA+MrrySeENj
	MyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MPYfqXn0+dBZ
	znnmLxIaKyVTtiosKxT4wuOlxOisvYfxWnTGpxP6y0/eFLD7vJz3nKOs0p93V6ueVeyrv3xw
	kXzwJtbW93vuhSxNUfR7dKLhYLjB1pZVbdEs5sznZbvjGV84LZp/TbAyalbx76bndloZOn5d
	C/7duJFvs3FdlWnNO1kfPs+dnEosxRmJhlrMRcWJALEVw+ykAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t9jAd31PZpBBh8sLS7vmsNmceR/P6MD
	k8fnTXIBjFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6
	bpk5QJOVFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBnTl0xgKvhiVPFn
	8Wy2BsaH6l2MnBwSAiYSixtbGCFsMYkL99azdTFycQgJLGKU6J3/gB0kISIgIzF39mNWiMRr
	RonP8yYwgSR4BbQktrRtAkpwcLAIqEr09eqAhNkEdCS2fzsOViIqECbx4tUuZohyQYkfk++x
	gNjMAtYSP3+0soLYwgKuEme2rGMDsYUEnCQmnHwDZnMKOEs0985kh6jXkdjfOo0NwpaX2Lzm
	LfMERoFZSMbOQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBkfdMagfjygaL
	Q4wCHIxKPLwcPRpBQqyJZcWVuYcYJTiYlUR4xTU0g4R4UxIrq1KL8uOLSnNSiw8xJgM9PZFZ
	SjQ5H5gU8kriDY1NzIwsjcwNLYyMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBMfaw
	iupLzYirXibrH7dlWt37ubw9bXte36N5P/a3v/ddazPHd9/8PXbizLsiHjNMC0t3+Gtz5uxF
	pQ8z889v2/SRidd8/8xZ0yatWV5oYxbybRvPtM/Hi5KDkhou9fGFiJbV35L7HdHisOTxtYxu
	h/g7Jwxckq3FLNQj3rse3pvys5vtX4KBtRJLcUaioRZzUXEiAKb+id0AAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Chanho.

I remembered Shawn Guo had posted this patch.
Do you resend it?

Best Regards,
Jaehoon Chung

On 09/06/2013 03:01 PM, Chanho Min wrote:
> This patch supports non-blocking mmc request function for the sdchi driver.
> (commit: aa8b683a7d392271ed349c6ab9f36b8c313794b7)
> 
> pre_req() runs dma_map_sg(), post_req() runs dma_unmap_sg.  If not calling
> pre_req() before sdhci_request(), dma_map_sg will be issued before
> starting the transfer.  It is optional to use pre_req().  If issuing
> pre_req(), post_req() must be called as well.
> 
> benchmark results:
>  ARM CA9 1GHz, UHS DDR50 mode
> 
>  Before:
>  dd if=/dev/mmcblk0p15 of=/dev/null bs=64k count=1024
>  67108864 bytes (64.0MB) copied, 1.188846 seconds, 53.8MB/s
> 
>  After:
>  dd if=/dev/mmcblk0p15 of=/dev/null bs=64k count=1024
>  67108864 bytes (64.0MB) copied, 0.993098 seconds, 64.4MB/s
> 
> Signed-off-by: Chanho Min <chanho.min@lge.com>
> ---
>  drivers/mmc/host/sdhci.c  |   96 +++++++++++++++++++++++++++++++++++++++------
>  include/linux/mmc/sdhci.h |    6 +++
>  2 files changed, 90 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 2ea429c..0465a9a 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -465,6 +465,42 @@ static void sdhci_set_adma_desc(u8 *desc, u32 addr, int len, unsigned cmd)
>  	dataddr[0] = cpu_to_le32(addr);
>  }
>  
> +static int sdhci_pre_dma_transfer(struct sdhci_host *host,
> +				       struct mmc_data *data,
> +				       struct sdhci_next *next)
> +{
> +	int sg_count = 0;
> +
> +	if (!next && data->host_cookie &&
> +	    data->host_cookie != host->next_data.cookie) {
> +		pr_warn("[%s] invalid cookie: data->host_cookie %d"
> +			" host->next_data.cookie %d\n",
> +			__func__, data->host_cookie, host->next_data.cookie);
> +		data->host_cookie = 0;
> +	}
> +
> +	/* Check if next job is already prepared */
> +	if (next ||
> +	    (!next && data->host_cookie != host->next_data.cookie)) {
> +		sg_count = dma_map_sg(mmc_dev(host->mmc), data->sg,
> +					data->sg_len,
> +					(data->flags & MMC_DATA_READ) ?
> +						DMA_FROM_DEVICE :
> +						DMA_TO_DEVICE);
> +	} else {
> +		sg_count = host->next_data.sg_count;
> +		host->next_data.sg_count = 0;
> +	}
> +
> +	if (next) {
> +		next->sg_count = sg_count;
> +		data->host_cookie = ++next->cookie < 0 ? 1 : next->cookie;
> +	} else
> +		host->sg_count = sg_count;
> +
> +	return sg_count;
> +}
> +
>  static int sdhci_adma_table_pre(struct sdhci_host *host,
>  	struct mmc_data *data)
>  {
> @@ -502,8 +538,8 @@ static int sdhci_adma_table_pre(struct sdhci_host *host,
>  		goto fail;
>  	BUG_ON(host->align_addr & 0x3);
>  
> -	host->sg_count = dma_map_sg(mmc_dev(host->mmc),
> -		data->sg, data->sg_len, direction);
> +	host->sg_count = sdhci_pre_dma_transfer(host, data, NULL);
> +
>  	if (host->sg_count == 0)
>  		goto unmap_align;
>  
> @@ -643,9 +679,10 @@ static void sdhci_adma_table_post(struct sdhci_host *host,
>  			}
>  		}
>  	}
> -
> -	dma_unmap_sg(mmc_dev(host->mmc), data->sg,
> -		data->sg_len, direction);
> +	if (!data->host_cookie) {
> +		dma_unmap_sg(mmc_dev(host->mmc), data->sg,
> +			data->sg_len, direction);
> +	}
>  }
>  
>  static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
> @@ -824,12 +861,8 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
>  			}
>  		} else {
>  			int sg_cnt;
> +			sg_cnt = sdhci_pre_dma_transfer(host, data, NULL);
>  
> -			sg_cnt = dma_map_sg(mmc_dev(host->mmc),
> -					data->sg, data->sg_len,
> -					(data->flags & MMC_DATA_READ) ?
> -						DMA_FROM_DEVICE :
> -						DMA_TO_DEVICE);
>  			if (sg_cnt == 0) {
>  				/*
>  				 * This only happens when someone fed
> @@ -928,9 +961,12 @@ static void sdhci_finish_data(struct sdhci_host *host)
>  		if (host->flags & SDHCI_USE_ADMA)
>  			sdhci_adma_table_post(host, data);
>  		else {
> -			dma_unmap_sg(mmc_dev(host->mmc), data->sg,
> -				data->sg_len, (data->flags & MMC_DATA_READ) ?
> +			if (!data->host_cookie) {
> +				dma_unmap_sg(mmc_dev(host->mmc), data->sg,
> +					data->sg_len,
> +					(data->flags & MMC_DATA_READ) ?
>  					DMA_FROM_DEVICE : DMA_TO_DEVICE);
> +			}
>  		}
>  	}
>  
> @@ -2066,8 +2102,42 @@ static void sdhci_card_event(struct mmc_host *mmc)
>  	spin_unlock_irqrestore(&host->lock, flags);
>  }
>  
> +static void sdhci_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
> +				int err)
> +{
> +	struct sdhci_host *host = mmc_priv(mmc);
> +	struct mmc_data *data = mrq->data;
> +
> +	if (host->flags & SDHCI_REQ_USE_DMA) {
> +		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
> +			(data->flags & MMC_DATA_READ) ?
> +			DMA_FROM_DEVICE :
> +			DMA_TO_DEVICE);
> +		data->host_cookie = 0;
> +	}
> +}
> +
> +static void sdhci_pre_req(struct mmc_host *mmc, struct mmc_request *mrq,
> +			       bool is_first_req)
> +{
> +	struct sdhci_host *host = mmc_priv(mmc);
> +	struct mmc_data *data = mrq->data;
> +
> +	if (mrq->data->host_cookie) {
> +		mrq->data->host_cookie = 0;
> +		return;
> +	}
> +
> +	if (host->flags & SDHCI_REQ_USE_DMA) {
> +		if (!sdhci_pre_dma_transfer(host, data, &host->next_data))
> +			mrq->data->host_cookie = 0;
> +	}
> +}
> +
>  static const struct mmc_host_ops sdhci_ops = {
>  	.request	= sdhci_request,
> +	.post_req	= sdhci_post_req,
> +	.pre_req	= sdhci_pre_req,
>  	.set_ios	= sdhci_set_ios,
>  	.get_cd		= sdhci_get_cd,
>  	.get_ro		= sdhci_get_ro,
> @@ -3204,6 +3274,8 @@ int sdhci_add_host(struct sdhci_host *host)
>  	}
>  #endif
>  
> +	host->next_data.cookie = 1;
> +
>  	mmiowb();
>  
>  	mmc_add_host(mmc);
> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
> index b838ffc..220a515 100644
> --- a/include/linux/mmc/sdhci.h
> +++ b/include/linux/mmc/sdhci.h
> @@ -17,6 +17,11 @@
>  #include <linux/io.h>
>  #include <linux/mmc/host.h>
>  
> +struct sdhci_next {
> +	unsigned int	sg_count;
> +	s32		cookie;
> +};
> +
>  struct sdhci_host {
>  	/* Data set by hardware interface driver */
>  	const char *hw_name;	/* Hardware bus name */
> @@ -177,5 +182,6 @@ struct sdhci_host {
>  	struct timer_list	tuning_timer;	/* Timer for tuning */
>  
>  	unsigned long private[0] ____cacheline_aligned;
> +	struct sdhci_next	next_data;
>  };
>  #endif /* LINUX_MMC_SDHCI_H */
> 

