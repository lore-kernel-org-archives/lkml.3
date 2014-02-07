Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaBGOP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:15:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaBGOP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:15:26 -0500
Date: Fri, 7 Feb 2014 15:15:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: Jani Nikula <jani.nikula@intel.com>, Dave Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm next tree
In-Reply-To: <CAKMK7uGf0=13HpkeZf1WouutkB+kOpyT4NHXaXMVg5j6wEh_pQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1402071514240.24838@pobox.suse.cz>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie> <alpine.LRH.2.00.1401301648050.15677@twin.jikos.cz> <alpine.LNX.2.00.1402071052470.24838@pobox.suse.cz> <87a9e318m6.fsf@intel.com> <alpine.LNX.2.00.1402071437400.24838@pobox.suse.cz>
 <CAKMK7uGf0=13HpkeZf1WouutkB+kOpyT4NHXaXMVg5j6wEh_pQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Daniel Vetter wrote:

> Sorry for missing your report here. Before we disable this again for
> gen4 I want to make sure that it's the same irq misrouting issue which
> was already the cause for the gmbus irq mess. Can you please boot with
> pci=nomsi (so that i915 uses irq16)?
> 
> If that's confirmed then I think we should add the same comment we've
> added in intel_i2c.c to this code so that no one dares to wake this
> dragon again. I'll do that when I commit the fix.

Confirmed, with MSI disabled, i915 is using IRQ 16 and everything is 
working well.

-- 
Jiri Kosina
SUSE Labs
