Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaI2Qm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:42:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:59018 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752310AbaI2Qm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:42:58 -0400
Date: Mon, 29 Sep 2014 12:42:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with
 seq_puts()
Message-ID: <20140929124246.3e39dac8@gandalf.local.home>
In-Reply-To: <1412008235.4302.31.camel@joe-AO725>
References: <20140926143721.52206f95@gandalf.local.home>
	<20140929144121.GA30562@pathway.suse.cz>
	<20140929154711.GF7996@ZenIV.linux.org.uk>
	<1412006881.4302.29.camel@joe-AO725>
	<20140929121534.34c3ebd9@gandalf.local.home>
	<1412008235.4302.31.camel@joe-AO725>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 09:30:35 -0700
Joe Perches <joe@perches.com> wrote:


> > Since you like posting links:
> > 
> > https://lkml.org/lkml/2013/12/11/76
> > 
> > If you want to resurrect your patches, go ahead. I'll pull them into my
> > list. Probably should rename seq_overflow() to seq_is_full(), which
> > makes it sound less of an error.
> > 
> > And as Al noted, only fix what's there (just the places that check the
> > return values). Don't add anything else.
> 
> I did that too
> 
> https://lkml.org/lkml/2013/12/11/713
> 
> Then I gave up.

Although I like seq_is_full() over seq_is_buf_full(), I'll take either.
If Al would ack those patches I'd be happy to take them in.

-- Steve
