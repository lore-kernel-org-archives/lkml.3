Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbaA1PzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:55:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:15817 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbaA1PzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:55:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,736,1384329600"; 
   d="scan'208";a="473811591"
Message-ID: <52E7D2E5.8090208@linux.intel.com>
Date: Tue, 28 Jan 2014 07:55:17 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org> <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com> <52E5EFAF.3060609@linux.intel.com> <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com> <CAGXu5jLcy9R_N_FQHMFheVTYSB9uobd-Orh7spEmpMaMXDtwEQ@mail.gmail.com> <52E6954F.2060303@nod.at> <CAGXu5jKXqUhTdhX_n8xSe+d3sPmZ0SK-aTQh2jCXWL6TgA5o=w@mail.gmail.com> <20140128062806.GA20750@gmail.com> <52E76997.40303@nod.at>
In-Reply-To: <52E76997.40303@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 12:25 AM, Richard Weinberger wrote:
> 
> Yep.
> I like Ingo's idea (capital letters as indicators).
> Are we all fine with that?
> 

I guess it is extremely unlikely that we'd have a kernel address without
any letters... the "general solutions only please" part of my brain
wants to scream to handle that corner case, though.  The most logical
way would be to change the brackets.

It doesn't matter much, though.

	-hpa


