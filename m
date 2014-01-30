Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaA3QlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:41:25 -0500
Received: from smtprelay0197.hostedemail.com ([216.40.44.197]:33315 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751057AbaA3QlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:41:23 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:
X-HE-Tag: alarm22_b660f72bc322
X-Filterd-Recvd-Size: 2454
Message-ID: <1391100076.2422.56.camel@joe-AO722>
Subject: Re: [PATCH v2 6/6] cpu/idle.c: move to sched/idle.c
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Date: Thu, 30 Jan 2014 08:41:16 -0800
In-Reply-To: <20140130162753.GF5002@laptop.programming.kicks-ass.net>
References: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org>
	 <1391017513-12995-7-git-send-email-nicolas.pitre@linaro.org>
	 <20140130152500.GB5002@laptop.programming.kicks-ass.net>
	 <alpine.LFD.2.11.1401301102210.1652@knanqh.ubzr>
	 <20140130162753.GF5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-30 at 17:27 +0100, Peter Zijlstra wrote:
> On Thu, Jan 30, 2014 at 11:03:31AM -0500, Nicolas Pitre wrote:
> > > This is not a valid patch for PATCH(1). Please try again.
> > 
> > Don't you use git?  ;-)
> 
> Nah, git and me don't get along well.

Perhaps you could use a newer version of patch

http://savannah.gnu.org/forum/forum.php?forum_id=7361

GNU patch version 2.7 released

Item posted by Andreas Gruenbacher <agruen> on Wed 12 Sep 2012 02:18:14
PM UTC.

I am pleased to announce that version 2.7 of GNU patch has been
released. The following significant changes have happened since the last
stable release in December 2009: 

      * Support for most features of the "diff --git" format, including
        renames and copies, permission changes, and symlink diffs.
        Binary diffs are not supported yet; patch will complain and skip
        them.


