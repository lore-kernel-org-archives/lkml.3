Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaIXMgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:36:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49938 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751543AbaIXMgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:36:20 -0400
Message-ID: <5422BABC.7020906@free-electrons.com>
Date: Wed, 24 Sep 2014 14:36:12 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        yhf <yhf@merrii.com>, ctl <ctl@merrii.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [linux-sunxi] Re: [PATCH 3/6] ARM: dts: sunxi: Add Allwinner
 A80 dtsi
References: <1411311493-24344-1-git-send-email-wens@csie.org> <1411311493-24344-4-git-send-email-wens@csie.org> <20140924063738.GQ15315@lukather> <CAGb2v64voZpK_82wtkErRowR0vjEUALNUwvCx_sd8Q5wb4Hq-g@mail.gmail.com> <54227038.2020805@free-electrons.com> <CAGb2v64yGmdLeWmA=+nxD85DbQf_xxUNx3n3oedFZi51uc50+w@mail.gmail.com>
In-Reply-To: <CAGb2v64yGmdLeWmA=+nxD85DbQf_xxUNx3n3oedFZi51uc50+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen-Yu,


> 
> Thanks for the tip. Before I send v2, I do have a question. I'm using
> 
>     ranges = <0 0 0 0x20000000>;
> 
> in the clocks and soc node to avoid having to use 64bit values for all
> addresses and sizes. Would this be undesirable, even bad practice maybe?

We did something like that for all the internal registers too as they are all
under 4GB. In our case the use of a range really makes sens because the hardware
addresses were configurable. You don't have such requirement so I can't say if
it is a bad practice. From my point of view it seems sensible but I am not an
DT expert.


Grégory


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
