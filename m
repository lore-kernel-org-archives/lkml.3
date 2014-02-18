Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaBRRRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:17:55 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:34964 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaBRRRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:17:52 -0500
Date: Tue, 18 Feb 2014 09:17:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mark Batty <Mark.Batty@cl.cam.ac.uk>
Cc: Peter Sewell <Peter.Sewell@cl.cam.ac.uk>, peterz@infradead.org,
        Torvald Riegel <triegel@redhat.com>, torvalds@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>, Ramana.Radhakrishnan@arm.com,
        dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@kernel.org, gcc@gcc.gnu.org
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218171746.GQ4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
 <20140218145645.GK4250@linux.vnet.ibm.com>
 <CAKKQTT0Z4220G34_PB_iW74UtEsgo3nt3Rbv3nPy0m6Mbwg+9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKKQTT0Z4220G34_PB_iW74UtEsgo3nt3Rbv3nPy0m6Mbwg+9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021817-7164-0000-0000-0000062E57F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 03:16:33PM +0000, Mark Batty wrote:
> Hi Paul,
> 
> Thanks for the document. I'm looking forward to reading the bits about
> dependency chains in Linux.

And I am looking forward to your thoughts on those bits!

> > One point of confusion for me...  Example 4 says "language must allow".
> > Shouldn't that be "language is permitted to allow"?
> 
> When we say "allow", we mean that the optimised execution should be
> allowed by the specification, and Implicitly, the unoptimised
> execution should remain allowed too. We want to be concrete about what
> the language specification allows, and that's why we say "must". It is
> not to disallow the unoptimised execution.

OK, got it!

							Thanx, Paul

> > Seems like an
> > implementation is always within its rights to avoid an optimization if
> > its implementation prevents it from safely detecting the oppportunity
> > for that optimization.
> 
> That's right.
> 
> - Mark
> 
> 
> > Or am I missing something here?
> >
> >                                                         Thanx, Paul
> >
> 

