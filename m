Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaHGIlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:41:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36328 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbaHGIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:40:58 -0400
X-AuditID: cbfee691-b7f306d000003d81-34-53e33b971ed7
Message-id: <53E33B97.90602@samsung.com>
Date: Thu, 07 Aug 2014 17:40:55 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Sonny Rao <sonnyrao@chromium.org>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: dianders@chromium.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-samsung-soc@vger.kernel.org,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>, grundler@chromium.org,
        t.figa@samsung.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, joshi@samsung.com,
        jh80.chung@samsung.com, tgih.jun@samsung.com,
        linux-next@vger.kernel.org, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mmc: dw_mmc: change to use recommended reset procedure
References: <CAPDyKFq2isO+DKMuLT9Ud8B9reFZiVYKG6LL8ysF0ZTNGfY8Nw@mail.gmail.com>
 <1407201590-26740-1-git-send-email-sonnyrao@chromium.org>
In-reply-to: <1407201590-26740-1-git-send-email-sonnyrao@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsWyRsSkRHe69eNgg7lv1Cy2v97IZnF22UE2
	i1dHfjBZ3PjVxmrxfdcXdoveBVfZLDY9vsZqcXnXHDaLI//7GS0OLmxjtJhxfh+Txda9V9kt
	npyZyWixfsZrFosP9y8yWxxfG25x9lS5g6BH440bbB6zGy6yeBy6spbR4861PWwem5fUe/Rt
	WcXo8XmTXAB7FJdNSmpOZllqkb5dAlfGySV2BfuMKuZvamdtYFyj3sXIySEhYCLx43cPC4Qt
	JnHh3nq2LkYuDiGBpYwSX1beZYEpam+YB5WYzijRf+8bO4TzmlGi+9FtNpAqXgENiT87brKC
	2CwCqhLX9s0C62YT0JHY/u04E4gtKhAmcahtHhNEvaDEj8n3wGpEBLwlbkw5xwgylFlgJbPE
	mkd/wIqEgRKPP7ayQmzrY5Q4f/4J2AZOATeJRZc2gRUxA23Y3zqNDcKWl9i85i0zSIOEwFwO
	ib3P/7NDnCQg8W3yIaB1HEAJWYlNB5ghfpOUOLjiBssERrFZSI6ahWTsLCRjFzAyr2IUTS1I
	LihOSi8y1StOzC0uzUvXS87P3cQIjPbT/55N3MF4/4D1IcZkoJUTmaVEk/OBySKvJN7Q2MzI
	wtTE1NjI3NKMNGElcd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjrRZN/l2+ryHt4
	/GT78+6HTn4XHvkbbQy2sjwgOe3bfa7Vu6do6UXcMtN5sfI0h41iIKOUzq+bDJ8r3LI945fP
	e22u8zJHcLo5B9Nh20mCR09+jvlg37Qjv6Sq/cj6iTevLC0+qRrHf+XTLf3LNyWz78bNkWXR
	ublDsuB1St27R9eWbijlDfFWYinOSDTUYi4qTgQAhDbqYAwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd3p1o+DDW53y1psf72RzeLssoNs
	Fq+O/GCyuPGrjdXi+64v7Ba9C66yWWx6fI3V4vKuOWwWR/73M1ocXNjGaDHj/D4mi617r7Jb
	PDkzk9Fi/YzXLBYf7l9ktji+Ntzi7KlyB0GPxhs32DxmN1xk8Th0ZS2jx51re9g8Ni+p9+jb
	sorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRef
	AF23zBygB5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGSeX2BXsM6qY
	v6mdtYFxjXoXIyeHhICJRHvDPDYIW0ziwr31QDYXh5DAdEaJ/nvf2CGc14wS3Y9ug1XxCmhI
	/NlxkxXEZhFQlbi2bxYLiM0moCOx/dtxJhBbVCBM4lDbPCaIekGJH5PvgdWICHhL3JhyjhFk
	KLPASmaJNY/+gBUJAyUef2xlhdjWxyhx/vwTsA2cAm4Siy5tAitiBtqwv3UaG4QtL7F5zVvm
	CYwCs5AsmYWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxglPJM+kdjKsaLA4x
	CnAwKvHwWjY9ChZiTSwrrsw9xCjBwawkwvuK73GwEG9KYmVValF+fFFpTmrxIUZTYBhMZJYS
	Tc4Hprm8knhDYxMzI0sjc0MLI2NzJXHeg63WgUIC6YklqdmpqQWpRTB9TBycUsBEsff8rKvB
	Dzrq+a5GVE6eaLPxyp73WoKP+1nKb1aL2/e4RG65PlE9lH9azYetOVfX/H0vc119ulU6765a
	+yUz1wvPjz3B2Re+bqvKzyZtFpnLiT7XZjLNvP35Ys73173rM9QPpX28K1z+QLbbJy27Re74
	zg+7hB8zZrya5vx3k3u95Yne05ZMSizFGYmGWsxFxYkAfhQp3zsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I remembered that this patch was pushed at Ulf's tree.

Since dw_mci_idmac_reset() is located into #if CONFIG_MMC_DW_IDMAC,
it occurred the compiler error.
And it seems that didn't need to use "IS_ENABLED()" at there.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 08/05/2014 10:19 AM, Sonny Rao wrote:
> This patch changes the fifo reset code to follow the reset procedure
> outlined in the documentation of Synopsys Mobile storage host databook.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> [sonnyrao: fix compile for !CONFIG_MMC_DW_IDMAC case]
> ---
>  drivers/mmc/host/dw_mmc.c | 87 ++++++++++++++++++++++++++++++++++-------------
>  drivers/mmc/host/dw_mmc.h |  5 +++
>  2 files changed, 69 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 1ac227c..39cf54f 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -111,8 +111,7 @@ static const u8 tuning_blk_pattern_8bit[] = {
>  	0xff, 0x77, 0x77, 0xff, 0x77, 0xbb, 0xdd, 0xee,
>  };
>  
> -static inline bool dw_mci_fifo_reset(struct dw_mci *host);
> -static inline bool dw_mci_ctrl_all_reset(struct dw_mci *host);
> +static bool dw_mci_reset(struct dw_mci *host);
>  
>  #if defined(CONFIG_DEBUG_FS)
>  static int dw_mci_req_show(struct seq_file *s, void *v)
> @@ -1235,7 +1234,7 @@ static int dw_mci_data_complete(struct dw_mci *host, struct mmc_data *data)
>  		 * After an error, there may be data lingering
>  		 * in the FIFO
>  		 */
> -		dw_mci_fifo_reset(host);
> +		dw_mci_reset(host);
>  	} else {
>  		data->bytes_xfered = data->blocks * data->blksz;
>  		data->error = 0;
> @@ -1352,7 +1351,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
>  
>  			/* CMD error in data command */
>  			if (mrq->cmd->error && mrq->data)
> -				dw_mci_fifo_reset(host);
> +				dw_mci_reset(host);
>  
>  			host->cmd = NULL;
>  			host->data = NULL;
> @@ -1963,14 +1962,8 @@ static void dw_mci_work_routine_card(struct work_struct *work)
>  			}
>  
>  			/* Power down slot */
> -			if (present == 0) {
> -				/* Clear down the FIFO */
> -				dw_mci_fifo_reset(host);
> -#ifdef CONFIG_MMC_DW_IDMAC
> -				dw_mci_idmac_reset(host);
> -#endif
> -
> -			}
> +			if (present == 0)
> +				dw_mci_reset(host);
>  
>  			spin_unlock_bh(&host->lock);
>  
> @@ -2208,8 +2201,11 @@ static bool dw_mci_ctrl_reset(struct dw_mci *host, u32 reset)
>  	return false;
>  }
>  
> -static inline bool dw_mci_fifo_reset(struct dw_mci *host)
> +static bool dw_mci_reset(struct dw_mci *host)
>  {
> +	u32 flags = SDMMC_CTRL_RESET | SDMMC_CTRL_FIFO_RESET;
> +	bool ret = false;
> +
>  	/*
>  	 * Reseting generates a block interrupt, hence setting
>  	 * the scatter-gather pointer to NULL.
> @@ -2219,15 +2215,60 @@ static inline bool dw_mci_fifo_reset(struct dw_mci *host)
>  		host->sg = NULL;
>  	}
>  
> -	return dw_mci_ctrl_reset(host, SDMMC_CTRL_FIFO_RESET);
> -}
> +	if (host->use_dma)
> +		flags |= SDMMC_CTRL_DMA_RESET;
>  
> -static inline bool dw_mci_ctrl_all_reset(struct dw_mci *host)
> -{
> -	return dw_mci_ctrl_reset(host,
> -				 SDMMC_CTRL_FIFO_RESET |
> -				 SDMMC_CTRL_RESET |
> -				 SDMMC_CTRL_DMA_RESET);
> +	if (dw_mci_ctrl_reset(host, flags)) {
> +		/*
> +		 * In all cases we clear the RAWINTS register to clear any
> +		 * interrupts.
> +		 */
> +		mci_writel(host, RINTSTS, 0xFFFFFFFF);
> +
> +		/* if using dma we wait for dma_req to clear */
> +		if (host->use_dma) {
> +			unsigned long timeout = jiffies + msecs_to_jiffies(500);
> +			u32 status;
> +			do {
> +				status = mci_readl(host, STATUS);
> +				if (!(status & SDMMC_STATUS_DMA_REQ))
> +					break;
> +				cpu_relax();
> +			} while (time_before(jiffies, timeout));
> +
> +			if (status & SDMMC_STATUS_DMA_REQ) {
> +				dev_err(host->dev,
> +					"%s: Timeout waiting for dma_req to "
> +					"clear during reset\n", __func__);
> +				goto ciu_out;
> +			}
> +
> +			/* when using DMA next we reset the fifo again */
> +			if (!dw_mci_ctrl_reset(host, SDMMC_CTRL_FIFO_RESET))
> +				goto ciu_out;
> +		}
> +	} else {
> +		/* if the controller reset bit did clear, then set clock regs */
> +		if (!(mci_readl(host, CTRL) & SDMMC_CTRL_RESET)) {
> +			dev_err(host->dev, "%s: fifo/dma reset bits didn't "
> +				"clear but ciu was reset, doing clock update\n",
> +				__func__);
> +			goto ciu_out;
> +		}
> +	}
> +
> +#if IS_ENABLED(CONFIG_MMC_DW_IDMAC)
> +	/* It is also recommended that we reset and reprogram idmac */
> +	dw_mci_idmac_reset(host);
> +#endif
> +
> +	ret = true;
> +
> +ciu_out:
> +	/* After a CTRL reset we need to have CIU set clock registers  */
> +	mci_send_cmd(host->cur_slot, SDMMC_CMD_UPD_CLK, 0);
> +
> +	return ret;
>  }
>  
>  #ifdef CONFIG_OF
> @@ -2425,7 +2466,7 @@ int dw_mci_probe(struct dw_mci *host)
>  	}
>  
>  	/* Reset all blocks */
> -	if (!dw_mci_ctrl_all_reset(host))
> +	if (!dw_mci_ctrl_reset(host, SDMMC_CTRL_ALL_RESET_FLAGS))
>  		return -ENODEV;
>  
>  	host->dma_ops = host->pdata->dma_ops;
> @@ -2612,7 +2653,7 @@ int dw_mci_resume(struct dw_mci *host)
>  		}
>  	}
>  
> -	if (!dw_mci_ctrl_all_reset(host)) {
> +	if (!dw_mci_ctrl_reset(host, SDMMC_CTRL_ALL_RESET_FLAGS)) {
>  		ret = -ENODEV;
>  		return ret;
>  	}
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 738fa24..08fd956 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -129,6 +129,7 @@
>  #define SDMMC_CMD_INDX(n)		((n) & 0x1F)
>  /* Status register defines */
>  #define SDMMC_GET_FCNT(x)		(((x)>>17) & 0x1FFF)
> +#define SDMMC_STATUS_DMA_REQ		BIT(31)
>  /* FIFOTH register defines */
>  #define SDMMC_SET_FIFOTH(m, r, t)	(((m) & 0x7) << 28 | \
>  					 ((r) & 0xFFF) << 16 | \
> @@ -150,6 +151,10 @@
>  /* Card read threshold */
>  #define SDMMC_SET_RD_THLD(v, x)		(((v) & 0x1FFF) << 16 | (x))
>  
> +/* All ctrl reset bits */
> +#define SDMMC_CTRL_ALL_RESET_FLAGS \
> +	(SDMMC_CTRL_RESET | SDMMC_CTRL_FIFO_RESET | SDMMC_CTRL_DMA_RESET)
> +
>  /* Register access macros */
>  #define mci_readl(dev, reg)			\
>  	__raw_readl((dev)->regs + SDMMC_##reg)
> 

