Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3F0Pf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:35:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55822 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796Ab3F0Pf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:35:28 -0400
X-Sasl-enc: Fs3OTrDTYvb/axI9JaONm4XjgqC5hyg+Prh/KZeeQgkB 1372347327
Date: Thu, 27 Jun 2013 08:36:12 -0700
From: Greg KH <greg@kroah.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] delayed kobject release: help find buggy code
Message-ID: <20130627153612.GA25244@kroah.com>
References: <20130627140613.GB12530@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627140613.GB12530@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 03:06:14PM +0100, Russell King wrote:
> Greg,
> 
> This is an updated copy of my delayed kobject release debugging patch
> from 2011, which I notice hasn't hit mainline.  Please consider merging
> this so that driver authors and subsystem maintainers have a way to test
> code for kobject refcounting errors.
> 
> Moreover, please also consider whether to make the debug option default
> to 'y' when CONFIG_DEBUG_KERNEL is enabled.

Nice, I had forgotten about this code.  Have you run it in a while to
see if things still work well?

I'll queue this up for 3.12, my 3.11 trees are now closed.

thanks,

greg k-h
