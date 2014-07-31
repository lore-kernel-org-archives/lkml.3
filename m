Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbaGaJt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:49:56 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:55233 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaGaJty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:49:54 -0400
MIME-Version: 1.0
In-Reply-To: <53DA0BAA.8090000@suse.de>
References: <1406728244-5105-1-git-send-email-afaerber@suse.de>
	<1406728244-5105-5-git-send-email-afaerber@suse.de>
	<53DA0BAA.8090000@suse.de>
Date: Thu, 31 Jul 2014 15:19:53 +0530
Message-ID: <CAEC9eQNuPN+WiKGOtCosCwcR48MNawQL7dU4S8=dbA4eFXB_-w@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ARM: dts: Add exynos5250-spring device tree
From: Ajay kumar <ajaynumb@gmail.com>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ajay Kumar <ajaykumar.rs@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Thu, Jul 31, 2014 at 2:56 PM, Andreas Färber <afaerber@suse.de> wrote:
> Am 30.07.2014 15:50, schrieb Andreas Färber:
>> diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
>> new file mode 100644
>> index 000000000000..bcca892bf2ff
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/exynos5250-spring.dts
> [...]
>> +&pinctrl_0 {
>> +     dp_hpd_gpio: dp-hpd-gpio {
>> +             samsung,pins = "gpc3-0";
>> +             samsung,pin-function = <1>;
>
> Not sure where this 1 came from... Both Ajay and my 3.8 DT have 0.
Right, this should be 0.

>> +             samsung,pin-pud = <3>;
>> +             samsung,pin-drv = <0>;
>> +     };
>
> Seeing that Ajay called this node dp-hdp, it should probably be an override?
dp_hpd should be enough. I will keep the same name for peach boards.
dp_hpd: dp-hpd {
.
.
.
};

Ajay
