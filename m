Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaA0Fdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 00:33:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:63859 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbaA0Fdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 00:33:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,727,1384329600"; 
   d="scan'208";a="472898040"
Message-ID: <52E5EFAF.3060609@linux.intel.com>
Date: Sun, 26 Jan 2014 21:33:35 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org> <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
In-Reply-To: <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 02:16 AM, Richard Weinberger wrote:
> 
> Currently we print the kernel offset only upon a panic() using the
> panic notifier list.
> This way it does not show up if the kernel hits a BUG() in process
> context or something less critical.
> Wouldn't make more sense to report the offset in every dump_stack() or
> show_regs() call?

No, because that information is available to user space unless we panic.

	-hpa

