Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaILX57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:57:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaILX56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:57:58 -0400
Date: Fri, 12 Sep 2014 16:57:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v2 5/6] mm/balloon_compaction: use common page
 ballooning
Message-Id: <20140912165756.b5c7cb78b8280b4347048e02@linux-foundation.org>
In-Reply-To: <20140830164123.29066.26554.stgit@zurg>
References: <20140830163834.29066.98205.stgit@zurg>
	<20140830164123.29066.26554.stgit@zurg>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2014 20:41:23 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:

> This patch replaces checking AS_BALLOON_MAP in page->mapping->flags
> with PageBalloon which is stored directly in the struct page.
> All code of balloon_compaction now under CONFIG_MEMORY_BALLOON.

argh, now the bogus Kconfig/Makefile changes get removed again.
