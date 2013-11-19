Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3KSX7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:59:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3KSX7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:59:09 -0500
Date: Tue, 19 Nov 2013 15:59:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Yang Bai <hamo.by@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] scripts: Have make TAGS not include structure members
Message-Id: <20131119155907.11fbdecea0aa40764a3d927a@linux-foundation.org>
In-Reply-To: <CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
References: <20131115093645.6dc03918@gandalf.local.home>
	<CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Nov 2013 10:14:46 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Fri, Nov 15, 2013 at 3:36 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > It is really annoying when I use emacs TAGS to search for something
> > like "dev_name" and have to go through 12 iterations before I find the
> > function "dev_name". I really do not care about structures that include
> > "dev_name" as one of its fields, and I'm sure pretty much all other
> > developers do not care either.
> 
> While I'm also annoyed by this (although with vim/tags), I regularly do search
> for struct members, so losing this ability would hurt, too.

metoo.

> Is there a solution, without throwing out the baby with the bath water?

Remove the tags for those struct members whose name duplicates some
other symbol?
