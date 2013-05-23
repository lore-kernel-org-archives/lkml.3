Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab3EWP14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:27:56 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:45591 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759850Ab3EWP1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:27:47 -0400
Date: Thu, 23 May 2013 17:27:32 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@ardb.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Oliver Schinagl <oliver@schinagl.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130523152732.GL8595@lukather>
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
 <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl>
 <CACRpkdaWADjy1YZXTcRaXU+ZsS6_pG0hojQdnz=qeTgyVY7_Ww@mail.gmail.com>
 <519DCEE9.6070208@schinagl.nl>
 <20130523145835.GI8595@lukather>
 <519E3031.8080604@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519E3031.8080604@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 05:05:21PM +0200, Oliver Schinagl wrote:
> On 05/23/13 16:58, Maxime Ripard wrote:
> >On Thu, May 23, 2013 at 10:10:17AM +0200, Oliver Schinagl wrote:
> >>Then, i'm not sure if the driver is the best for this to be loaded?
> >>Maxime, what do you think? Personally I would feel more in having
> >>this in the mach-sunxi/core.c bit, but then again, this is currently
> >>a module and wouldn't be useful to have there. Maxime is far more
> >>knowledgeable to answer that.
> >
> >Hmmm, I don't understand what you mean here. Could you explain what you
> >have in mind?
> I've thought about it a little, and don't think core.c is a good
> spot, since the module will have to be loaded, or available there.
> And that's really early.
> 
> So I guess, during probe, controlled by a parameter perhaps, load
> all 16 bytes into the random pool as Linus suggested?

Yeah, though I don't really know what the parameter would be useful for,
but yes, do it in the driver's probe.

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
