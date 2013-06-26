Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab3FZJYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:24:02 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:50301 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3FZJX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:23:59 -0400
Date: Wed, 26 Jun 2013 11:23:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Nathan Zimmer <nzimmer@sgi.com>,
        Robin Holt <holt@sgi.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
Message-ID: <20130626092355.GC27025@gmail.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
 <20130621165142.GA32125@kroah.com>
 <51C48745.9030304@zytor.com>
 <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com>
 <20130621185056.GA23473@kroah.com>
 <51C4C5F3.3050800@sgi.com>
 <CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com>
 <51C9D4ED.5070805@sgi.com>
 <51C9DEC1.6030602@zytor.com>
 <CAE9FiQV5z+3AXy5c=aaU3vq1V3fibJ6PhhA4VW5H8BWVzhxXPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQV5z+3AXy5c=aaU3vq1V3fibJ6PhhA4VW5H8BWVzhxXPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Tue, Jun 25, 2013 at 11:17 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 06/25/2013 10:35 AM, Mike Travis wrote:
> 
> > However, please consider Ingo's counterproposal of doing this via the
> > buddy allocator, i.e. hugepages being broken on demand.  That is a
> > *very* powerful model, although would require more infrastructure.
> 
> Can you or Ingo elaborate more about the buddy allocator proposal?

Ok, I just wrote a fuller proposal, with cons and pros listed as well.

I think it's a winner but hey.

Thanks,

	Ingo
