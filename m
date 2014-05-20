Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaETFue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:50:34 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51134 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaETFud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:50:33 -0400
Date: Mon, 19 May 2014 22:50:41 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: DT for 3.16 #2
Message-ID: <20140520055041.GO18956@quad.lixom.net>
References: <1400059162-630-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400059162-630-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:19:22AM +0200, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> More DT material for AT91. Some fixes that apply on what was merged for 3.15
> but that are not very critical.
> The other patches are feature additions to old or very recent product/board:
> at91sam9261 or sama5d3 Xplained.
> 
> Thanks, best regards,
> 
> The following changes since commit 27a96a0364787d2b41d2a72d08143d95263e1b07:
> 
>   ARM: at91: sama5d3: clock for ssc from rk pin (2014-04-18 22:43:44 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-dt2
> 
> for you to fetch changes up to a93f9c88b7701d1c4c3b22d39d64a408f000a6ef:
> 
>   ARM: at91/dt: at91-sama5d3_xplained: add the regulator device node (2014-05-12 16:48:54 +0200)

Merged, but:

>  arch/arm/boot/dts/at91-sama5d3_xplained.dts |  62 +++++++++++++++
>  arch/arm/boot/dts/at91sam9261.dtsi          | 114 ++++++++++++++++++++++++++--
>  arch/arm/boot/dts/at91sam9rl.dtsi           |   7 +-
>  arch/arm/boot/dts/sama5d3.dtsi              |  78 +++++++++++++++++++

Grmbl. I remember being somewhat annoyed that you didn't use at91 prefix
when you introduced the sama5d3 dtsi files, but please don't start using
it on a random board like this, especially when other boards just use
the sama5d3_<board>.dts format.

Care to fix this up in time for 3.16 merge window?


Thanks,

-Olof
