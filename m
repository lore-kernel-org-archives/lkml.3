Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab3DXIfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:35:18 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49135 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088Ab3DXIfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:35:15 -0400
Date: Wed, 24 Apr 2013 09:35:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com>, Rabin Vincent <rabin@rab.in>,
        linus.walleij@stericsson.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, Per Forlin <per.forlin@stericsson.com>,
        Dan Williams <djbw@fb.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 21/32] dmaengine: ste_dma40: Also report the number of
 logical channels
Message-ID: <20130424083509.GF17416@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-22-git-send-email-lee.jones@linaro.org>
 <20130422093631.GE24632@intel.com>
 <20130422101455.GH3432@gmail.com>
 <20130422094842.GL24632@intel.com>
 <20130422103715.GK3432@gmail.com>
 <20130422105245.GG14496@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130422105245.GG14496@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Russell King - ARM Linux wrote:

> On Mon, Apr 22, 2013 at 11:37:15AM +0100, Lee Jones wrote:
> > On Mon, 22 Apr 2013, Vinod Koul wrote:
> > 
> > > On Mon, Apr 22, 2013 at 11:14:55AM +0100, Lee Jones wrote:
> > > > On Mon, 22 Apr 2013, Vinod Koul wrote:
> > > > 
> > > > > On Thu, Apr 18, 2013 at 11:12:03AM +0100, Lee Jones wrote:
> > > > > > +	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with "
> > > > > > +		"%d physical channels and %d logical channels\n",
> > > > > > +		rev, res->start, num_phy_chans, num_log_chans);
> > > > > Splitting log messages across lines is bad idea and sacrifces readablity... also
> > > > > wasnt splitting logging to multiple lines emit checkpatch warn
> 
> Yes, but for a different reason...
> 
> > > > You also get a check-patch error if your lines are over 80 chars.
> > > No, you get a warn
> > 
> > You only get a warning for this too:
> > 
> >  WARNING: quoted string split across lines
> > #33: FILE: drivers/dma/ste_dma40.c:3204:
> > +	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with "
> > +		"%d physical channels and %d logical channels\n",
> 
> From coding style: "However, never break user-visible strings such as
> printk messages, because that breaks the ability to grep for them."
> 
> You can argue that you wouldn't grep for the above string - but consider
> if you grepped for "hardware revision.*channels" to try and find the
> above message, which would be a reasonable thing to try if you got lots
> of hits on just "hardware revision".

Okay, this I understand. I'll fixup.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
