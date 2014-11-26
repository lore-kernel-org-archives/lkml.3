Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaKZJBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:01:42 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:51308 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaKZJBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:01:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lyra Zhang <zhang.lyra@gmail.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, grant.likely@linaro.org,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        Will Deacon <will.deacon@arm.com>, gnomes@lxorguk.ukuu.org.uk,
        corbet@lwn.net, jason@lakedaemon.net, Mark Brown <broonie@kernel.org>,
        heiko@sntech.de, shawn.guo@freescale.com, florian.vaussard@epfl.ch,
        andrew@lunn.ch, hytszk@gmail.com, Orson Zhai <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        lanqing.liu@spreadtrum.com,
        Wei Qiao =?utf-8?B?KOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3 4/5] arm64: Add support for Spreadtrum's Sharkl64 Platform in Kconfig and defconfig
Date: Wed, 26 Nov 2014 10:00:31 +0100
Message-ID: <5825969.ZSdbLFRUel@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAfSe-uoXOJ8=agCFuBnXhj7nBBTskQ=8_jMtv_SAjor2gfO2w@mail.gmail.com>
References: <1416917818-10506-5-git-send-email-chunyan.zhang@spreadtrum.com> <3490516.nCDXzA8J8x@wuerfel> <CAAfSe-uoXOJ8=agCFuBnXhj7nBBTskQ=8_jMtv_SAjor2gfO2w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:q7I0AMDVoYUheF5PGSVthz8h1HdQ/zUkkmmDZultLcC
 sbCjfuNKYHmX/7wdS4FwOi/HxE3HUV8yDElJiEegH7D5x/n1nB
 r97K3j8LuKJD78m0muxLRhRji+bJZojGdt4XwBWaZdjfTdtK7i
 uU7frGmqN8aeDgGWYPi3/3annzuHsA4PJP7099QF6ABBCcv4BK
 PEDl6JfszB9Q32JOyt1jKxZvb+wiJrHEYPMB2V03JtyRG9pEs6
 9hEA6krHtSuylDDu/7zVvnVOxs9bkH7WvESVpNHivs4WrL1sae
 ExADhTIRv4B+O01Wpj7JqEUBdnb/WklCqLlQR5CPSr8f/yaFro
 L2rlJLoEzSresVK6V/7w=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2014 10:32:35 Lyra Zhang wrote:
> 
> For now, we have only one platform(Sharkl64) based on ARM64 been submitted,
> but we're intending to add support for more our platforms based on ARM64 or
> ARM32 in the future. There are many common devices on these platforms, such
> as serial. Our idea would be that if we had a 'menuconfig ARCH_SPRD' in the
> Kconfig, these common devices only need to depend on ARCH_SPRD in the
> respective Kconfig, otherwise they may depend on a few Kconfig symbols for
> every platforms which include these common devices.
> 
> So, do you think whether we should define a menuconfig(ARCH_SPRD) in the
> Kconfig for this case ?

It sounds like your other platforms are all related, so one ARCH_SPRD
should be enough. If someone wants to build a  kernel that is only
going to run on a particular machine, they can just turn off all the
other drivers they don't want.

	Arnd
