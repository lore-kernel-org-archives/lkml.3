Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaBXPwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:52:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36584 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbaBXPwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:52:38 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140224154841.GG12219@tassilo.jf.intel.com>
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au> <20140224154841.GG12219@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: linux-next: build warning after merge of the tip tree
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 24 Feb 2014 07:51:42 -0800
To: Andi Kleen <ak@linux.intel.com>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <5631f550-8a43-4831-8a62-a47451dbbb1b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static asmlinkage can make sense if a pointer to the function is taken somewhere in the same translation unit.

On February 24, 2014 7:48:41 AM PST, Andi Kleen <ak@linux.intel.com> wrote:
>> I guess that there may be more places where "asmlinkage" is used with
>> "static" - I assume that they are all incorrect?
>
>Likely they are bogus yes.
>
>One issue is still the changed ABI on i386, so one has to double check
>before removing if they have arguments.
>
>-Andi

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
