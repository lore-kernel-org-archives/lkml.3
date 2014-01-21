Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaAUODS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:03:18 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36342 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaAUODQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:03:16 -0500
Date: Tue, 21 Jan 2014 15:03:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Cong Ding <dinggnu@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140121140311.GB4537@gmail.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
 <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
 <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com>
 <20140121102700.GB2981@gmail.com>
 <52DE7C49.90503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DE7C49.90503@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 01/21/2014 02:27 AM, Ingo Molnar wrote:
> > 
> > Hm, live annotation of the kernel image is a relatively new perf 
> > feature, and KASLR predated that (by years) - which would at least in 
> > part explain why it went unnoticed. (Although it does not excuse the 
> > lack of testing.)
> 
> kASLR is new, but on 32 bits we have relocated the kernel for a long 
> time. [...]

I doubt many people develop on 32-bit x86, and the group of people 
looking at annotated 32-bit assembly kernel profiles ought to be 
another order of magnitude smaller than that ...

> [...]  kASLR is the first use case of relocating the 64-bit kernel, 
> though.

Yeah.

Thanks,

	Ingo
