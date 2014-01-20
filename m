Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaATXOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:14:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53996 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbaATXOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:14:17 -0500
Message-ID: <52DDAD9D.9030504@zytor.com>
Date: Mon, 20 Jan 2014 15:13:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Cong Ding <dinggnu@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>	<CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com> <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com>
In-Reply-To: <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 03:12 PM, Linus Torvalds wrote:
> On Mon, Jan 20, 2014 at 2:54 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> So I pulled this, but one question:
> 
> .. oh, and since I decided to test it, and was looking for problems:
> enabling kaslr breaks "perf". The *profile* looks fine, but the
> disassembly doesn't work.
> 
> I'm not entirely surprised. I decided I wanted to test it for a
> reason, after all. So it's not unexpected, but perhaps people hadn't
> thought about it, and clearly hadn't tested it.
> 
> Kernel modules disassemble fine, so clearly perf knows about code that
> moves around, but apparently it gets surprised when the core vmlinux
> file disassembly doesn't match addresses.
> 

So this is presumably something that needs to be fixed in perf?

	-hpa


