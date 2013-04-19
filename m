Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030735Ab3DSPVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:21:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49237 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030512Ab3DSPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:21:21 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX189NP4Oqzje1FN9dDEQop4q
Date: Fri, 19 Apr 2013 08:21:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: b-cousson@ti.com, nm@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        paul@pwsan.com, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ARM: dts: omap4-panda: Add USB Host support
Message-ID: <20130419152117.GE10155@atomide.com>
References: <1366015721-25608-1-git-send-email-rogerq@ti.com>
 <20130418200935.GD10155@atomide.com>
 <5170FDD9.904@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5170FDD9.904@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130419 01:23]:
> On 04/18/2013 11:09 PM, Tony Lindgren wrote:
> 
> > the naming should be mode0name.modename to be consistent. Here's
> > what I dumped out, please check and replace spaces with tabs:
> > 
> >                         0x82 0x10c      /* usbb1_ulpitll_clk.usbb1_ulpiphy_clk gpio84 INPUT_PULLDOWN | MODE4 */
> >                         0x84 0x4        /* usbb1_ulpitll_stp.usbb1_ulpiphy_stp gpio85 OUTPUT | MODE4 */
> >                         0x86 0x104      /* usbb1_ulpitll_dir.usbb1_ulpiphy_dir gpio86 INPUT | MODE4 */
> >                         0x88 0x104      /* usbb1_ulpitll_nxt.usbb1_ulpiphy_nxt gpio87 INPUT | MODE4 */
> >                         0x8a 0x104      /* usbb1_ulpitll_dat0.usbb1_ulpiphy_dat0 gpio88 INPUT | MODE4 */
> >                         0x8c 0x104      /* usbb1_ulpitll_dat1.usbb1_ulpiphy_dat1 gpio89 INPUT | MODE4 */
> >                         0x8e 0x104      /* usbb1_ulpitll_dat2.usbb1_ulpiphy_dat2 gpio90 INPUT | MODE4 */
> >                         0x90 0x104      /* usbb1_ulpitll_dat3.usbb1_ulpiphy_dat3 gpio91 INPUT | MODE4 */
> >                         0x92 0x104      /* usbb1_ulpitll_dat4.usbb1_ulpiphy_dat4 gpio92 INPUT | MODE4 */
> >                         0x94 0x104      /* usbb1_ulpitll_dat5.usbb1_ulpiphy_dat5 gpio93 INPUT | MODE4 */
> >                         0x96 0x104      /* usbb1_ulpitll_dat6.usbb1_ulpiphy_dat6 gpio94 INPUT | MODE4 */
> >                         0x98 0x104      /* usbb1_ulpitll_dat7.usbb1_ulpiphy_dat7 gpio95 INPUT | MODE4 */
> 
> I don't think gpioXX is necessary as we aren't using any of them as GPIOs.

Oops sorry yeah please check as that's something I just dumped
from the system. The gpio numbering is just data for debugging
that you can leave out. Also check please check I dumped the right
pins, I just grepped for usbb1.

Regards,

Tony
