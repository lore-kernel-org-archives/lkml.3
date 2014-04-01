Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaDAXWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:22:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:41948 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbaDAXWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:22:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,776,1389772800"; 
   d="scan'208";a="504693420"
Date: Tue, 1 Apr 2014 16:22:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] asmlinkage, x86: Add explicit __visible to
 arch/x86/crypto/*
Message-ID: <20140401232208.GN32556@tassilo.jf.intel.com>
References: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
 <1396373557-3387-4-git-send-email-andi@firstfloor.org>
 <CA+55aFwUOe9twEU2F7K5PcDRPk-eS+B9CN=P327bhCYH9Ew=fg@mail.gmail.com>
 <CA+55aFyVD5MEt2-sKg8roFJymT1gHHadqq=+q1GBje=mObQhXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyVD5MEt2-sKg8roFJymT1gHHadqq=+q1GBje=mObQhXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Basically, all these grep's should return the empty set:
> 
>    git grep static.*__visible

All empty.


>    git grep extern.*__visible

There are some left over for this for those from earlier changes. 
I'll send another patch to fix those too.

>    git grep "__visible.*(.*);"

Same as above.

-Andi
