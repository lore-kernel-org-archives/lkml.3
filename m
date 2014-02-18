Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaBRPQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:16:36 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:50254 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbaBRPQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:16:34 -0500
MIME-Version: 1.0
In-Reply-To: <20140218145645.GK4250@linux.vnet.ibm.com>
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
	<20140218145645.GK4250@linux.vnet.ibm.com>
Date: Tue, 18 Feb 2014 15:16:33 +0000
X-Google-Sender-Auth: Gk5FKr08XvYJ1lJsvU2Xv4TbtNs
Message-ID: <CAKKQTT0Z4220G34_PB_iW74UtEsgo3nt3Rbv3nPy0m6Mbwg+9g@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Mark Batty <Mark.Batty@cl.cam.ac.uk>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Cc: Peter Sewell <Peter.Sewell@cl.cam.ac.uk>, peterz@infradead.org,
        Torvald Riegel <triegel@redhat.com>, torvalds@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>, Ramana.Radhakrishnan@arm.com,
        dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@kernel.org, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thanks for the document. I'm looking forward to reading the bits about
dependency chains in Linux.

> One point of confusion for me...  Example 4 says "language must allow".
> Shouldn't that be "language is permitted to allow"?

When we say "allow", we mean that the optimised execution should be
allowed by the specification, and Implicitly, the unoptimised
execution should remain allowed too. We want to be concrete about what
the language specification allows, and that's why we say "must". It is
not to disallow the unoptimised execution.

> Seems like an
> implementation is always within its rights to avoid an optimization if
> its implementation prevents it from safely detecting the oppportunity
> for that optimization.

That's right.

- Mark


> Or am I missing something here?
>
>                                                         Thanx, Paul
>
