Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaJIXSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 19:18:15 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:48911 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaJIXSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 19:18:12 -0400
X-IronPort-AV: E=Sophos;i="5.04,688,1406617200"; 
   d="scan'208";a="47862234"
Message-ID: <543717AF.6090500@broadcom.com>
Date: Thu, 9 Oct 2014 16:18:07 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH V4 6/7] MAINTAINERS: Entry for Cygnus/iproc arm architecture
 and clock drivers
References: <Scott Branden <sbranden@broadcom.com>	 <1412894671-5921-1-git-send-email-sbranden@broadcom.com>	 <1412894671-5921-7-git-send-email-sbranden@broadcom.com> <1412895651.8770.7.camel@joe-AO725>
In-Reply-To: <1412895651.8770.7.camel@joe-AO725>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-09 04:00 PM, Joe Perches wrote:
> On Thu, 2014-10-09 at 15:44 -0700, Scott Branden wrote:
>> Acked-by: Jonathan Richardson <jonathar@broadcom.com>
>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   MAINTAINERS |   17 ++++++++++++++++-
>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index a12edf2..0900082 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -2071,9 +2071,24 @@ L:	linux-scsi@vger.kernel.org
>>   S:	Supported
>>   F:	drivers/scsi/bnx2i/
>>
>> -BROADCOM KONA GPIO DRIVER
>> +BROADCOM CYGNUS/IPROC ARM ARCHITECTURE
>>   M:	Ray Jui <rjui@broadcom.com>
>> +M:	Scott Branden <sbranden@broadcom.com>
>> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>   L:	bcm-kernel-feedback-list@broadcom.com
>> +S:	Maintained
>> +F:	Documentation/devicetree/bindings/arm/bcm/cygnus.txt
>> +F:	arch/arm/boot/dts/bcm-cygnus.dtsi
>> +F:	arch/arm/boot/dts/bcm911360_entphn.dts
>> +F:	arch/arm/configs/bcm_cygnus_defconfig
>> +F:	arch/arm/mach-bcm/bcm_cygnus.c
>> +F:	Documentation/devicetree/bindings/clock/clk-cygnus.txt
>> +F:	Documentation/devicetree/bindings/clock/clk-iproc.txt
>> +F:	drivers/clk/bcm/clk-cygnus.c
>> +F:	drivers/clk/bcm/clk-iproc.c
>> +
>> +BROADCOM KONA GPIO DRIVER
>> +M:	Ray Jui <rjui@broadcom.com>
>>   S:	Supported
>>   F:	drivers/gpio/gpio-bcm-kona.c
>>   F:	Documentation/devicetree/bindings/gpio/gpio-bcm-kona.txt
>
> This drops this L line from BROADCOM KONA GPIO DRIVER
> L:	bcm-kernel-feedback-list@broadcom.com
>
> Is that what you want?
Wow, sorry.  I'll correct after further comments.
>

