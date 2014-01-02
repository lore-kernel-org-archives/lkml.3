Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaABRLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:11:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20364 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752410AbaABRLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:11:07 -0500
Date: Thu, 2 Jan 2014 12:11:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] tracing: Fixes to event_triggers patches found by
 Fengguang's test bot
Message-ID: <20140102121100.5f09ffb9@gandalf.local.home>
In-Reply-To: <1387768382.14728.9.camel@empanada>
References: <20131222030759.339128630@goodmis.org>
	<1387768382.14728.9.camel@empanada>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Dec 2013 21:13:02 -0600
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

> Hi Steve,
> 
> On Sat, 2013-12-21 at 22:07 -0500, Steven Rostedt wrote:
> > Tom,
> > 
> > This is the changes I made to fix the reports that Fengguang's kbuild test bot
> > found. I folded in your change that fixes the bug with -ENODEV used in kernel.h.
> > 
> 
> These look fine to me, and I didn't see any problems after running
> through my normal event trigger testing with them applied.
> 
> So you can add my Acked-by and/or Tested-by..
> 
> Thanks for writing these improved versions!

Bah, I forgot to add these to the change logs before pushing to my
for-next branch. I hate to rebase, but I also would like these tags
too. 

Hmm, I may just rebase anyway. We still have a couple of weeks before
the merge window opens.

-- Steve
