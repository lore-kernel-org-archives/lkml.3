Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaHVXDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:03:00 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32709 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaHVXC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:02:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+X1rFJtVA86tLlIOyKz4W5
Date: Fri, 22 Aug 2014 16:02:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, inux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: DRA7: fix interrupt-cells for GPIO
Message-ID: <20140822230253.GJ10066@atomide.com>
References: <1406748032-19417-1-git-send-email-nm@ti.com>
 <53F249F3.9070402@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F249F3.9070402@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140818 11:49]:
> On 07/30/2014 02:20 PM, Nishanth Menon wrote:
> > GPIO modules are also interrupt sources. However, they require both the
> > GPIO number and IRQ type to function properly.
> > 
> > By declaring that GPIO uses interrupt-cells=<1>, we essentially do not
> > allow users of the nodes to use the interrupt property appropritely.
> > 
> > With this change, the following now works:
> > 
> > interrupt-parent = <&gpio6>;
> > interrupts = <5 IRQ_TYPE_LEVEL_LOW>;
> > 
> > Fixes: 6e58b8f1daaf ('ARM: dts: DRA7: Add the dts files for dra7 SoC and dra7-evm board')
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > ---
> > Based on v3.16-rc7
> > 
> >  arch/arm/boot/dts/dra7.dtsi |   16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> Tony,
> Gentle ping. we still have this issue on 3.17-rc1. any suggestions on
> if we can pick this up during RC?

Yes thanks applying into omap-for-v3.17/fixes.

Tony
