Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3GQWb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:31:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab3GQWbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:31:25 -0400
Date: Wed, 17 Jul 2013 15:31:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v3.11-rc1 PATCH 0/5] printk: Initial restructuring
Message-Id: <20130717153124.29de2c562b3f4bdb3d1f464b@linux-foundation.org>
In-Reply-To: <1374026199.1949.62.camel@joe-AO722>
References: <cover.1373922863.git.joe@perches.com>
	<CA+55aFwJh5yFeOmPrR=3VqY1StmqTn0sRzwtkCA5N8b=-==otQ@mail.gmail.com>
	<1374026199.1949.62.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 18:56:39 -0700 Joe Perches <joe@perches.com> wrote:

> On Tue, 2013-07-16 at 18:48 -0700, Linus Torvalds wrote:
> > On Mon, Jul 15, 2013 at 2:51 PM, Joe Perches <joe@perches.com> wrote:
> > >
> > > If this is acceptable, I'll post 5 or so patches at a time
> > > after/if each block of patches is applied.
> > 
> > I didn't see anything objectionable, but I'm assuming this comes in
> > through Andrew?
> 
> I'd rather you take it directly now.
> 
> > And hopefully gets comments from others too..
> 
> There were a few 9 months ago.
> 
> Mostly it was a timing issue as to who
> takes it and when.

Well it also broke the build a bit, iirc.

I grabbed them and will give them a run in -next for a week or so.  If
that's OK then I'll try to offload everything onto Linus rather than
having to spend two months battling with linux-next monkeyscratchings.

