Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaJUPte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:49:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48410 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbaJUPtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:49:33 -0400
Message-ID: <54468063.4070408@zytor.com>
Date: Tue, 21 Oct 2014 08:48:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Pranith Kumar <bobby.prani@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cmpxchg: Discard unnecessary cast to volatile
References: <1412186248-18672-1-git-send-email-bobby.prani@gmail.com> <CAJhHMCDhhoxj25pmkxO2AhLwj6ur9ga3yRcViuH+DU-8K+Ch5g@mail.gmail.com> <20141021101412.GS23531@worktop.programming.kicks-ass.net>
In-Reply-To: <20141021101412.GS23531@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 03:14 AM, Peter Zijlstra wrote:
> On Mon, Oct 20, 2014 at 04:22:27PM -0400, Pranith Kumar wrote:
>>> Generating a volatile pointer is really not necessary here. This is the only
>>> location where a volatile pointer is being generated for use in asm.
>>>
>>> This commit removes the unnecessary volatile pointer being created.
>>>
>>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> 
> Seems sane enough to me.
> 

However, it seems like unnecessary churn.  Does the volatile hurt in any
way?

	-hpa

