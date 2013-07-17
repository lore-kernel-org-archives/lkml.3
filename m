Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3GQOru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:47:50 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1059 "EHLO
	smtp-out-051.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab3GQOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:47:48 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29589
Message-ID: <51E6AEC2.3050308@metafoo.de>
Date: Wed, 17 Jul 2013 16:48:34 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>, tony@atomide.com,
        benoit.cousson@linaro.org, rnayak@ti.com, peter.ujfalusi@ti.com,
        kishon@ti.com, jic23@cam.ac.uk, grant.likely@linaro.org,
        rob.herring@calxeda.com, sameo@linux.intel.com, ch.naveen@samsung.com,
        poeschel@lemonage.de, milo.kim@ti.com, balajitk@ti.com,
        gg@slimlogic.co.uk, linux-iio@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/2] ARM: dts: twl: Add GPADC data to device tree
References: <1374059564-6872-1-git-send-email-oleksandr.kozaruk@ti.com> <1374059564-6872-2-git-send-email-oleksandr.kozaruk@ti.com> <51E6AB54.103@cogentembedded.com>
In-Reply-To: <51E6AB54.103@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 04:33 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 17-07-2013 15:12, Oleksandr Kozaruk wrote:
> 
>> GPADC is the general purpose ADC present on twl6030.
>> The dt data is interrupt used to trigger end of ADC
>> conversion.
> 
>> Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
>> ---
>>   arch/arm/boot/dts/twl6030.dtsi | 6 ++++++
>>   1 file changed, 6 insertions(+)
> 
>> diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.dtsi
>> index 2e3bd31..322aa8e 100644
>> --- a/arch/arm/boot/dts/twl6030.dtsi
>> +++ b/arch/arm/boot/dts/twl6030.dtsi
>> @@ -103,4 +103,10 @@
>>           compatible = "ti,twl6030-pwmled";
>>           #pwm-cells = <2>;
>>       };
>> +
>> +    adc: twl6030_gpadc {
> 
>    I was talking about the device name, not label. The "twl6030_gpadc" part.

The compatible property should also be: 'twl6030-gpadc' instead of
'twl6030_gpadc' and you need to add documentation for it.

- Lars
