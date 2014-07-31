Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaGaJyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:54:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaGaJx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:53:59 -0400
Message-ID: <53DA1231.70309@suse.de>
Date: Thu, 31 Jul 2014 11:53:53 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ajay kumar <ajaynumb@gmail.com>
CC: "linux-samsung-soc@vger.kernel.org" 
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
Subject: Re: [PATCH v3 4/4] ARM: dts: Add exynos5250-spring device tree
References: <1406728244-5105-1-git-send-email-afaerber@suse.de>	<1406728244-5105-5-git-send-email-afaerber@suse.de>	<53DA0BAA.8090000@suse.de> <CAEC9eQNuPN+WiKGOtCosCwcR48MNawQL7dU4S8=dbA4eFXB_-w@mail.gmail.com>
In-Reply-To: <CAEC9eQNuPN+WiKGOtCosCwcR48MNawQL7dU4S8=dbA4eFXB_-w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 31.07.2014 11:49, schrieb Ajay kumar:
> On Thu, Jul 31, 2014 at 2:56 PM, Andreas Färber <afaerber@suse.de> wrote:
>> Am 30.07.2014 15:50, schrieb Andreas Färber:
>>> diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
>>> new file mode 100644
>>> index 000000000000..bcca892bf2ff
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/exynos5250-spring.dts
>> [...]
>>> +&pinctrl_0 {
>>> +     dp_hpd_gpio: dp-hpd-gpio {
>>> +             samsung,pins = "gpc3-0";
>>> +             samsung,pin-function = <1>;
>>
>> Not sure where this 1 came from... Both Ajay and my 3.8 DT have 0.
> Right, this should be 0.
> 
>>> +             samsung,pin-pud = <3>;
>>> +             samsung,pin-drv = <0>;
>>> +     };
>>
>> Seeing that Ajay called this node dp-hdp, it should probably be an override?
> dp_hpd should be enough. I will keep the same name for peach boards.
> dp_hpd: dp-hpd {
> .
> .
> .
> };

Apart from my own set of typos, I see that you proposed dp-hpd whereas
-pinctrl.dtsi has dp_hpd (dash vs. underscore). My question is, can we
override the pinctrl one instead of adding a new one, or do they need to
coexist?

Thanks,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
