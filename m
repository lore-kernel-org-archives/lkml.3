Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaCVC2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 22:28:10 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48483 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaCVC2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 22:28:03 -0400
Date: Sat, 22 Mar 2014 07:57:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
Message-ID: <20140322022754.GA21677@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CA+55aFyX0sj_MjTas3RYWWOa1W-xc3t0Af_0vdmsmgui8Apqpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032202-5816-0000-0000-00000CFBA179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > So reverting and applying v3 3/4 and 4/4 patches works for me.
> 
> Ok, I verified that the above endds up resulting in the same tree as
> the minimal patch I sent out, modulo (a) some comments and (b) an
> #ifdef CONFIG_SMP in futex_get_mm() that doesn't really matter.
> 
> So I committed the minimal patch with your tested-by.
> 

Just to be sure, I have verified with latest mainline with HEAD having
commit 08edb33c4 (Merge branch 'drm-fixes' of
git://people.freedesktop.org/~airlied/linux) which also has the commit
11d4616bd0 futex:( revert back to the explicit waiter counting code).

-- 
Thanks and Regards
Srikar Dronamraju

