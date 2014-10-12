Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaJLWdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 18:33:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaJLWdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 18:33:01 -0400
Date: Sun, 12 Oct 2014 15:32:38 -0700
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] dell-wmi: Fix access out of memory
Message-ID: <20141012223238.GA28031@vmdeb7>
References: <1411996251-13455-1-git-send-email-pali.rohar@gmail.com>
 <3073358.myrKz9QbdW@vostro.rjw.lan>
 <55C20A75-AB0A-4A4E-9E91-3428B5F868BB@infradead.org>
 <201410121845.07303@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201410121845.07303@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 06:45:06PM +0200, Pali Rohár wrote:
> On Tuesday 30 September 2014 01:16:23 Darren Hart wrote:
> > On September 29, 2014 4:26:03 PM PDT, "Rafael J. Wysocki" 
> <rjw@rjwysocki.net> wrote:
> > >On Monday, September 29, 2014 02:30:29 PM Darren Hart wrote:
> > >> On Mon, Sep 29, 2014 at 03:10:51PM +0200, Pali Rohár wrote:
> > >> > Without this patch driver dell-wmi is trying to access
> > >> > elements of
> > >
> > >dynamically
> > >
> > >> > allocated array without checking array size. This can
> > >> > lead to
> > >
> > >memory corruption
> > >
> > >> > or kernel panic. This patch adds missing checks for array
> > >> > size.
> > >> > 
> > >> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > >> 
> > >> Looks good to me. Rafael, any concerns?
> > >
> > >Not anything obvious.
> > 
> > Queued, thanks.
> > 
> > >> Cc: linux-acpi
> > >
> > >Thanks!
> > >
> 
> Now I see that this patch is in linus tree. Can you sent it to 
> stable trees too?

Hi Pali,

Please see Documentation/stable_kernel_rules.txt for details on how to mark
patches for stable when you submit them. Now that it is in mainline, the process
is a bit more manual, you'll find instructions for how to go about that in the
same document.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
