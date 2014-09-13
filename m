Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaIMAGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 20:06:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaIMAGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 20:06:17 -0400
Date: Fri, 12 Sep 2014 17:06:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v2 6/6] mm/balloon_compaction: general cleanup
Message-Id: <20140912170616.cb4c832a09cc2b221453ad32@linux-foundation.org>
In-Reply-To: <20140912170404.f14663cc823691cab36bf793@linux-foundation.org>
References: <20140830163834.29066.98205.stgit@zurg>
	<20140830164127.29066.99498.stgit@zurg>
	<20140912170404.f14663cc823691cab36bf793@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 17:04:04 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 30 Aug 2014 20:41:27 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> 
> > * move special branch for balloon migraion into migrate_pages
> > * remove special mapping for balloon and its flag AS_BALLOON_MAP
> > * embed struct balloon_dev_info into struct virtio_balloon
> > * cleanup balloon_page_dequeue, kill balloon_page_free
> 
> Not sure what's going on here - your include/linux/balloon_compaction.h
> seems significantly different from mine.

OK, I worked it out.

> I think I'll just drop this patch - it's quite inconvenient to have a
> large "general cleanup" coming after a stack of significant functional
> changes.  It makes review, debug, fix, merge and reversion harder. 
> Let's worry about it later.

But I'm still thinking we should defer this one?
