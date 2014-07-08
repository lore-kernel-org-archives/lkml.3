Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaGHLcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:32:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37154 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753413AbaGHLcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:32:01 -0400
Date: Tue, 8 Jul 2014 13:31:57 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: =?utf-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCHv2 17/32] ARM: at91/dt: ge863-pro3: define crystals
 frequencies
Message-ID: <20140708113157.GK3113@piout.net>
References: <1404764629-29136-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1404764629-29136-18-git-send-email-alexandre.belloni@free-electrons.com>
 <53BB8B91.8020501@aksignal.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53BB8B91.8020501@aksignal.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 at 08:11:29 +0200, Jiří Prchal wrote :
> Hi,
> the slow crystal is not on the module "ge863-pro3", but it's usually
> on application board. So I think this clock should be in board dts.
> 

Right, I'll move the 32kHz crystal to the board dts.

> Dne 7.7.2014 22:23, Alexandre Belloni napsal(a):
> >Define Telit GE863-PRO3, AK signal CDU and Telit EVK-PRO3 main and slow
> >crystals frequencies.
> >
> >Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> >Cc: Fabio Porcedda <fabio.porcedda@gmail.com>
> >Cc: Jiri Prchal <jiri.prchal@aksignal.cz>
> >---
> >  arch/arm/boot/dts/ge863-pro3.dtsi | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> >diff --git a/arch/arm/boot/dts/ge863-pro3.dtsi b/arch/arm/boot/dts/ge863-pro3.dtsi
> >index 230099bb31c8..a32fdbefbbd9 100644
> >--- a/arch/arm/boot/dts/ge863-pro3.dtsi
> >+++ b/arch/arm/boot/dts/ge863-pro3.dtsi
> >@@ -19,6 +19,14 @@
> >  			compatible = "atmel,osc", "fixed-clock";
> >  			clock-frequency = <6000000>;
> >  		};
> >+
> >+		slow_xtal {
> >+			clock-frequency = <32768>;
> >+		};
> >+
> >+		main_xtal {
> >+			clock-frequency = <6000000>;
> >+		};
> >  	};
> >
> >  	ahb {
> >

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
