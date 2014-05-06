Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767AbaEFCap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 22:30:45 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:48549 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbaEFCao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 22:30:44 -0400
Message-ID: <1399343437.2498.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [tip:locking/core] rwsem: Add comments to explain the meaning
 of the rwsem's count field
From: Davidlohr Bueso <davidlohr@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-tip-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, peter@hurleysoftware.com, jason.low2@hp.com,
        riel@redhat.com, alex.shi@linaro.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 05 May 2014 19:30:37 -0700
In-Reply-To: <1399330276.2970.207.camel@schen9-DESK>
References: <1399060437.2970.146.camel@schen9-DESK>
	 <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
	 <1399305808.2970.186.camel@schen9-DESK> <20140505172611.GA7154@gmail.com>
	 <1399314085.2970.205.camel@schen9-DESK>  <20140505182750.GA14826@gmail.com>
	 <1399330276.2970.207.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 15:51 -0700, Tim Chen wrote:
> On Mon, 2014-05-05 at 20:27 +0200, Ingo Molnar wrote:
> 
> > > Ingo,
> > > 
> > > The delta patch is included below.  Thinking a bit more,
> > > the state diagram approach is not necessarily less verbose
> > > because the state is a tuple (count, wait queue state).
> > > After enumerating the states, we may wind up with very similar
> > > to what I have.
> > 
> > Could we at least try with one diagram and see how it goes?
> > 
> 
> I've tried (see below).  But I don't like how it came out :(

And quite nice, thanks for doing this. Personally, however, I much
prefer the already applied patch to this approach.

Thanks,
Davidlohr

