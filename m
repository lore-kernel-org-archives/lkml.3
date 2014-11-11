Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaKKDII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:08:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48838 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKKDIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:08:02 -0500
X-AuditID: cbfee691-f79b86d000004a5a-72-54617d8fcaab
Message-id: <54617D8F.8060506@samsung.com>
Date: Tue, 11 Nov 2014 12:07:59 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Avi Shchislowski <avi.shchislowski@sandisk.com>, ulf.hansson@linaro.org
Cc: "'Chris Ball'" <chris@printf.net>, linux-mmc@vger.kernel.org,
        Alex.Lemberg@sandisk.com, gwendal@google.com,
        open list <linux-kernel@vger.kernel.org>, CPGS <cpgs@samsung.com>
Subject: Re: [PATCH 1/3] mmc: Support FFU for eMMC v5.0
References: <n@samsung.com>
 <1415639632-878-1-git-send-email-avi.shchislowski@sandisk.com>
In-reply-to: <1415639632-878-1-git-send-email-avi.shchislowski@sandisk.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWyRsSkUHdCbWKIwR8li5sPfrBZ7Ny7jsli
	wuXtjBYvD2la3N05gdHi8q45bBZH/vczWhxfG+7A4bFgU6nHnWt72DxuvFrI5NG3ZRWjx7Q1
	55k8Pm+SC2CL4rJJSc3JLEst0rdL4Mr4cWQHU8F3qYr2C69YGxgXiHYxcnJICJhIzO9dyQph
	i0lcuLeerYuRi0NIYCmjxLrV65hgihonPmGCSExnlGi/eY8ZwnnNKHF2wVU2kCpeAS2JM9Pf
	gtksAqoSO/euZAGx2QR0JLZ/Ow42SVQgTOJQ2zwmiHpBiR+T74HViAh4Sxw59ZMdZCizwGZG
	iT3tH4A2cHAIC5hLXH5nA1IjJBAjMf3MH7B6TqD6ORPbGUFsZqD5+1unsUHY8hKb17xlhrj6
	GrvEg6sSEPcISHybfIgFZKSEgKzEpgNQJZISB1fcYJnAKDYLyUWzkEydhWTqAkbmVYyiqQXJ
	BcVJ6UWmesWJucWleel6yfm5mxiBMXj637OJOxjvH7A+xCjAwajEw6vhnxgixJpYVlyZe4jR
	FOiKicxSosn5wEjPK4k3NDYzsjA1MTU2Mrc0UxLn1ZH+GSwkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBkWmRyk/vcB+77JxbndPdchmXufzU3v5CNTdF7TbPC0Pr4wdOf9TXeBq/qNvpyCKR
	ldwH17c6RTt1mkzI31tmn3WWadeepW3//unoi8lnl3AcjU5gfXjyYrvjl5WVUy+tfKR9YErw
	ZVaTtlrzaT/Cd7dWTco6xfB6w1ZDadn+mWqbil1ZbswrU2Ipzkg01GIuKk4EAG71FZW8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jQd3+2sQQg40nTCxuPvjBZrFz7zom
	iwmXtzNavDykaXF35wRGi8u75rBZHPnfz2hxfG24A4fHgk2lHneu7WHzuPFqIZNH35ZVjB7T
	1pxn8vi8SS6ALaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aPIzuYCr5L
	VbRfeMXawLhAtIuRk0NCwESiceITJghbTOLCvfVsXYxcHEIC0xkl2m/eY4ZwXjNKnF1wlQ2k
	ildAS+LM9LdgNouAqsTOvStZQGw2AR2J7d+Og00SFQiTONQ2jwmiXlDix+R7YDUiAt4SR079
	ZAcZyiywmVFiT/sHoA0cHMIC5hKX39mA1AgJxEhMP/MHrJ4TqH7OxHZGEJsZaP7+1mlsELa8
	xOY1b5knMArMQrJiFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjvJnUjsY
	VzZYHGIU4GBU4uHV9E8MEWJNLCuuzD3EKMHBrCTCW58AFOJNSaysSi3Kjy8qzUktPsRoCgyB
	icxSosn5wASUVxJvaGxiZmRpZG5oYWRsriTOe6DVOlBIID2xJDU7NbUgtQimj4mDU6qB0bxm
	YZfOpopn4jNEzzvyxvRP+loeZJTfuLlxyras6Psy4QErnW2as5b1pNraxbNfcJvyqYB5Vuwr
	HYc3q4K0ebu4dBpmsZk9+1Rltcg1njv8ipvBt7w7Jw//rfkoOtt215W1v32e+9THXuJ67fho
	ToX+esd87Uk3bgvd9t6Xfkvf4XHIEfvrSizFGYmGWsxFxYkAGLgaKAgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

how did you make the patch?
This patch didn't apply at Ulf's repository.


On 11/11/2014 02:13 AM, Avi Shchislowski wrote:
> 
> Add eMMC5.0 ffu ext_csd fields
> 
> Signed-off-by: Avi Shchislowski <avi.shchislowski@sandisk.com>
> Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>
> 
> 
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 1eda8dd..3b86ed3 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -603,6 +603,15 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
>  		card->ext_csd.data_sector_size = 512;
>  	}
>  
> +	/* eMMC v5 or later */
> +	if (card->ext_csd.rev >= 7) {
> +		card->ext_csd.ffu_capable =
> +			((ext_csd[EXT_CSD_SUPPORTED_MODE] & 0x1) == 0x1) &&
> +			((ext_csd[EXT_CSD_FW_CONFIG] & 0x1) == 0x0);

if (ext_csd[EXT_CSD_SUPPORTED_MODE] & 0x1) &&  !(ext_csd[EXT_CSD_FW_CONFIG] & 0x1))
		card->ext_csd.ffu_capable = true;

> +		card->ext_csd.ffu_mode_op = ext_csd[EXT_CSD_FFU_FEATURES];
> +	} else {
> +		card->ext_csd.ffu_capable = false;

Can be set to false by default before checking whether card is eMMC v5.0 or not.

card->ext_csd.ffu_capable = false;

if (card->ext_csd.rev >= 7) {
	...
}

Best Regards,
Jaehoon Chung

> +	}
>  out:
>  	return err;
>  }
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index d424b9d..dd01efe 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -81,6 +81,8 @@ struct mmc_ext_csd {
>  	bool			hpi_en;			/* HPI enablebit */
>  	bool			hpi;			/* HPI support bit */
>  	unsigned int		hpi_cmd;		/* cmd used as HPI */
> +	bool			ffu_capable;		/* FFU support */
> +	bool			ffu_mode_op;		/* FFU mode operation */
>  	bool			bkops;		/* background support bit */
>  	bool			bkops_en;	/* background enable bit */
>  	unsigned int            data_sector_size;       /* 512 bytes or 4KB */
> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
> index 64ec963..787787b 100644
> --- a/include/linux/mmc/mmc.h
> +++ b/include/linux/mmc/mmc.h
> @@ -272,6 +272,9 @@ struct _mmc_csd {
>   * EXT_CSD fields
>   */
>  
> +#define EXT_CSD_FFU_STATUS		26	/* R */
> +#define EXT_CSD_MODE_OPERATION_CODES	29	/* W */
> +#define EXT_CSD_MODE_CONFIG		30	/* R/W */
>  #define EXT_CSD_FLUSH_CACHE		32      /* W */
>  #define EXT_CSD_CACHE_CTRL		33      /* R/W */
>  #define EXT_CSD_POWER_OFF_NOTIFICATION	34	/* R/W */
> @@ -290,6 +293,7 @@ struct _mmc_csd {
>  #define EXT_CSD_SANITIZE_START		165     /* W */
>  #define EXT_CSD_WR_REL_PARAM		166	/* RO */
>  #define EXT_CSD_RPMB_MULT		168	/* RO */
> +#define EXT_CSD_FW_CONFIG		169	/* R/W */
>  #define EXT_CSD_BOOT_WP			173	/* R/W */
>  #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
>  #define EXT_CSD_PART_CONFIG		179	/* R/W */
> @@ -326,6 +330,11 @@ struct _mmc_csd {
>  #define EXT_CSD_GENERIC_CMD6_TIME	248	/* RO */
>  #define EXT_CSD_CACHE_SIZE		249	/* RO, 4 bytes */
>  #define EXT_CSD_PWR_CL_DDR_200_360	253	/* RO */
> +#define EXT_CSD_NUM_OF_FW_SEC_PROG	302	/* RO, 4 bytes */
> +#define EXT_CSD_FFU_ARG			487	/* RO, 4 bytes */
> +#define EXT_CSD_OPERATION_CODE_TIMEOUT	491	/* RO */
> +#define EXT_CSD_FFU_FEATURES		492	/* RO */
> +#define EXT_CSD_SUPPORTED_MODE		493	/* RO */
>  #define EXT_CSD_TAG_UNIT_SIZE		498	/* RO */
>  #define EXT_CSD_DATA_TAG_SUPPORT	499	/* RO */
>  #define EXT_CSD_MAX_PACKED_WRITES	500	/* RO */
> 

