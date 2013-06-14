Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab3FNLDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 07:03:03 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54559 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3FNLDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 07:03:01 -0400
Date: Fri, 14 Jun 2013 13:02:59 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: cfa10036: Add USB0 OTG port
Message-ID: <20130614110259.GQ16699@lukather>
References: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
 <1371131025-12200-2-git-send-email-maxime.ripard@free-electrons.com>
 <24013808.T2v7Fa5NMK@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24013808.T2v7Fa5NMK@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Jun 14, 2013 at 12:06:51AM +0200, Arnd Bergmann wrote:
> On Thursday 13 June 2013 15:43:42 Maxime Ripard wrote:
> > +
> > +       ahb@80080000 {
> > +               usb0: usb@80080000 {
> > +                       pinctrl-names = "default";
> > +                       pinctrl-0 = <&usb0_otg_cfa10036>;
> > +                       status = "okay";
> >                 };
> >         };
> > 
> 
> The patches all look good, just one trivial comment about the fragment above:
> 
> There is already a "usb0" label in the imx28.dtsi file for the same
> node. When you refer to the node from a board.dts file, either leave
> out the redundant label, or use it to simplify the statements above
> to the brief version:
> 
> 	&usb0 {
> 		pinctrl-names = "default";
> 		pinctrl-0 = <&usb0_otg_cfa10036>;
> 		status = "okay";
> 	};
> 

Good to know, thanks!

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
