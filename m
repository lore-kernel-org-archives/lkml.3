Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab3I3SVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:21:18 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53078 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab3I3SVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:21:15 -0400
Date: Mon, 30 Sep 2013 20:21:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Haggai Eran <haggaie@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH] anon_vmas: Convert the rwsem to an rwlock_t
Message-ID: <20130930182112.GA6931@two.firstfloor.org>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <20130928193739.GA8642@gmail.com>
 <20130930085243.GA25685@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930085243.GA25685@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nvidia is now also going to use mmu notifier to allow the GPU (acting
> as a secondary MMU with pagetables) to access main memory without

That's a good point. iirc AMD GPUs are also going into 
the same direction, and likely more. So we probably need
to support that usage.

Too bad :-/

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
