Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3KTAEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:04:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:61862 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751561Ab3KTAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:04:28 -0500
Date: Tue, 19 Nov 2013 19:04:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Yang Bai <hamo.by@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] scripts: Have make TAGS not include structure members
Message-ID: <20131119190426.27b010e4@gandalf.local.home>
In-Reply-To: <20131119155907.11fbdecea0aa40764a3d927a@linux-foundation.org>
References: <20131115093645.6dc03918@gandalf.local.home>
	<CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
	<20131119155907.11fbdecea0aa40764a3d927a@linux-foundation.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013 15:59:07 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 17 Nov 2013 10:14:46 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > On Fri, Nov 15, 2013 at 3:36 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > It is really annoying when I use emacs TAGS to search for something
> > > like "dev_name" and have to go through 12 iterations before I find the
> > > function "dev_name". I really do not care about structures that include
> > > "dev_name" as one of its fields, and I'm sure pretty much all other
> > > developers do not care either.
> > 
> > While I'm also annoyed by this (although with vim/tags), I regularly do search
> > for struct members, so losing this ability would hurt, too.
> 
> metoo.

You're a vim user too. Do I hear any complaints about removing it just
for emacs users?

> 
> > Is there a solution, without throwing out the baby with the bath water?
> 
> Remove the tags for those struct members whose name duplicates some
> other symbol?

For vim, I could write a perl script that could do that.

-- Steve

