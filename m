Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaJ1QGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:06:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54730 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752376AbaJ1QGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:06:04 -0400
Date: Tue, 28 Oct 2014 12:05:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] docg3: Fix miuse of seq_printf return value
Message-ID: <20141028120552.63c2324c@gandalf.local.home>
In-Reply-To: <1414511877.6643.12.camel@perches.com>
References: <20140929124246.3e39dac8@gandalf.local.home>
	<cover.1412031505.git.joe@perches.com>
	<c1a1138f1b05e87a3fbd8737af2f2c0be6e2724b.1412031505.git.joe@perches.com>
	<20141022082916.GD16128@brian-ubuntu>
	<20141028111301.22481f2a@gandalf.local.home>
	<1414511877.6643.12.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 08:57:57 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2014-10-28 at 11:13 -0400, Steven Rostedt wrote:
> > I'm going to be working on changes to remove the return value of
> > seq_printf() and friends.
> 
> I'm sure you know all of this, but for anyone else:
> 
> This doesn't need to be done in a single pass.

Yeah, I took a look at all the places, and I've decided to take it off
in chunks. I'm starting with the ones you posted, and will try to get
acks for them. And then go after other chunks as I have time.

I would like to get this done before I do my merge of trace_seq and
seq_file, but I'm thinking I may have to do that in parallel.

-- Steve

