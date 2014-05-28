Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaE1KKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:10:12 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:15085
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751855AbaE1KKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:10:10 -0400
Message-ID: <5385B69D.50508@freescale.com>
Date: Wed, 28 May 2014 18:12:45 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: <linux-pwm@vger.kernel.org>, <thierry.reding@gmail.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: i.MX: Cleanup indentation for register definitions
References: <1401185980-29536-1-git-send-email-Ying.Liu@freescale.com>
 <20140528115636.4ad791aa@ipc1.ka-ro>
In-Reply-To: <20140528115636.4ad791aa@ipc1.ka-ro>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(377454003)(479174003)(51704005)(24454002)(76482001)(77982001)(33656002)(65816999)(81542001)(23676002)(50986999)(21056001)(19580405001)(19580395003)(83322001)(64126003)(97736001)(81342001)(83506001)(6806004)(68736004)(81156002)(69596002)(87936001)(99396002)(44976005)(50466002)(92566001)(102836001)(36756003)(92726001)(79102001)(84676001)(31966008)(86362001)(76176999)(104016001)(80022001)(575784001)(54356999)(65806001)(65956001)(64706001)(4396001)(26826002)(47776003)(85852003)(74502001)(77096999)(74662001)(46102001)(20776003)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB347;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0225B0D5BC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 05:56 PM, Lothar Waßmann wrote:
> Hi,
> 
> Liu Ying wrote:
>> This patch contains no logic change to cleanup indentation
>> for register definitions only.
>>
>> Cc: Thierry Reding <thierry.reding@gmail.com>
>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>> Cc: Shawn Guo <shawn.guo@freescale.com>
>> Cc: Lothar Waßmann <LW@KARO-electronics.de>
>> Cc: linux-pwm@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>>  drivers/pwm/pwm-imx.c |   26 +++++++++++++-------------
>>  1 file changed, 13 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
>> index cc47733..0784554 100644
>> --- a/drivers/pwm/pwm-imx.c
>> +++ b/drivers/pwm/pwm-imx.c
>> @@ -21,24 +21,24 @@
>>  
>>  /* i.MX1 and i.MX21 share the same PWM function block: */
>>  
>> -#define MX1_PWMC    0x00   /* PWM Control Register */
>> -#define MX1_PWMS    0x04   /* PWM Sample Register */
>> -#define MX1_PWMP    0x08   /* PWM Period Register */
>> +#define MX1_PWMC			0x00   /* PWM Control Register */
>> +#define MX1_PWMS			0x04   /* PWM Sample Register */
>> +#define MX1_PWMP			0x08   /* PWM Period Register */
>>  
>> -#define MX1_PWMC_EN		(1 << 4)
>> +#define MX1_PWMC_EN			(1 << 4)
>>  
>>  /* i.MX27, i.MX31, i.MX35 share the same PWM function block: */
>>  
>> -#define MX3_PWMCR                 0x00    /* PWM Control Register */
>> -#define MX3_PWMSAR                0x0C    /* PWM Sample Register */
>> -#define MX3_PWMPR                 0x10    /* PWM Period Register */
>> -#define MX3_PWMCR_PRESCALER(x)    (((x - 1) & 0xFFF) << 4)
>> -#define MX3_PWMCR_DOZEEN                (1 << 24)
>> -#define MX3_PWMCR_WAITEN                (1 << 23)
>> +#define MX3_PWMCR			0x00    /* PWM Control Register */
>> +#define MX3_PWMSAR			0x0C    /* PWM Sample Register */
>> +#define MX3_PWMPR			0x10    /* PWM Period Register */
>> +#define MX3_PWMCR_PRESCALER(x)		(((x - 1) & 0xFFF) << 4)
>                                                    ^
> You could also add the missing () around the macro argument when you
> are changing this line anyway.
> 

I may generate a separate patch to do that.

Thanks.

> 
> Lothar Waßmann
> 

-- 
Liu Ying
