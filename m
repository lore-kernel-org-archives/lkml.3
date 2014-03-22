Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaCVDgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 23:36:37 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:45754 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaCVDge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 23:36:34 -0400
Message-ID: <1395459391.2546.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Fri, 21 Mar 2014 20:36:31 -0700
In-Reply-To: <20140322022754.GA21677@linux.vnet.ibm.com>
References: <20140320053350.GB30295@linux.vnet.ibm.com>
	 <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
	 <1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwH2sJKCH6hUf8H-7nMPo8YwFCR6oP8McZ5VpMcGDrYSw@mail.gmail.com>
	 <1395342510.14694.43.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFw8wSe-DUtZ8=rjFJzXYmOSsZ0JzS-_jsZKrDai8LZMXw@mail.gmail.com>
	 <1395346808.14694.62.camel@buesod1.americas.hpqcorp.net>
	 <20140321045501.GD30295@linux.vnet.ibm.com>
	 <CA+55aFyX0sj_MjTas3RYWWOa1W-xc3t0Af_0vdmsmgui8Apqpw@mail.gmail.com>
	 <20140322022754.GA21677@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-22 at 07:57 +0530, Srikar Dronamraju wrote:
> > > So reverting and applying v3 3/4 and 4/4 patches works for me.
> > 
> > Ok, I verified that the above endds up resulting in the same tree as
> > the minimal patch I sent out, modulo (a) some comments and (b) an
> > #ifdef CONFIG_SMP in futex_get_mm() that doesn't really matter.
> > 
> > So I committed the minimal patch with your tested-by.
> > 
> 
> Just to be sure, I have verified with latest mainline with HEAD having
> commit 08edb33c4 (Merge branch 'drm-fixes' of
> git://people.freedesktop.org/~airlied/linux) which also has the commit
> 11d4616bd0 futex:( revert back to the explicit waiter counting code).

Thanks for double checking.

