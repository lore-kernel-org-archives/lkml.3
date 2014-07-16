Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959AbaGPM4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:56:18 -0400
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:43296 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933679AbaGPM4Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:56:16 -0400
Date: Wed, 16 Jul 2014 18:26:15 +0530 (IST)
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
In-Reply-To: <53C66F3B.9020507@mm-sol.com>
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>  
 <53C66AEB.7030906@mm-sol.com> <1405512867.75389776@apps.rackspace.com> 
 <53C66F3B.9020507@mm-sol.com>
Message-ID: <1405515375.452411340@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, 16 July, 2014 5:55pm, "Stanimir Varbanov" <svarbanov@mm-sol.com> said:

> <snip>
> 
>>>>
>>>>  config REGMAP_SPMI
>>>> +	select SPMI
>>>
>>> NO, IMO the CONFIG_SPMI should be enabled by qcom_defconfig and
>>> multi_v7_defconfig. See CONFIG_I2C and REGMAP_I2C for example.
>>>
>>
>> I am using multi_v7_defconfig but its not enabling it. I ran qcom_defconfig which
>> does.
> 
> yes, it seems reasonable to add it in multi_v7_defconfig also.
> 

Thanks.
I misunderstood the Kconfig documentation which says, "Reverse dependencies can only be used with boolean or tristate symbols". In the note following this statement doc says, "In general use select only for non-visible symbols".

The CONFIG_SPMI option is visible in menuconfig hence either it should be set by default in multi_v7_defconfig(like in qcom_defconfig) or driver owner should mention a 'depneds on CONFIG_SPMI' as suggested by Lars-Peter Clausen. 
I prefer the former (defconfig).

Shall I send a new patch adding it in multi_v7_defconfig?

> 
> --
> regards,
> Stan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


