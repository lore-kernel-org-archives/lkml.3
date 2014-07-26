Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbaGZUNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:13:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33071 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756976AbaGZUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:13:44 -0400
Date: Sat, 26 Jul 2014 22:13:39 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: at91/dt: sam9x5: fix ADC compatible string
Message-ID: <20140726201338.GO9532@piout.net>
References: <1406038067-14697-1-git-send-email-alexandre.belloni@free-electrons.com>
 <53D40A60.2060100@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D40A60.2060100@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/07/2014 at 00:06:56 +0400, Sergei Shtylyov wrote :
> >diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> >index 2c0d6ea3ab41..5d7cf394f537 100644
> >--- a/arch/arm/boot/dts/at91sam9x5.dtsi
> >+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> >@@ -964,7 +964,7 @@
> >  			adc0: adc@f804c000 {
> >  				#address-cells = <1>;
> >  				#size-cells = <0>;
> >-				compatible = "atmel,at91sam9260-adc";
> >+				compatible = "atmel,at91sam9x5-adc";
> 
>    Actually, wildcards are not allowed in the "compatible" prop.
> 

This is not really a wildcard, the sam9x5 family of SoC is supported
through only one dtsi, at91sam9x5.dtsi and this name is used for all the
compatible strings of the IPs that appeared with that family.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
