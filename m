Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaCCTBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:01:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbaCCTBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:01:53 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: paulmck@linux.vnet.ibm.com
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
In-Reply-To: <20140227175021.GT8264@linux.vnet.ibm.com>
References: <20140223003933.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	 <20140223063426.GT4250@linux.vnet.ibm.com>
	 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
	 <20140224172110.GO8264@linux.vnet.ibm.com>
	 <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
	 <20140224185341.GU8264@linux.vnet.ibm.com>
	 <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
	 <1393515453.28840.9961.camel@triegel.csb>
	 <20140227175021.GT8264@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Mar 2014 20:01:10 +0100
Message-ID: <1393873270.28840.11671.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 09:50 -0800, Paul E. McKenney wrote:
> Your proposal looks quite promising at first glance.  But rather than
> try and comment on it immediately, I am going to take a number of uses of
> RCU from the Linux kernel and apply your proposal to them, then respond
> with the results
> 
> Fair enough?

Sure.  Thanks for doing the cross-check!

