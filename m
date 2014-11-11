Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaKKIoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:44:34 -0500
Received: from mail-bn1bn0100.outbound.protection.outlook.com ([157.56.110.100]:61376
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751707AbaKKIob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:44:31 -0500
X-AuditID: ac1c210f-f79a76d000007ee0-d8-5461cc6c18e8
From: Avi Shchislowski <Avi.Shchislowski@sandisk.com>
To: Jaehoon Chung <jh80.chung@samsung.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>
CC: "'Chris Ball'" <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Alex Lemberg <Alex.Lemberg@sandisk.com>,
        "gwendal@google.com" <gwendal@google.com>,
        open list <linux-kernel@vger.kernel.org>, CPGS <cpgs@samsung.com>
Subject: RE: [PATCH 1/3] mmc: Support FFU for eMMC v5.0
Thread-Topic: [PATCH 1/3] mmc: Support FFU for eMMC v5.0
Thread-Index: AQHP/QnAbgQuSdsdnUWkkiHhln2R85xbRW2A///XmyA=
Date: Tue, 11 Nov 2014 08:44:27 +0000
Message-ID: <FDD07FEB422EF948A392FDC201AEEAE64F6B6E48@SACMBXIP02.sdcorp.global.sandisk.com>
References: <n@samsung.com>
 <1415639632-878-1-git-send-email-avi.shchislowski@sandisk.com>
 <54617D8F.8060506@samsung.com>
In-Reply-To: <54617D8F.8060506@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.181.8.64]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRobxn27OmcQQg5cr2S0mXN7OaPHykKbF
	3Z0TGC1u/Gpjtbi8aw6bxZH//YwWx9eGO7B7LNhU6nHn2h42jxuvFjJ59G1ZxejxeZNcAGsU
	l01Kak5mWWqRvl0CV8b95a9YC/7LVcxf+Ji5gfGFRBcjJ4eEgInEnfeXmCBsMYkL99azdTFy
	cQgJHGeUeNL2ihXCOccosXPtanaQKjYBU4l135+AdYgIxEus/bUCrINZ4CejRPPu+cwgCWEB
	c4nPy6azQRRZSLxcfp4VwraSeHqpgQXEZhFQlXixeCVYPa9AtMS7DyfAhgoJ1EocaeoEq+EU
	0Jb49n4zWJwR6Lzvp9aA2cwC4hK3nsyHOltAYsme88wQtqjEy8f/gHZxANnyEtdP20GU60gs
	2P2JDcLWlli28DXUWkGJkzOfsExgFJuFZOosJC2zkLTMQtKygJFlFaNYcWJycW56aoGhkV5x
	Yl5KZnG2XnJ+7iZGcCwq8u9g3DbF/BCjAAejEg/vBZ/EECHWxLLiytxDjBIczEoivPUJQCHe
	lMTKqtSi/Pii0pzU4kOM0hwsSuK8q9xmBQsJpCeWpGanphakFsFkmTg4pRoY1RgWJrnqt696
	8m7luTs/mXhP+6j//7f20swpzNHvzxuYqu3f4Mj98ltO7xUr/W+v5kn+uvNtb2V4je6DQy46
	dfIWqqohNdwzLjppVwquTJg3u1B24d3b35Zc8Y4L2pm4jYVV6Rej92232oVhCvU79bb2Cp8R
	2uy859ujA4/U7p4XF/tSVbv4qRJLcUaioRZzUXEiAOZYgRLBAgAA
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:74.221.232.164;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(199003)(13464003)(189002)(479174003)(377454003)(51704005)(21056001)(46102003)(95666004)(81156004)(47776003)(106466001)(64706001)(106116001)(20776003)(50466002)(55846006)(33656002)(107046002)(99396003)(120916001)(4396001)(77096003)(62966003)(46406003)(77156002)(31966008)(16796002)(97736003)(97756001)(86362001)(92726001)(92566001)(2656002)(87936001)(84676001)(2501002)(19580405001)(68736004)(54356999)(69596002)(23726002)(19580395003)(44976005)(76176999)(50986999)(7099021);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB113;H:sacsmgep12.sandisk.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB113;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB113;
X-Forefront-PRVS: 0392679D18
Authentication-Results: spf=pass (sender IP is 74.221.232.164)
 smtp.mailfrom=Avi.Shchislowski@sandisk.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB113;
X-OriginatorOrg: sandisk.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi 
I used the "git send-email..."

Thanks


>-----Original Message-----
>From: Jaehoon Chung [mailto:jh80.chung@samsung.com]
>Sent: Tuesday, November 11, 2014 5:08 AM
>To: Avi Shchislowski; ulf.hansson@linaro.org
>Cc: 'Chris Ball'; linux-mmc@vger.kernel.org; Alex Lemberg;
>gwendal@google.com; open list; CPGS
>Subject: Re: [PATCH 1/3] mmc: Support FFU for eMMC v5.0
>
>Hi,
>
>how did you make the patch?
>This patch didn't apply at Ulf's repository.
>
>
>On 11/11/2014 02:13 AM, Avi Shchislowski wrote:
>>
>> Add eMMC5.0 ffu ext_csd fields
>>
>> Signed-off-by: Avi Shchislowski <avi.shchislowski@sandisk.com>
>> Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>
>>
>>
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c index
>> 1eda8dd..3b86ed3 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -603,6 +603,15 @@ static int mmc_read_ext_csd(struct mmc_card
>*card, u8 *ext_csd)
>>  		card->ext_csd.data_sector_size = 512;
>>  	}
>>
>> +	/* eMMC v5 or later */
>> +	if (card->ext_csd.rev >= 7) {
>> +		card->ext_csd.ffu_capable =
>> +			((ext_csd[EXT_CSD_SUPPORTED_MODE] & 0x1) ==
>0x1) &&
>> +			((ext_csd[EXT_CSD_FW_CONFIG] & 0x1) == 0x0);
>
>if (ext_csd[EXT_CSD_SUPPORTED_MODE] & 0x1)
>&&  !(ext_csd[EXT_CSD_FW_CONFIG] & 0x1))
>		card->ext_csd.ffu_capable = true;
>
>> +		card->ext_csd.ffu_mode_op =
>ext_csd[EXT_CSD_FFU_FEATURES];
>> +	} else {
>> +		card->ext_csd.ffu_capable = false;
>
>Can be set to false by default before checking whether card is eMMC v5.0 or
>not.
>
>card->ext_csd.ffu_capable = false;
>
>if (card->ext_csd.rev >= 7) {
>	...
>}
>
>Best Regards,
>Jaehoon Chung
>
>> +	}
>>  out:
>>  	return err;
>>  }
>> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h index
>> d424b9d..dd01efe 100644
>> --- a/include/linux/mmc/card.h
>> +++ b/include/linux/mmc/card.h
>> @@ -81,6 +81,8 @@ struct mmc_ext_csd {
>>  	bool			hpi_en;			/* HPI
>enablebit */
>>  	bool			hpi;			/* HPI support bit */
>>  	unsigned int		hpi_cmd;		/* cmd used as HPI */
>> +	bool			ffu_capable;		/* FFU support */
>> +	bool			ffu_mode_op;		/* FFU mode
>operation */
>>  	bool			bkops;		/* background support bit */
>>  	bool			bkops_en;	/* background enable bit */
>>  	unsigned int            data_sector_size;       /* 512 bytes or 4KB */
>> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h index
>> 64ec963..787787b 100644
>> --- a/include/linux/mmc/mmc.h
>> +++ b/include/linux/mmc/mmc.h
>> @@ -272,6 +272,9 @@ struct _mmc_csd {
>>   * EXT_CSD fields
>>   */
>>
>> +#define EXT_CSD_FFU_STATUS		26	/* R */
>> +#define EXT_CSD_MODE_OPERATION_CODES	29	/* W */
>> +#define EXT_CSD_MODE_CONFIG		30	/* R/W */
>>  #define EXT_CSD_FLUSH_CACHE		32      /* W */
>>  #define EXT_CSD_CACHE_CTRL		33      /* R/W */
>>  #define EXT_CSD_POWER_OFF_NOTIFICATION	34	/* R/W */
>> @@ -290,6 +293,7 @@ struct _mmc_csd {
>>  #define EXT_CSD_SANITIZE_START		165     /* W */
>>  #define EXT_CSD_WR_REL_PARAM		166	/* RO */
>>  #define EXT_CSD_RPMB_MULT		168	/* RO */
>> +#define EXT_CSD_FW_CONFIG		169	/* R/W */
>>  #define EXT_CSD_BOOT_WP			173	/* R/W */
>>  #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
>>  #define EXT_CSD_PART_CONFIG		179	/* R/W */
>> @@ -326,6 +330,11 @@ struct _mmc_csd {
>>  #define EXT_CSD_GENERIC_CMD6_TIME	248	/* RO */
>>  #define EXT_CSD_CACHE_SIZE		249	/* RO, 4 bytes */
>>  #define EXT_CSD_PWR_CL_DDR_200_360	253	/* RO */
>> +#define EXT_CSD_NUM_OF_FW_SEC_PROG	302	/* RO, 4 bytes
>*/
>> +#define EXT_CSD_FFU_ARG			487	/* RO, 4 bytes
>*/
>> +#define EXT_CSD_OPERATION_CODE_TIMEOUT	491	/* RO */
>> +#define EXT_CSD_FFU_FEATURES		492	/* RO */
>> +#define EXT_CSD_SUPPORTED_MODE		493	/* RO */
>>  #define EXT_CSD_TAG_UNIT_SIZE		498	/* RO */
>>  #define EXT_CSD_DATA_TAG_SUPPORT	499	/* RO */
>>  #define EXT_CSD_MAX_PACKED_WRITES	500	/* RO */
>>

