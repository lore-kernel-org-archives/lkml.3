Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaBRTkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:40:45 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33787 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaBRTkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:40:42 -0500
Date: Tue, 18 Feb 2014 11:40:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218194034.GT4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
 <1392486310.18779.6447.camel@triegel.csb>
 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
 <1392666947.18779.6838.camel@triegel.csb>
 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
 <20140218030002.GA15857@linux.vnet.ibm.com>
 <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
 <1392740258.18779.7732.camel@triegel.csb>
 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021819-0928-0000-0000-000006CCEFD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:44:48AM -0800, Linus Torvalds wrote:
> On Tue, Feb 18, 2014 at 8:17 AM, Torvald Riegel <triegel@redhat.com> wrote:

[ . . . ]

> > The standard is clear on what's required.  I strongly suggest reading
> > the formalization of the memory model by Batty et al.
> 
> Can you point to it? Because I can find a draft standard, and it sure
> as hell does *not* contain any clarity of the model. It has a *lot* of
> verbiage, but it's pretty much impossible to actually understand, even
> for somebody who really understands memory ordering.

I suspect he is thinking of the following:

"Mathematizing C++ Concurrency." Mark Batty, Scott Owens, Susmit Sarkar,
Peter Sewell, and Tjark Weber.
https://www.cl.cam.ac.uk/~pes20/cpp/popl085ap-sewell.pdf

Even if you don't like the math, it contains some very good examples.

							Thanx, Paul

