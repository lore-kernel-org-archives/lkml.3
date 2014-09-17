Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbaIQVkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:40:06 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:61073 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255AbaIQVkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:40:03 -0400
Date: Wed, 17 Sep 2014 14:39:58 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Nishanth Menon <nm@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] Documentation: devicetree: mfd: twl4030-power:
 Use the standard 'ti,system-power-controller' to mark power control
Message-ID: <20140917213958.GU30918@lee--X1>
References: <1410957252-764-1-git-send-email-nm@ti.com>
 <1410957252-764-2-git-send-email-nm@ti.com>
 <20140917154400.GE30918@lee--X1>
 <20140917165529.GA24699@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140917165529.GA24699@earth.universe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Sebastian Reichel wrote:

> On Wed, Sep 17, 2014 at 08:44:00AM -0700, Lee Jones wrote:
> > On Wed, 17 Sep 2014, Nishanth Menon wrote:
> > > ti,system-power-controller is more or less the standard way of
> > > indicating that the PMIC is the system wide power controller and hence
> > > may be used to switch off the system. Almost ALL TI PMIC drivers and
> > > many Maxim PMIC drivers follow the same style.
> > > 
> > > So support 'ti,system-power-controller' in addition to the usual
> > > 'ti,use_poweroff' to indicate that the PMIC instance has control for
> > > switching off the system.
> > > 
> > > Signed-off-by: Nishanth Menon <nm@ti.com>
> > > ---
> > > 
> > > V2: picked up documentation suggestion from Sebastien
> > 
> > It would be good to get Sebastian's Ack.
> 
> Acked-By: Sebastian Reichel <sre@kernel.org>
> 
> [...]
> 
> > > +- ti,system-power-controller: This indicates that TWL4030 is the
> > > +  power supply master of the system. With this flag, the chip will
> > > +  initiates an ACTIVE-to-OFF or SLEEP-to-OFF transition when the
> > > +  system poweroffs.
> 
> One minor thing: While the documentation is updated you may want to
> fix the typo "will initiates" to "will initiate" (or just drop the
> "will").

Applied with Sebastian's Ack and I fixed this up too.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
