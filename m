Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab3KIDH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 22:07:29 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:37304 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362Ab3KIDH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 22:07:26 -0500
Date: Fri, 8 Nov 2013 19:07:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v5 4/4] qrwlock: Use the mcs_spinlock helper functions
 for MCS queuing
Message-ID: <20131109030718.GN18245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1383585440-4391-1-git-send-email-Waiman.Long@hp.com>
 <1383585440-4391-5-git-send-email-Waiman.Long@hp.com>
 <20131108212107.GI18245@linux.vnet.ibm.com>
 <1383959827.11046.420.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383959827.11046.420.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110903-0928-0000-0000-0000033D540C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 05:17:07PM -0800, Tim Chen wrote:
> On Fri, 2013-11-08 at 13:21 -0800, Paul E. McKenney wrote:
> > On Mon, Nov 04, 2013 at 12:17:20PM -0500, Waiman Long wrote:
> > > There is a pending patch in the rwsem patch series that adds a generic
> > > MCS locking helper functions to do MCS-style locking. This patch
> > > will enable the queue rwlock to use that generic MCS lock/unlock
> > > primitives for internal queuing. This patch should only be merged
> > > after the merging of that generic MCS locking patch.
> > > 
> > > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> > 
> > This one does might address at least some of the earlier memory-barrier
> > issues, at least assuming that the MCS lock is properly memory-barriered.
> 
> Paul, will appreciate if you can take a look the latest version
> of MCS lock with load-acquire and store-release to see if it is now
> properly memory-barriered.

Don't worry, you cannot escape.  It is on my list.  ;-)

							Thanx, Paul

