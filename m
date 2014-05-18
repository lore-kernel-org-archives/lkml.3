Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaERAJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 20:09:47 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:36472 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaERAJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 20:09:45 -0400
Date: Sat, 17 May 2014 21:09:08 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Tony Lindgren <tony@atomide.com>
Cc: George Cherian <george.cherian@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, bcousson@baylibre.com,
        bigeasy@linutronix.de, yegorslists@googlemail.com, balbi@ti.com
Subject: Re: [RFC PATCH] ARM: dts: am33xx: Re-arrange the USB dt to reflect
 the h/w configuration
Message-ID: <20140518000908.GA2092@arch.cereza>
References: <1399617068-19826-1-git-send-email-george.cherian@ti.com>
 <20140514215034.GL27426@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514215034.GL27426@atomide.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tony,

On 14 May 02:50 PM, Tony Lindgren wrote:
> * George Cherian <george.cherian@ti.com> [140508 23:34]:
> > Re arrange the USB dt for AM33xx to take it a bit closer
> > to the hardware configuration.
> > 
[..]
> 
> Is this just a cosmetic change or is this trying to workaround
> some edma related init order issue?
> 

This was an attempt from George to workaround an that happens when
the musb_am335x module is removed. However, we've agreed to prevent
the removal instead. I've just (re)sent a patch for it:

See: [PATCH for v3.15] usb: musb: Fix panic upon musb_am335x module removal

AFAIK, this fixes a serious problem so I've marked it for stable.

For the DMA init order issue, I've done a new patch that forces the
probe order in the driver. I'll post that soon.
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
