Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaKJUkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:40:09 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59504 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751460AbaKJUkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:40:06 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19fThO4eg67AJXh0S/W9qrn
Date: Mon, 10 Nov 2014 12:39:23 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Nishanth Menon <nm@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: dra7-evm: Keep all VDD rails always-on
Message-ID: <20141110203922.GX31454@atomide.com>
References: <1413902290-304-1-git-send-email-nm@ti.com>
 <54579476.10702@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54579476.10702@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [141103 06:44]:
> Hi Nishant,
> 
> On 10/21/2014 05:38 PM, Nishanth Menon wrote:
> > DRA7 Data Manual (SPRS857L - August 2014) section 4.1.1 states: "All
> > unused power supply balls must be supplied with the voltages specified
> > in the Section 5.2, Recommended Operating Conditions".
> > 
> > This implies that all unused voltage rails for Vayu can never be
> > switched off even if the hardware blocks inside that voltage domain is
> > unused. Switching off these unused rails may result in stability issues
> > on other domains and increased leakage and power-on-hour impacts.
> > 
> > J6eco-evm dts file already considers this, however j6evm-dts file needs
> > to be fixed to consider this constraint of the SoC.
> > 
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> Acked-by: Roger Quadros <rogerq@ti.com>
> 
> I'm assuming that vddshv8 (MMC1 power group) can be switched off.

Applying into omap-for-v3.19/dt thanks.

Tony
