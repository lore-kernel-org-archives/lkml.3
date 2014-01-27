Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaA0GtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:49:14 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:41768 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaA0GtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:49:11 -0500
MIME-Version: 1.0
In-Reply-To: <52E5EFAF.3060609@linux.intel.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
	<CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
	<52E5EFAF.3060609@linux.intel.com>
Date: Mon, 27 Jan 2014 07:49:10 +0100
Message-ID: <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Richard Weinberger <richard.weinberger@gmail.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 6:33 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 01/26/2014 02:16 AM, Richard Weinberger wrote:
>>
>> Currently we print the kernel offset only upon a panic() using the
>> panic notifier list.
>> This way it does not show up if the kernel hits a BUG() in process
>> context or something less critical.
>> Wouldn't make more sense to report the offset in every dump_stack() or
>> show_regs() call?
>
> No, because that information is available to user space unless we panic.

Didn't you mean non-root?
I thought one has to set dmesg_restrict anyways if kASLR is used.

And isn't the offset available to perf too?
Of course only for root, but still user space.

-- 
Thanks,
//richard
