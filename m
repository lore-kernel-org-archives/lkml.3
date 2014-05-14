Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaENQKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:10:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaENQKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:10:24 -0400
Date: Wed, 14 May 2014 18:10:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc: regression in suspend
In-Reply-To: <20140514155759.GB9723@amd.pavel.ucw.cz>
Message-ID: <alpine.LNX.2.00.1405141809000.16459@pobox.suse.cz>
References: <20140513160926.GA3621@amd.pavel.ucw.cz> <20140513163734.GA4602@amd.pavel.ucw.cz> <20140513214155.GA5087@amd.pavel.ucw.cz> <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz> <20140514155759.GB9723@amd.pavel.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Pavel Machek wrote:

> > So it might in the end of the day the same thing as I have reported in 
> > 
> > 	https://bugs.freedesktop.org/show_bug.cgi?id=76554
> > 
> > which is not 100% reproducible either (although with newer kernels it's 
> > *much* more reproducible for me than with older).
> > 
> > > It worked few times on -rc5, but then I rebooted and problem 
> > > re-appeared.
> > 
> > If you could capture dmesg of the resume where X fails to resume properly 
> > to see whether you have i915 ring initialization errors there as well?
> 
> I did dmesg and I believe I would have noticed "*ERROR*" there.. but
> I'll of course capture the buffer when it happens. 

Thanks.

> Note that X do work somehow after resume (I can't switch virtual
> desktops and dialog is stuck on screen, but it is not complete
> failure). I can do ctrl-alt-f1 and get to useful prompt.

I have similar symptoms. The windows are not redrawing, etc.

-- 
Jiri Kosina
SUSE Labs
