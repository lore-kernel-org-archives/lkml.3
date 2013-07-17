Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab3GQB4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 21:56:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40873 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179Ab3GQB4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 21:56:41 -0400
Message-ID: <1374026199.1949.62.camel@joe-AO722>
Subject: Re: [v3.11-rc1 PATCH 0/5] printk: Initial restructuring
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 16 Jul 2013 18:56:39 -0700
In-Reply-To: <CA+55aFwJh5yFeOmPrR=3VqY1StmqTn0sRzwtkCA5N8b=-==otQ@mail.gmail.com>
References: <cover.1373922863.git.joe@perches.com>
	 <CA+55aFwJh5yFeOmPrR=3VqY1StmqTn0sRzwtkCA5N8b=-==otQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 18:48 -0700, Linus Torvalds wrote:
> On Mon, Jul 15, 2013 at 2:51 PM, Joe Perches <joe@perches.com> wrote:
> >
> > If this is acceptable, I'll post 5 or so patches at a time
> > after/if each block of patches is applied.
> 
> I didn't see anything objectionable, but I'm assuming this comes in
> through Andrew?

I'd rather you take it directly now.

> And hopefully gets comments from others too..

There were a few 9 months ago.

Mostly it was a timing issue as to who
takes it and when.

printk still moves around quite a bit
and Andrew suggested shortly after
an -rc1 was likely the best timing.

http://lkml.indiana.edu/hypermail/linux/kernel/1212.0/02931.html

As far as I'm concerned, the biggest
deal is starting this refactoring.

It doesn't have to be an big blast
like what was submitted last year,
but it should be started sooner
rather never.


