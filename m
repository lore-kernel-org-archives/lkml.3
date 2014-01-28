Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaA1G2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:28:12 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:41484 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaA1G2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:28:10 -0500
Date: Tue, 28 Jan 2014 07:28:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140128062806.GA20750@gmail.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
 <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
 <52E5EFAF.3060609@linux.intel.com>
 <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
 <CAGXu5jLcy9R_N_FQHMFheVTYSB9uobd-Orh7spEmpMaMXDtwEQ@mail.gmail.com>
 <52E6954F.2060303@nod.at>
 <CAGXu5jKXqUhTdhX_n8xSe+d3sPmZ0SK-aTQh2jCXWL6TgA5o=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKXqUhTdhX_n8xSe+d3sPmZ0SK-aTQh2jCXWL6TgA5o=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> On Mon, Jan 27, 2014 at 9:20 AM, Richard Weinberger <richard@nod.at> wrote:
> > Am 27.01.2014 18:05, schrieb Kees Cook:
> >> I would argue that decoding a non-panic oops on a running system is
> >> entirely possible as-is, since the offset can be found from
> >> /proc/kallsyms as root. It was the dead system that needed the offset
> >> exported: via text in the panic, or via an ELF note in a core.
> >
> > The problem is that you have to pickup information from two sources.
> > As a kernel developer users/customers often show you a backtrace (oops or panic)
> > and want you do find the problem.
> > They barley manage it copy&paste the topmost full trace from dmesg or /var/log/messages.
> > If I have to ask them a bit later to tell me the offset from /proc/kallsyms or something else
> > I'm lost. Mostly because they have already rebooted the box...
> 
> As long as I can turn it off, I'd be happy. :)
> /proc/sys/kernel/kaslr_in_oops or something?

Yeah, as long as it decodes by default.

Thanks,

	Ingo
