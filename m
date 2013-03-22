Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161017Ab3CVQfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:35:17 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45959 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933488Ab3CVQfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:35:15 -0400
Date: Fri, 22 Mar 2013 09:34:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
 atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive .patch
 added to -mm tree
Message-ID: <20130322163454.GO3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130314162413.GA21344@redhat.com>
 <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com>
 <20130315134632.GA18335@redhat.com>
 <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com>
 <20130315165131.GA32065@redhat.com>
 <20130317172621.GQ3656@linux.vnet.ibm.com>
 <20130321170827.GA23539@redhat.com>
 <1363889025.4431.35.camel@edumazet-glaptop>
 <20130321183021.GA27586@redhat.com>
 <1363906618.4431.37.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363906618.4431.37.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032216-9360-0000-0000-0000117071B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 03:56:58PM -0700, Eric Dumazet wrote:
> On Thu, 2013-03-21 at 19:30 +0100, Oleg Nesterov wrote:
> 
> > To me, it would be better to kill atomic_inc_not_zero_hint() or unify
> > unify it with atomic_inc_not_zero(). But this is another story.
> 
> git is your friend.
> 
> I suggest you read 3f9d35b9514 changelog before killing it, thanks.

Hello, Eric,

Does the addition of a memory barrier in the not-zero case impose
too large a performance penalty?

							Thanx, Paul

