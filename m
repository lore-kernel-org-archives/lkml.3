Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbaGIQer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:34:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49578 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951AbaGIQep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:34:45 -0400
Date: Wed, 9 Jul 2014 18:34:42 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ARM: at91: remove phy fixup for sama5d3xek
 boards
Message-ID: <20140709183442.14b8aef8@bbrezillon>
In-Reply-To: <1403777615-25685-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1403777615-25685-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bo,

I know you're quite busy, but if you have some time could you test this
series on both CPU Modules (Embest and Ronetix): I only own the Embest
one.

Best Regards,

Boris

On Thu, 26 Jun 2014 12:13:33 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This patch removes a board specific hook for sama5d3xek boards from the
> sama5d3 generic DT board file.
> 
> This hook (which register a phy fixup configuring board specific delays
> in the ksz9021 ethernet phy) is now replaced by the appropriate DT
> properties definitions in the sama5d3xcm.dtsi file.
> 
> Best Regards,
> 
> Boris
> 
> Changes since v1:
>  - fix txc-skew-ps and rxc-skew-ps delays
>  - remove phy address info to handle Ronetix and Embest HW designs
> 
> Boris BREZILLON (2):
>   ARM: at91/dt: describe rgmii ethernet phy connected to sama5d3xek
>     boards
>   ARM: at91: remove phy fixup for sama5d3xek boards
> 
>  arch/arm/boot/dts/sama5d3xcm.dtsi   | 15 +++++++++++++++
>  arch/arm/mach-at91/board-dt-sama5.c | 22 ----------------------
>  2 files changed, 15 insertions(+), 22 deletions(-)
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
