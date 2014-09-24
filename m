Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaIXHSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:18:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47431 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbaIXHSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:18:24 -0400
Message-ID: <54227038.2020805@free-electrons.com>
Date: Wed, 24 Sep 2014 09:18:16 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: linux-sunxi <linux-sunxi@googlegroups.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        yhf@merrii.com, ctl@merrii.com
Subject: Re: [linux-sunxi] Re: [PATCH 3/6] ARM: dts: sunxi: Add Allwinner
 A80 dtsi
References: <1411311493-24344-1-git-send-email-wens@csie.org> <1411311493-24344-4-git-send-email-wens@csie.org> <20140924063738.GQ15315@lukather> <CAGb2v64voZpK_82wtkErRowR0vjEUALNUwvCx_sd8Q5wb4Hq-g@mail.gmail.com>
In-Reply-To: <CAGb2v64voZpK_82wtkErRowR0vjEUALNUwvCx_sd8Q5wb4Hq-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen-Yu,


>>> +
>>> +     memory {
>>> +             reg = <0x20000000 0x40000000>;
>>
>> Usually, what we put there was the maximum amount of RAM that can be
>> handled by the SoC. I think that it can go above 1GB
> 
> With LPAE, it can handle 8GB. But the DT won't take 64bit values.
> I'm not sure how to get it in. I'll look around for examples.

You can have a look on what we did for Armada XP:

arch/arm/boot/dts/armada-370-xp.dtsi
arch/arm/boot/dts/armada-xp.dtsi
arch/arm/boot/dts/armada-xp-gp.dts

I created a skeleton64.dtsi for this case

Gregory


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
