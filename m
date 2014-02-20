Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaBTSMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:12:07 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55324 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaBTSME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:12:04 -0500
Date: Thu, 20 Feb 2014 10:11:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140220181146.GU4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
 <1392740258.18779.7732.camel@triegel.csb>
 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
 <1392752867.18779.8120.camel@triegel.csb>
 <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
 <20140220040102.GM4250@linux.vnet.ibm.com>
 <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
 <20140220083032.GN4250@linux.vnet.ibm.com>
 <1392918846.18779.10204.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392918846.18779.10204.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022018-1344-0000-0000-000005ED9A96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 06:54:06PM +0100, Torvald Riegel wrote:
> xagsmtp4.20140220175519.1127@vmsdvm6.vnet.ibm.com
> X-Xagent-Gateway: vmsdvm6.vnet.ibm.com (XAGSMTP4 at VMSDVM6)
> 
> On Thu, 2014-02-20 at 00:30 -0800, Paul E. McKenney wrote:
> > Well, all the compilers currently convert consume to acquire, so you have
> > your wish there.  Of course, that also means that they generate actual
> > unneeded memory-barrier instructions, which seems extremely sub-optimal
> > to me.
> 
> GCC doesn't currently, but it also doesn't seem to track the
> dependencies, but that's a bug:
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59448

Ah, cool!

							Thanx, Paul

