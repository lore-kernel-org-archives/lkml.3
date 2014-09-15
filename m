Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaIOEUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 00:20:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30493 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaIOEUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 00:20:39 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-f79c46d000000b84-9b-541669151e5e
Content-transfer-encoding: 8BIT
Message-id: <54166914.4080706@samsung.com>
Date: Mon, 15 Sep 2014 13:20:36 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
To: =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0002/0003] mmc: Replace "enhanced_area_en" attribute by
 "partition_setting_completed"
References: <53C7E45E.2060102@neotion.com>
 <CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>
 <53EB2DC3.2080002@neotion.com>
 <CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>
 <53ECB95F.2030207@neotion.com>
 <CAPDyKFp2ekmucHVzMWxeKfyTmuFKTXAYwUEpL5QxvEh8AjFopg@mail.gmail.com>
 <53F1FBA3.6060108@neotion.com> <5411435C.3080905@neotion.com>
 <541303B8.2060208@neotion.com>
In-reply-to: <541303B8.2060208@neotion.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWyRsSkUFc0UyzEoG83m8WEy9sZLWb3T2O2
	uLxrDpvFkf/9jBYf7l9ktji+NtyBzePOtT1sHse2SXjceLWQyaNvyypGj8+b5AJYo7hsUlJz
	MstSi/TtErgy2vrfsRV8UKi4u/4aSwPjFakuRg4OCQETic4LiV2MnECmmMSFe+vZuhi5OIQE
	ljJKvNnzhB0iYSIx4+QOZojEdEaJ85NPsIAkeAUEJX5MvscCMohZQF7iyKVskDCzgLrEpHmL
	oOpfM0qcmDeXEaJeS2LB5Q9gNouAqsTlAzPBbDYBHYnt344zgdiiAmESh9rmgdkiAukSt57+
	ZwQZxCywkVHi75v5TCDLhAXyJB4tKYVYsIhZ4syE92wgDZwC2hI7T95iBUlICJxil3j8ZQY7
	xDYBiW+TD7FAvCwrsekAM8RnkhIHV9xgmcAoNgvJP7MQ/pmF5J8FjMyrGEVTC5ILipPSiwz1
	ihNzi0vz0vWS83M3MQLj7PS/Z707GG8fsD7EKMDBqMTDG3BeOESINbGsuDL3EKMp0BETmaVE
	k/OB0ZxXEm9obGZkYWpiamxkbmmmJM6rKPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj
	46ya7e+nMtuzJN9mTeXzsjxXHr7z0/rKuAmC8aW+Uktrbe0MHU8oHJhmvPHhgbL0z6ofQqqZ
	/La3+Zqvz9fnOSn+c+mRigOh82b8st13wOt4dFrd211O2nkP2Lr278n9+V8zLdLqyZ0mLnMu
	+eLwSdelV6zhXeuieEnprqSN8Q3jivWa59iVWIozEg21mIuKEwFyjUNargIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQV2RTLEQg2NPrC0mXN7OaDG7fxqz
	xeVdc9gsjvzvZ7T4cP8is8XxteEObB53ru1h8zi2TcLjxquFTB59W1YxenzeJBfAGtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMaOt/x1bwQeFirvrr7E0MF6R6mLk5JAQ
	MJGYcXIHM4QtJnHh3nq2LkYuDiGB6YwS5yefYAFJ8AoISvyYfA/I5uBgFpCXOHIpGyTMLKAu
	MWneImaI+teMEifmzWWEqNeSWHD5A5jNIqAqcfnATDCbTUBHYvu340wgtqhAmMShtnlgtohA
	usStp/8ZQQYxC2xklPj7Zj4TyDJhgTyJR0tKIRYsYpY4M+E9G0gDp4C2xM6Tt1gnMArMQnLf
	LIT7ZiG5bwEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Dh+JrWDcWWDxSFGAQ5GJR7e
	FReFQ4RYE8uKK3MPMUpwMCuJ8Aa6i4UI8aYkVlalFuXHF5XmpBYfYjQF+m4is5Rocj4wxeSV
	xBsam5gZWRqZG1oYGZsrifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamB0XND+8I/6sUDNd3N7
	Pfwy1ly5/2HV4QWtnF/dv5U9fMjsLLBL+JnQpfPdqXMS96XIvt215JNR/frbG0r/6LtOCrr4
	j1Xt4/IeQysJV/9tzT77fi28Np+prMPZjG2D/305/3e3/xiXpbyTfCkTPn0qi87h3BWuxuf/
	Ljix/+7fDbkKdz9enfnhpRJLcUaioRZzUXEiAOHgyHn5AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 11:31 PM, Grégory Soutadé wrote:
> Replace ext_csd "enhanced_area_en" attribute by
>  "partition_setting_completed". It was used whether or
>  not enhanced user area is defined and without checks of
>  EXT_CSD_PARTITION_SETTING_COMPLETED bit.
> 
> Signed-off-by: Grégory Soutadé <gsoutade@neotion.com>
> ---
>  drivers/mmc/core/mmc.c   |   14 +++++++++-----
>  include/linux/mmc/card.h |    2 +-
>  include/linux/mmc/mmc.h  |    2 ++
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 77b4cf3..d8d3aef 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -314,7 +314,6 @@ static void mmc_manage_enhanced_area(struct mmc_card *card, u8 *ext_csd)
>  		hc_wp_grp_sz =
>  			ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
> 
> -		card->ext_csd.enhanced_area_en = 1;
>  		/*
>  		 * calculate the enhanced data area offset, in bytes
>  		 */
> @@ -355,13 +354,11 @@ static void mmc_manage_gp_partitions(struct mmc_card *card, u8 *ext_csd)
>  	 */
>  	if (ext_csd[EXT_CSD_PARTITION_SUPPORT] &
>  	    EXT_CSD_PART_SUPPORT_PART_EN) {
> -		if (card->ext_csd.enhanced_area_en != 1) {
> +		if (card->ext_csd.partition_setting_completed) {
>  			hc_erase_grp_sz =
>  				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
>  			hc_wp_grp_sz =
>  				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
> -
> -			card->ext_csd.enhanced_area_en = 1;
>  		}
> 
>  		for (idx = 0; idx < MMC_NUM_GP_PARTITION; idx++) {
> @@ -488,6 +485,13 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
>  		ext_csd[EXT_CSD_TRIM_MULT];
>  	card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
>  	if (card->ext_csd.rev >= 4) {
> +		if (ext_csd[EXT_CSD_PARTITION_SETTING_COMPLETED] &
> +		    EXT_CSD_PART_SETTING_COMPLETED) {
> +			card->ext_csd.partition_setting_completed = 1;
> +		} else {
> +			card->ext_csd.partition_setting_completed = 0;
> +		}

I remembered that Ulf mentioned these brackets can be removed.

Best Regards,
Jaehoon Chung
> +
>  		mmc_manage_enhanced_area(card, ext_csd);
> 
>  		mmc_manage_gp_partitions(card, ext_csd);
> @@ -1324,7 +1328,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>  	 * If enhanced_area_en is TRUE, host needs to enable ERASE_GRP_DEF
>  	 * bit.  This bit will be lost every time after a reset or power off.
>  	 */
> -	if (card->ext_csd.enhanced_area_en ||
> +	if (card->ext_csd.partition_setting_completed ||
>  	    (card->ext_csd.rev >= 3 && (host->caps2 & MMC_CAP2_HC_ERASE_SZ))) {
>  		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>  				 EXT_CSD_ERASE_GROUP_DEF, 1,
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index d424b9d..38175be 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -74,7 +74,7 @@ struct mmc_ext_csd {
>  	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
>  	unsigned int		sec_erase_mult;	/* Secure erase multiplier */
>  	unsigned int		trim_timeout;		/* In milliseconds */
> -	bool			enhanced_area_en;	/* enable bit */
> +	bool			partition_setting_completed;	/* enable bit */
>  	unsigned long long	enhanced_area_offset;	/* Units: Byte */
>  	unsigned int		enhanced_area_size;	/* Units: KB */
>  	unsigned int		cache_size;		/* Units: KB */
> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
> index 64ec963..78753bc 100644
> --- a/include/linux/mmc/mmc.h
> +++ b/include/linux/mmc/mmc.h
> @@ -281,6 +281,7 @@ struct _mmc_csd {
>  #define EXT_CSD_EXP_EVENTS_CTRL		56	/* R/W, 2 bytes */
>  #define EXT_CSD_DATA_SECTOR_SIZE	61	/* R */
>  #define EXT_CSD_GP_SIZE_MULT		143	/* R/W */
> +#define EXT_CSD_PARTITION_SETTING_COMPLETED 155	/* R/W */
>  #define EXT_CSD_PARTITION_ATTRIBUTE	156	/* R/W */
>  #define EXT_CSD_PARTITION_SUPPORT	160	/* RO */
>  #define EXT_CSD_HPI_MGMT		161	/* R/W */
> @@ -349,6 +350,7 @@ struct _mmc_csd {
>  #define EXT_CSD_PART_CONFIG_ACC_RPMB	(0x3)
>  #define EXT_CSD_PART_CONFIG_ACC_GP0	(0x4)
> 
> +#define EXT_CSD_PART_SETTING_COMPLETED	(0x1)
>  #define EXT_CSD_PART_SUPPORT_PART_EN	(0x1)
> 
>  #define EXT_CSD_CMD_SET_NORMAL		(1<<0)
> 

