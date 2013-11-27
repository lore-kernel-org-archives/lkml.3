Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3K0R4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:56:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50362 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3K0R4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:56:45 -0500
Message-ID: <52963223.9080701@zytor.com>
Date: Wed, 27 Nov 2013 09:55:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olofj@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] use -fstack-protector-strong
References: <20131126203727.GA352@www.outflux.net> <20131127112731.GA10435@gmail.com> <CAGXu5jLY+AzaB4f92OLA6Orm=Mr9C+G+-mgOmSf-yju+YCmaUg@mail.gmail.com> <20131127175442.GA28088@gmail.com>
In-Reply-To: <20131127175442.GA28088@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 09:54 AM, Ingo Molnar wrote:
>>
>> Looks to be 2% for defconfig. That's way better. Shall I send a v3?
> 
> Well, it's better than 9%, but still almost an order of magnitude 
> higher than the cost is today, and a lot of distros have 
> CONFIG_CC_STACKPROTECTOR=y.
> 
> So it would be nice to measure how much the instruction count goes up 
> in some realistic system-bound test. How much does something like 
> kernel/built-in.o increase, as per 'size' output?
> 

Do we need CONFIG_CC_STACKPROTECTOR_STRONG?

	-hpa


