Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbaISPMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:12:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:41869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbaISPKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:10:11 -0400
Date: Thu, 18 Sep 2014 19:34:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140918173414.GU2840@worktop.localdomain>
References: <20140916144252.GB32118@x4>
 <20140916111331.14303381@gandalf.local.home>
 <20140916203510.GF1205@quack.suse.cz>
 <20140916170709.73ef2993@gandalf.local.home>
 <20140916212250.GI1205@quack.suse.cz>
 <20140916173328.6306a5c2@gandalf.local.home>
 <20140917141816.GO2840@worktop.localdomain>
 <20140917102255.5cd03071@gandalf.local.home>
 <20140917223633.GE2848@worktop.localdomain>
 <20140917203135.6db2ee5e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917203135.6db2ee5e@gandalf.local.home>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 08:31:35PM -0400, Steven Rostedt wrote:
> I totally didn't get what you wrote.

:-)

> We don't want to know if it got delayed, then the patch to remove that
> print seems correct.

Why would you not want to know that? Also was that the actual argument?
Lemme go check the earlier emails -- I cannot find that argument in the
first few emails.

> But how did it get delayed if we don't know if it got delayed and
> don't want to know?

If you cannot prove something didn't happen it must have happened :-)

> Are my meds still that strong???

Either that or I'm just incoherent, I get that while traveling.
