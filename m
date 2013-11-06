Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3KFVoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:44:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55626 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264Ab3KFVn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:43:58 -0500
Message-ID: <527AB7CA.4020502@zytor.com>
Date: Wed, 06 Nov 2013 13:42:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Will Deacon <will.deacon@arm.com>, "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v3 0/4] MCS Lock: MCS lock code cleanup and optimizations
References: <cover.1383771175.git.tim.c.chen@linux.intel.com> <1383773816.11046.352.camel@schen9-DESK>
In-Reply-To: <1383773816.11046.352.camel@schen9-DESK>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 01:36 PM, Tim Chen wrote:
> In this patch series, we separated out the MCS lock code which was
> previously embedded in the mutex.c.  This allows for easier reuse of
> MCS lock in other places like rwsem and qrwlock.  We also did some micro
> optimizations and barrier cleanup.
> 
> This patches were previously part of the rwsem optimization patch series
> but now we spearate them out.
> 
> Tim Chen

Perhaps I'm missing something here, but what is MCS lock and what is the
value?

	-hpa


