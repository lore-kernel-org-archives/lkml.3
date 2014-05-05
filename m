Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbaEEQ7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:59:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:22344 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaEEQ7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:59:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,989,1389772800"; 
   d="scan'208";a="506194204"
Subject: Re: [tip:locking/core] rwsem: Add comments to explain the meaning
 of the rwsem's count field
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-tip-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peter@hurleysoftware.com, jason.low2@hp.com, riel@redhat.com,
        alex.shi@linaro.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com,
        davidlohr@hp.com, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20140505163122.GT26782@laptop.programming.kicks-ass.net>
References: <1399060437.2970.146.camel@schen9-DESK>
	 <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
	 <1399305808.2970.186.camel@schen9-DESK>
	 <20140505163122.GT26782@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 May 2014 09:59:11 -0700
Message-ID: <1399309151.2970.193.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 18:31 +0200, Peter Zijlstra wrote:
> On Mon, May 05, 2014 at 09:03:28AM -0700, Tim Chen wrote:
> > On Mon, 2014-05-05 at 01:46 -0700, tip-bot for Tim Chen wrote:
> > > Commit-ID:  3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> > > Gitweb:     http://git.kernel.org/tip/3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> > > Author:     Tim Chen <tim.c.chen@linux.intel.com>
> > > AuthorDate: Fri, 2 May 2014 12:53:57 -0700
> > > Committer:  Ingo Molnar <mingo@kernel.org>
> > > CommitDate: Sun, 4 May 2014 20:34:26 +0200
> > > 
> > 
> > Ingo,
> > 
> > Can you pick up this version of the patch instead.  I've updated the
> > comments to reflect all cases for which the rwsem's count is less than
> > WAITING_BIAS, as Peter has pointed out.
> 
> Wouldn't a state diagram be clearer than this gobs of text?

The state is represented by the count field with an explanation
of what each state actually means.  I started off with a
pretty abbreviated version. But to account for the readers and writers
that are in transient trying to acquire the lock, the comments
get more verbose, unfortunately.

Tim

