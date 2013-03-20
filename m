Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab3CTQNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:13:30 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27807 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090Ab3CTQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:13:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Bg5RhHTw+9tdakQB/UuC2
Date: Wed, 20 Mar 2013 09:13:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/21] usb: phy: nop: Add some parameters to
 platform data
Message-ID: <20130320161324.GL16413@atomide.com>
References: <1363794300-31526-1-git-send-email-rogerq@ti.com>
 <1363794300-31526-2-git-send-email-rogerq@ti.com>
 <20130320155555.GG1567@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130320155555.GG1567@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [130320 09:00]:
> On Wed, Mar 20, 2013 at 05:44:40PM +0200, Roger Quadros wrote:
> > Add clk_rate parameter to platform data. If supplied, the
> > NOP phy driver will program the clock to that rate during probe.
> > 
> > Also add 2 flags, needs_vcc and needs_reset.
> > If the flag is set and the regulator couldn't be found
> > then the driver will bail out with -EPROBE_DEFER.
> > 
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> > Acked-by: Felipe Balbi <balbi@ti.com>
> 
> Hi Tony,
> 
> maybe you might prefer to merge commit 1f0972f from my next branch which
> is exactly this patch. Basically, if you:
> 
> $ git fetch git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git next
> $ git merge 1f0972f
> 
> you get $SUBJECT and can apply the others without fear of conflicts
> later.

OK thanks will use commit 1f0972f, so let's consider that commit immutable.

Regards,

Tony
