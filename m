Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaAOR4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:56:37 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50285 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaAORz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:55:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140115171155.GK25824@e106331-lin.cambridge.arm.com>
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com>
 <1389743333-16741-6-git-send-email-marc.ceeeee@gmail.com> <20140115171155.GK25824@e106331-lin.cambridge.arm.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 15 Jan 2014 09:55:18 -0800
Message-ID: <CAGVrzcapAVg7rb+vGGz_yB6fE8v=CEY-z-LFX=R0iMtrqYA3WQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] ARM: brcmstb: add misc. DT bindings for brcm,brcmstb-*
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Carino <marc.ceeeee@gmail.com>, Christian Daudt <bcm@fixthebug.org>,
        Arnd Bergmann <arnd@arndb.de>, Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/15 Mark Rutland <mark.rutland@arm.com>:
> On Tue, Jan 14, 2014 at 11:48:51PM +0000, Marc Carino wrote:
>> Document the bindings that the Broadcom STB platform needs
>> for proper bootup.
>>
>> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
>> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  .../devicetree/bindings/arm/brcm-brcmstb.txt       |   43 ++++++++++++++++++++
>>  1 files changed, 43 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt b/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
>> new file mode 100644
>> index 0000000..5f1aba7
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
>> @@ -0,0 +1,43 @@
>> +Broadcom STB platforms Device Tree Bindings
>> +-------------------------------------------
>> +Boards with Broadcom Brahma15 ARM-based BCM7xxx SoC shall have the following
>> +properties.
>> +
>> +Required root node properties:
>> +
>> +    - compatible = "brcm,brcmstb-<chip_id>";
>
> I'd prefer it if variants were listed explicitly (as it makes it far
> easier to grep for). Something like:
>
> - compatible: should contain one of:
>   * "brcm,brcmsrb-7445"
>   * "brcm,brcmsrb-7446"

For consistency with other Broadcom SoCs in mainline, as well as
making it easier to grep for products, I would be inclined to use:

compatible = "brcm,bcm7445", with the fallback compatible string "brcm,brcmstb".
-- 
Florian
