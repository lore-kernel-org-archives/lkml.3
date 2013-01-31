Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3AaWQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:16:30 -0500
Received: from relais.videotron.ca ([24.201.245.36]:55691 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3AaWQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:16:28 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 31 Jan 2013 17:16:27 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>, hyojun.im@lge.com,
        raphael.andy.lee@gmail.com, linux-kbuild@vger.kernel.org,
        gunho.lee@lge.com, namhyung.kim@lge.com, x86@kernel.org,
        minchan.kim@lge.com, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Ingo Molnar <mingo@redhat.com>, Joe Millenbach <jmillenbach@gmail.com>,
        chan.jeong@lge.com, Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
In-reply-to: <510AE6BF.4080303@zytor.com>
Message-id: <alpine.LFD.2.02.1301311700470.6300@xanadu.home>
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>
 <20130128142510.68092e10.akpm@linux-foundation.org>
 <20130129101549.GP23505@n2100.arm.linux.org.uk> <51089523.3080804@zytor.com>
 <alpine.LFD.2.02.1301301326530.6300@xanadu.home> <510AE6BF.4080303@zytor.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, H. Peter Anvin wrote:

> On 01/30/2013 10:33 AM, Nicolas Pitre wrote:
> >>
> >> The only concern I have with that is if someone paints themselves into a
> >> corner and absolutely wants, say, LZO.
> > 
> > That would be hard to justify given that the kernel provides its own 
> > decompressor code, making the compression format transparent to 
> > bootloaders, etc.  And no one should be poking into the compressed 
> > zImage.
> > 
> 
> Some utterly weird things like the Xen domain builder do that, because
> they have to.  That is why we explicitly document that the payload is
> ELF and how to access it in the bzImage spec.

Are you kidding?

And what format do they expect?

If people are doing weird things with formats we're about to remove then 
it's their fault if they didn't make upstream developers aware of it.  
And if the reason they didn't tell anyone is because it is too nasty for 
public confession then they simply deserve to be broken and come up with 
a more sustainable solution.


Nicolas
