Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3DZLqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:46:31 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:45294 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3DZLq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:46:29 -0400
Date: Fri, 26 Apr 2013 13:46:22 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/6] seccomp filter JIT
Message-ID: <20130426114622.GB3736@osiris>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
 <20130426112539.GA3736@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426112539.GA3736@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042611-0542-0000-0000-000005161EB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 01:25:39PM +0200, Heiko Carstens wrote:
> On Fri, Apr 26, 2013 at 03:51:40AM -0400, Xi Wang wrote:
> > This patchset brings JIT support to seccomp filters for x86_64 and ARM.
> > It is against the net-next tree.
> > 
> > The current BPF JIT interface only accepts sk_filter, not seccomp_filter.
> > Patch 1/6 refactors the interface to make it more general.
> > 
> > With the refactored interface, patches 2/6 and 3/6 implement the seccomp
> > BPF_S_ANC_SECCOMP_LD_W instruction in x86 & ARM JIT.
> > 
> > Status:
> > 
> > * x86_64 & ARM: JIT tested with seccomp examples.
> > 
> > * powerpc [4/6]: no seccomp change - compile checked.
> > 
> > * sparc [5/6] & s390 [6/6]: no seccomp change - untested.
> > 
> > Sorry I have no sparc or s390 build environment here.  Can someone help
> > check 5/6 and 6/6?  Thanks.
> 
> Your patches are against which tree?
> They don't apply on top of linux-next or Linus' linux tree.

Right... just right the subject of each patch description says, they apply
against net-next.

And build fine on s390.

> Btw. are there any test cases around for BPF JIT?
> Not only for the new seccomp but also netfilter?

This however is still a valid question.

