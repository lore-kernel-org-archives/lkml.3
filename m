Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3LBJHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:07:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:46474 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab3LBJH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:07:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,809,1378882800"; 
   d="scan'208";a="417818833"
Message-ID: <1385975219.1871.38.camel@smile>
Subject: Re: [PATCH] lib/vsprintf.c: add %paD format specifier for
 dma_addr_t types
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dmaengine@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Date: Mon, 02 Dec 2013 11:06:59 +0200
In-Reply-To: <1385763040.12210.34.camel@joe-AO722>
References: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1385663555.12210.19.camel@joe-AO722> <1385729760.1871.23.camel@smile>
	 <1385763040.12210.34.camel@joe-AO722>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-29 at 14:10 -0800, Joe Perches wrote:
> On Fri, 2013-11-29 at 14:56 +0200, Andy Shevchenko wrote:
> > On Thu, 2013-11-28 at 10:32 -0800, Joe Perches wrote:

[]

> > > https://lkml.org/lkml/2013/9/12/483
> > 
> > Hmm... Still not in kernel. Do you know reason why it so?
> 
> It was just for discussion and I didn't sign or push it
> to anyone else.
> 
> What's slightly funny is how far back dma_addr_t printk
> discussions go.
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0202.1/1221.html

Wow, 2002!
Let's cross over a finish line in 2013.


> Anyway, if you think you're going to do a lot of
> transforms of printk("%x", dma_addr_t) with or without
> (unsigned long long) or (u64) casts, I'll submit a signed
> patch to Andrew.

I think it worse to submit even if we have no more such casting in the
future (which is the case I don't believe in).


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

