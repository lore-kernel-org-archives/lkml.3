Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134Ab3JPVSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 17:18:25 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1899 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab3JPVSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 17:18:22 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <525F028E.6020006@broadcom.com>
Date: Wed, 16 Oct 2013 14:18:06 -0700
From: "Wendy Ng" <wendy.ng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101
 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Eduardo Valentin" <eduardo.valentin@ti.com>
cc: "Rob Herring" <rob.herring@calxeda.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>
Subject: Re: [PATCH v2 2/3] ARM: bcm281xx: Turn on Thermal and HWMON
 drivers.
References: <1380321454-16216-1-git-send-email-wendy.ng@broadcom.com>
 <1380321454-16216-3-git-send-email-wendy.ng@broadcom.com>
 <525B1BC5.20800@ti.com>
In-Reply-To: <525B1BC5.20800@ti.com>
X-WSS-ID: 7E41DD022E42303345-02-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2013 3:16 PM, Eduardo Valentin wrote:
> Wendy,
>
> On 27-09-2013 18:37, Wendy Ng wrote:
>> This enables the thermal and HWMON drivers for Broadcom bcm281xx SoCs.
>>
>> Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
>> Reviewed-by: Markus Mayer <mmayer@broadcom.com>
>> Reviewed-by: Christian Daudt <csd@broadcom.com>
>> ---
>>   arch/arm/configs/bcm_defconfig |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
>> index 6e49310..1474661 100644
>> --- a/arch/arm/configs/bcm_defconfig
>> +++ b/arch/arm/configs/bcm_defconfig
>> @@ -83,7 +83,8 @@ CONFIG_SERIAL_8250_DW=y
>>   CONFIG_HW_RANDOM=y
>>   CONFIG_I2C=y
>>   CONFIG_I2C_CHARDEV=y
>> -# CONFIG_HWMON is not set
>> +CONFIG_THERMAL=y
>
> Maybe you also wanted to
> CONFIG_BCM_THERMAL=y
> ?
>
This is not required as I have default BCM_THERMAL to 'y' in Kconfig file.

>> +CONFIG_HWMON=y
>>   CONFIG_VIDEO_OUTPUT_CONTROL=y
>>   CONFIG_FB=y
>>   CONFIG_BACKLIGHT_LCD_SUPPORT=y
>>
>
>


-- 
Best regards,
-Wendy

