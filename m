Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbaGPMOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:14:32 -0400
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:39897 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758816AbaGPMO2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:14:28 -0400
Date: Wed, 16 Jul 2014 17:44:27 +0530 (IST)
Subject: =?utf-8?Q?Re=3A_=5BPATCH=5D_regmap=3A_Kconfig=3A_Select_SPMI_when_REGMAP?=
 =?utf-8?Q?=5FSPMI_is_selected?=
From: "Pramod Gurav" <pramod.gurav@smartplayin.com>
To: "Stanimir Varbanov" <svarbanov@mm-sol.com>
Cc: pramod.gurav.etc@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "Josh Cartwright" <joshc@codeaurora.org>,
        "Mark Brown" <broonie@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <53C66AEB.7030906@mm-sol.com>
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com> 
 <53C66AEB.7030906@mm-sol.com>
Message-ID: <1405512867.75389776@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, 16 July, 2014 5:37pm, "Stanimir Varbanov" <svarbanov@mm-sol.com> said:

> Hi,
> 
> <snip>
>>
>> Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>
>> CC: Josh Cartwright <joshc@codeaurora.org>
>> CC: Mark Brown <broonie@linaro.org>
>> ---
>> This was found when I enabled support for Qualcomm QPNP PMICs and was
>> compiling it. It selects REGMAP_SPMI and hence the crash.
>>
>>  drivers/base/regmap/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
>> index 4251570..1aa9d71 100644
>> --- a/drivers/base/regmap/Kconfig
>> +++ b/drivers/base/regmap/Kconfig
>> @@ -16,6 +16,7 @@ config REGMAP_SPI
>>  	tristate
>>
>>  config REGMAP_SPMI
>> +	select SPMI
> 
> NO, IMO the CONFIG_SPMI should be enabled by qcom_defconfig and
> multi_v7_defconfig. See CONFIG_I2C and REGMAP_I2C for example.
> 

I am using multi_v7_defconfig but its not enabling it. I ran qcom_defconfig which does.
 
> --
> regards,
> Stan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


