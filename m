Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaA1RYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:24:46 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755298AbaA1RYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:24:44 -0500
Message-ID: <52E7E7D8.2050605@nod.at>
Date: Tue, 28 Jan 2014 18:24:40 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>	<CAGXu5jLcy9R_N_FQHMFheVTYSB9uobd-Orh7spEmpMaMXDtwEQ@mail.gmail.com>	<52E6954F.2060303@nod.at>	<CAGXu5jKXqUhTdhX_n8xSe+d3sPmZ0SK-aTQh2jCXWL6TgA5o=w@mail.gmail.com>	<20140128062806.GA20750@gmail.com>	<52E76997.40303@nod.at>	<52E7D2E5.8090208@linux.intel.com>	<52E7D9FF.1080506@nod.at>	<52E7DB15.3090808@zytor.com>	<CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>	<20140128170507.GA16279@gmail.com> <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
In-Reply-To: <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.01.2014 18:12, schrieb Linus Torvalds:
> On Tue, Jan 28, 2014 at 9:05 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> Well, I often use the hex numbers to look them up and disassemble them
>> in a vmlinux via gdb and 'list *0x1234123412341234' - where the
>> vmlinux has no debuginfo. (Debuginfo takes longer to build so I
>> generally build without it.)
> 
> Why the heck wouldn't you do that? Just do
> 
>    list schedule+0x45
> 
> instead.

Hmm, my gdb does not like that notion.

(gdb) list schedule+0x45
Function "schedule+0x45" not defined.

It thinks +0x45 is part of the function name, adding spaces also does not help.
Or am I doing something very stupid?

Thanks,
//richard
