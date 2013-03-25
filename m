Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3CYO5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:57:38 -0400
Received: from 3.mo2.mail-out.ovh.net ([46.105.58.226]:60793 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757179Ab3CYO5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:57:37 -0400
Date: Mon, 25 Mar 2013 15:37:22 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 0/4] ARM: at91: little DT fixes
Message-ID: <20130325143722.GD20693@game.jcrosoft.org>
References: <cover.1363960549.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1363960549.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7070369941828512620
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrieejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrieejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:23 Fri 22 Mar     , Nicolas Ferre wrote:
> Hi,
> 
> Here are some little fixes found while adding device tree boards.
> I plan to request a pull on this material early next week.
> 
> 
> Nicolas Ferre (4):
>   ARM: at91/dt: fix macb node declaration
>   ARM: at91/trivial: typos in compatible property
>   ARM: at91/trivial: fix model name for SAM9G15-EK
>   ARM: at91: remove partial parameter in bootargs for at91sam9x5ek.dtsi

on all

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

> 
>  arch/arm/boot/dts/at91sam9g15.dtsi  |  2 +-
>  arch/arm/boot/dts/at91sam9g15ek.dts |  2 +-
>  arch/arm/boot/dts/at91sam9g25.dtsi  |  2 +-
>  arch/arm/boot/dts/at91sam9g25ek.dts |  9 +++++++++
>  arch/arm/boot/dts/at91sam9g35.dtsi  |  2 +-
>  arch/arm/boot/dts/at91sam9g35ek.dts |  9 +++++++++
>  arch/arm/boot/dts/at91sam9x25.dtsi  |  2 +-
>  arch/arm/boot/dts/at91sam9x25ek.dts | 14 ++++++++++++++
>  arch/arm/boot/dts/at91sam9x35.dtsi  |  2 +-
>  arch/arm/boot/dts/at91sam9x35ek.dts |  9 +++++++++
>  arch/arm/boot/dts/at91sam9x5ek.dtsi |  7 +------
>  11 files changed, 48 insertions(+), 12 deletions(-)
> 
> -- 
> 1.8.0
> 
