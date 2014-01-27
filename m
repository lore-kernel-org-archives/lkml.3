Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaA0RYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:24:19 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37466 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaA0RYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:24:18 -0500
MIME-Version: 1.0
In-Reply-To: <52E6954F.2060303@nod.at>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
	<CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
	<52E5EFAF.3060609@linux.intel.com>
	<CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
	<CAGXu5jLcy9R_N_FQHMFheVTYSB9uobd-Orh7spEmpMaMXDtwEQ@mail.gmail.com>
	<52E6954F.2060303@nod.at>
Date: Mon, 27 Jan 2014 09:24:17 -0800
X-Google-Sender-Auth: JWhhpWdGZ5p816hzhb5imYF-t-8
Message-ID: <CAGXu5jKXqUhTdhX_n8xSe+d3sPmZ0SK-aTQh2jCXWL6TgA5o=w@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Kees Cook <keescook@chromium.org>
To: Richard Weinberger <richard@nod.at>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 9:20 AM, Richard Weinberger <richard@nod.at> wrote:
> Am 27.01.2014 18:05, schrieb Kees Cook:
>> I would argue that decoding a non-panic oops on a running system is
>> entirely possible as-is, since the offset can be found from
>> /proc/kallsyms as root. It was the dead system that needed the offset
>> exported: via text in the panic, or via an ELF note in a core.
>
> The problem is that you have to pickup information from two sources.
> As a kernel developer users/customers often show you a backtrace (oops or panic)
> and want you do find the problem.
> They barley manage it copy&paste the topmost full trace from dmesg or /var/log/messages.
> If I have to ask them a bit later to tell me the offset from /proc/kallsyms or something else
> I'm lost. Mostly because they have already rebooted the box...

As long as I can turn it off, I'd be happy. :)
/proc/sys/kernel/kaslr_in_oops or something?

-Kees

-- 
Kees Cook
Chrome OS Security
