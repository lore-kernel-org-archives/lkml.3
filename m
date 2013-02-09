Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682Ab3BIOPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:15:51 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50837 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3BIOPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:15:49 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] gpio: twl4030: Cache the direction and output states in private data
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Michael Trimarchi <michael@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
In-Reply-To: <50EEBD8F.6040101@ti.com>
References: <1355996651-17805-1-git-send-email-peter.ujfalusi@ti.com> <CACRpkdZK8AA-osijVpbp7U-Wv0XUAVxDPQ3zxfCqWYb6WKjmwQ@mail.gmail.com> <50EEBD8F.6040101@ti.com>
Date: Sat, 09 Feb 2013 14:15:44 +0000
Message-Id: <20130209141544.119593E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013 14:09:35 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Hi Linus,
> 
> On 01/10/2013 11:41 AM, Linus Walleij wrote:
> > On Thu, Dec 20, 2012 at 10:44 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> > 
> >> Use more coherent locking in the driver. Use bitfield to store the GPIO
> >> direction and if the pin is configured as output store the status also in a
> >> bitfiled.
> >> In this way we can just look at these bitfields when we need information
> >> about the pin status and only reach out to the chip when it is needed.
> >>
> >> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >> ---
> >> Hi Grant,
> >>
> >> Changes sicne v2:
> >> - Fixed the mutex_unlock found by Michael.
> >> - Removed the debug prints addedd by v2 patch (remains from debugging)
> >> - Removed one blank line between includes and the first comment section.
> > 
> > Sorry Peter this must have been missed somehow.
> > 
> > This does not apply to the current v3.8-rc3, could you respin
> > this on top of Torvalds' tree?
> 
> Grant applied the patch which this one depends on:
> [1] https://patchwork.kernel.org/patch/1844511/

I had applied it, never pushed the tree out because I wasn't able to
test my kernel tree for a couple of weeks due to travel. I saw the patch
in Linus' tree and pulled it out of mine before I pushed it out.

g.

