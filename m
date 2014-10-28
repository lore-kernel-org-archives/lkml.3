Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaJ1PNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:13:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:51831 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751030AbaJ1PNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:13:06 -0400
Date: Tue, 28 Oct 2014 11:13:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Joe Perches <joe@perches.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] docg3: Fix miuse of seq_printf return value
Message-ID: <20141028111301.22481f2a@gandalf.local.home>
In-Reply-To: <20141022082916.GD16128@brian-ubuntu>
References: <20140929124246.3e39dac8@gandalf.local.home>
	<cover.1412031505.git.joe@perches.com>
	<c1a1138f1b05e87a3fbd8737af2f2c0be6e2724b.1412031505.git.joe@perches.com>
	<20141022082916.GD16128@brian-ubuntu>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 01:29:16 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> On Mon, Sep 29, 2014 at 04:08:27PM -0700, Joe Perches wrote:
> > seq_printf doesn't return a useful value, so remove
> > these misuses.
> 
> Good catch. So it looks like this driver always had some form of
> wrongness (returning a character count) in its debugfs callbacks, but
> nobody noticed.
> 
> Applied to l2-mtd.git. Thanks!
> 

Note, I'm going to be working on changes to remove the return value of
seq_printf() and friends. I need this change as well. If you
already applied it to your git tree, if you can still rebase, can you
make a separate branch off of Linus's tree that I can pull to do work
on?

Or I can take this patch as well, with your Acked-by.

Thanks!

-- Steve
