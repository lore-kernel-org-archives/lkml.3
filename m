Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaLPSTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:19:21 -0500
Received: from h1943130.stratoserver.net ([81.169.133.216]:50720 "EHLO
	studio-punkt.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaLPSTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:19:19 -0500
Date: Tue, 16 Dec 2014 19:19:13 +0100
From: Evgeni Dobrev <evgeni@studio-punkt.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: dts: kirkwood: enable phy driver for SATA
 controller on 88f6192
Message-ID: <20141216181913.GF20170@anne>
References: <20141215203724.GA22936@anne>
 <20141216170138.14dcabc1@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216170138.14dcabc1@free-electrons.com>
X-PGP-Key: http://evgeni.studio-punkt.com/pub.asc
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Tue, Dec 16, 2014 at 05:01:38PM +0100, Thomas Petazzoni wrote:
> Dear Evgeni Dobrev,
> 
> On Mon, 15 Dec 2014 21:37:24 +0100, Evgeni Dobrev wrote:
> > This patch enables the phy drivers for the SATA controller on Marvell's 88f6192. Without them it is not possible to use SATA drives attached to this processor.
> 
> Commit log text should be wrapped to some reasonable length.
> 

I will fix this.

> 
> >  			interrupts = <21>;
> >  			clocks = <&gate_clk 14>, <&gate_clk 15>;
> >  			clock-names = "0", "1";
> > +                        phys = <&sata_phy0>, <&sata_phy1>;
> > +                        phy-names = "port0", "port1";
> 
> You should use tabs and not spaces for indentation in Device Tree files.

I will resubmit. Thank you for your review.

> 
> Thanks!
> 
> Thomas
> -- 
> Thomas Petazzoni, CTO, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
> --

evgeni
