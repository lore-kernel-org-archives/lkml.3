Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3CMGxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:53:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54973 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab3CMGxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:53:06 -0400
X-AuditID: cbfee690-b7f656d0000007e3-89-51402250514b
Message-id: <51402256.3030704@samsung.com>
Date: Wed, 13 Mar 2013 15:53:10 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] mmc: dw_mmc: move host->data_offset init earlier
References: <1363085034-9270-1-git-send-email-james.hogan@imgtec.com>
In-reply-to: <1363085034-9270-1-git-send-email-james.hogan@imgtec.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+Zpm6AkkOgwbmfHBaXd81hszjyv5/R
	gcnj8ya5AMYoLpuU1JzMstQifbsEroyJG2eyFawQrni2eApbA+MV/i5GDg4JAROJq1tUuxg5
	gUwxiQv31rN1MXJxCAksY5TY/uECI0TCROLGz32MEIlFjBJt/SeZIZyXjBJvl+9iApnEK6Al
	ce44M0gDi4CqxLaTS1lAbDYBHYnt344zgdiiAmESK6dfAYvzCghK/Jh8D8wWEdCQWHOpF6yG
	WWAVo8SO7hwQW1jAVeLrh68sIOOFgOzrq0NAwpwCbhJnfy5nhijXkdjfOo0NwpaX2LzmLdhp
	EgL97BLbnpxghbhHQOLb5EMsEA/LSmw6wAzxl6TEwRU3WCYwis1CctEsJGNnIRm7gJF5FaNo
	akFyQXFSepGJXnFibnFpXrpecn7uJkZIZEzYwXjvgPUhxmSglROZpUST84GRlVcSb2hsZmRh
	amJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRlGOiurABzu1tng7
	5EkKqty3cTQz0n20gyUzO4KrQYvny+vnmhsDrgXuXhjKkc5wwSmp4vGWg5Pipm/1Fcz61Z26
	/MNh/ZTuZmsN8/meOzeyMf8Tnpp39+Lzfu80fS2VWiP+5Y6tOZ1Wnx7+jr9Q6f3ppYS+1nqR
	Jdc0631n73u66LqJD3u5EktxRqKhFnNRcSIA1nl0baICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t9jAV1/JYdAgw/frCwu75rDZnHkfz+j
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZEzfOZCtYIVzx
	bPEUtgbGK/xdjJwcEgImEjd+7mOEsMUkLtxbz9bFyMUhJLCIUaKt/yQzhPOSUeLt8l1MXYwc
	HLwCWhLnjjODNLAIqEpsO7mUBcRmE9CR2P7tOBOILSoQJrFy+hWwOK+AoMSPyffAbBEBDYk1
	l3rBapgFVjFK7OjOAbGFBVwlvn74ygIyXgjIvr46BCTMKeAmcfbncmaIch2J/a3T2CBseYnN
	a94yT2AUmIVkwywkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERx5z6R2MK5s
	sDjEKMDBqMTDK/DVPlCINbGsuDL3EKMEB7OSCG/bJaAQb0piZVVqUX58UWlOavEhxmRgAExk
	lhJNzgcmhbySeENjEzMjSyMzYxNzY2PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYAx8
	NrF7x0vnmdEfBE3m37+9d5/+He3Een01ntt34mt3KNT7uqRq66w5FB+75c3zba/vMNz9OWPJ
	tApPLcZX7Z4u249afvlv8Lj72SHJVfw3ps6dfuf4U/EZ+xJrneXmaC26UPY4W74urnapXPT7
	0CXPvdqNonQqTx202msZfj0lUiWj0n7+it1KLMUZiYZazEXFiQCSaPdkAAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

There is no reason that can't change the verid check position.
So this patch looks good to me.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 03/12/2013 07:43 PM, James Hogan wrote:
> host->data_offset is initialised at the end of the probe function
> depending on the VERID register, and is used for PIO operations. Move
> this initialisation earlier, before IRQs or slots are initialised, to be
> sure that PIO won't occur prior to host->data_offset being initialised.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Seungwon Jeon <tgih.jun@samsung.com>
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Cc: Chris Ball <cjb@laptop.org>
> ---
> Note, I didn't actually observe this problem occuring, but I think in
> theory it could happen.
> 
>  drivers/mmc/host/dw_mmc.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 1a42c7c..7556456 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2289,6 +2289,18 @@ int dw_mci_probe(struct dw_mci *host)
>  	mci_writel(host, CLKENA, 0);
>  	mci_writel(host, CLKSRC, 0);
>  
> +	/*
> +	 * In 2.40a spec, Data offset is changed.
> +	 * Need to check the version-id and set data-offset for DATA register.
> +	 */
> +	host->verid = SDMMC_GET_VERID(mci_readl(host, VERID));
> +	dev_info(host->dev, "Version ID is %04x\n", host->verid);
> +
> +	if (host->verid < DW_MMC_240A)
> +		host->data_offset = DATA_OFFSET;
> +	else
> +		host->data_offset = DATA_240A_OFFSET;
> +
>  	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
>  	host->card_workqueue = alloc_workqueue("dw-mci-card",
>  			WQ_MEM_RECLAIM | WQ_NON_REENTRANT, 1);
> @@ -2337,18 +2349,6 @@ int dw_mci_probe(struct dw_mci *host)
>  		goto err_workqueue;
>  	}
>  
> -	/*
> -	 * In 2.40a spec, Data offset is changed.
> -	 * Need to check the version-id and set data-offset for DATA register.
> -	 */
> -	host->verid = SDMMC_GET_VERID(mci_readl(host, VERID));
> -	dev_info(host->dev, "Version ID is %04x\n", host->verid);
> -
> -	if (host->verid < DW_MMC_240A)
> -		host->data_offset = DATA_OFFSET;
> -	else
> -		host->data_offset = DATA_240A_OFFSET;
> -
>  	if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO)
>  		dev_info(host->dev, "Internal DMAC interrupt fix enabled.\n");
>  
> 

