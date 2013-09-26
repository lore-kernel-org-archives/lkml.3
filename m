Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3IZWuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:50:23 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:50621 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3IZWuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:50:21 -0400
Date: Thu, 26 Sep 2013 17:50:19 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: new binutils needed for arm in 3.12-rc1
To: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Andrew Morton <akpm@osdl.org>,
        Trivial patch monkey <trivial@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <yw1x38oswrss.fsf@unicorn.mansr.com> (from mans@mansr.com on
	Wed Sep 25 15:49:07 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1380235819.1974.94@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 03:49:07 PM, Måns Rullgård wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> 
> > On Wed, Sep 25, 2013 at 10:23:06AM -0500, Rob Landley wrote:
> >> On 09/24/2013 09:07:57 PM, Nicolas Pitre wrote:
> >>> It could be as simple as making gas accept an extra argument for
> >>> instructions like dsb and just ignoring it.
> >>
> >> So you prefer I come up with the reversion patches locally and  
> _not_
> >> send them upstream?
> >
> > This is a silly attitude.  What you're effectively saying is that we
> > are never allowed to use any future ARM instructions in any Linux
> > kernel because that might break your precious assembler.
> >
> > I've got news for you.  We're *not* going to listen to that  
> argument.
> >
> > END OF DISCUSSION (everything else is just a waste of time.)

Who am I to argue with capital letters?

> I fully agree.

Actually, I thought this was an armv5l regression. (My objection was to  
requiring a newer toolchain for architectures that built fine under the  
old one. My attention was attracted by the proposed patch to  
Documentation/changes with a global updated for required binutils  
version.)

I've since had a chance to confirm the armv5 build break I saw was just  
normal mid-rc1 noise (since fixed) and this set of patches just applies  
to armv7, which already required a newer binutils, so objection  
withdrawn.

Rob