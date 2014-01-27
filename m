Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaA0RUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:20:23 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753477AbaA0RUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:20:22 -0500
Message-ID: <52E6954F.2060303@nod.at>
Date: Mon, 27 Jan 2014 18:20:15 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>	<CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>	<52E5EFAF.3060609@linux.intel.com>	<CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com> <CAGXu5jLcy9R_N_FQHMFheVTYSB9uobd-Orh7spEmpMaMXDtwEQ@mail.gmail.com>
In-Reply-To: <CAGXu5jLcy9R_N_FQHMFheVTYSB9uobd-Orh7spEmpMaMXDtwEQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2014 18:05, schrieb Kees Cook:
> I would argue that decoding a non-panic oops on a running system is
> entirely possible as-is, since the offset can be found from
> /proc/kallsyms as root. It was the dead system that needed the offset
> exported: via text in the panic, or via an ELF note in a core.

The problem is that you have to pickup information from two sources.
As a kernel developer users/customers often show you a backtrace (oops or panic)
and want you do find the problem.
They barley manage it copy&paste the topmost full trace from dmesg or /var/log/messages.
If I have to ask them a bit later to tell me the offset from /proc/kallsyms or something else
I'm lost. Mostly because they have already rebooted the box...

Thanks,
//richard
