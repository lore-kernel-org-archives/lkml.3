Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaEES15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:27:57 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40937 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaEES1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:27:55 -0400
Date: Mon, 5 May 2014 20:27:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        peter@hurleysoftware.com, jason.low2@hp.com, riel@redhat.com,
        alex.shi@linaro.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com,
        davidlohr@hp.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [tip:locking/core] rwsem: Add comments to explain the meaning of
 the rwsem's count field
Message-ID: <20140505182750.GA14826@gmail.com>
References: <1399060437.2970.146.camel@schen9-DESK>
 <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
 <1399305808.2970.186.camel@schen9-DESK>
 <20140505172611.GA7154@gmail.com>
 <1399314085.2970.205.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399314085.2970.205.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Chen <tim.c.chen@linux.intel.com> wrote:

> On Mon, 2014-05-05 at 19:26 +0200, Ingo Molnar wrote:
> > * Tim Chen <tim.c.chen@linux.intel.com> wrote:
> > 
> > > On Mon, 2014-05-05 at 01:46 -0700, tip-bot for Tim Chen wrote:
> > > > Commit-ID:  3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> > > > Gitweb:     http://git.kernel.org/tip/3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> > > > Author:     Tim Chen <tim.c.chen@linux.intel.com>
> > > > AuthorDate: Fri, 2 May 2014 12:53:57 -0700
> > > > Committer:  Ingo Molnar <mingo@kernel.org>
> > > > CommitDate: Sun, 4 May 2014 20:34:26 +0200
> > > > 
> > > 
> > > Ingo,
> > > 
> > > Can you pick up this version of the patch instead.  I've updated the 
> > > comments to reflect all cases for which the rwsem's count is less 
> > > than WAITING_BIAS, as Peter has pointed out.
> > 
> > Please send a delta patch against the one I applied - and also the 
> > state diagram suggestion with Peter, once it's clear what form it 
> > should take. I've yet to see a state diagram that was inferior to 
> > equivalent textual description - is this case an exception to that?
> > 
> 
> Ingo,
> 
> The delta patch is included below.  Thinking a bit more,
> the state diagram approach is not necessarily less verbose
> because the state is a tuple (count, wait queue state).
> After enumerating the states, we may wind up with very similar
> to what I have.

Could we at least try with one diagram and see how it goes?

Thanks,

	Ingo
