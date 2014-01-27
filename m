Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaA0Hef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:34:35 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753273AbaA0Hee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:34:34 -0500
Message-ID: <52E60BFD.7030305@nod.at>
Date: Mon, 27 Jan 2014 08:34:21 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>	<CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>	<52E5EFAF.3060609@linux.intel.com> <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com> <52E60240.1010406@zytor.com>
In-Reply-To: <52E60240.1010406@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2014 07:52, schrieb H. Peter Anvin:
> Of course, stack traces themselves contain that information, so one
> could argue that oops=panic is required in order for kASLR to provide
> any kind of security against root.  (oops=panic is probably a good idea
> in secure environments anyway...)

Now I understand your point.

/proc/<pid>/stack and a world-readable /boot also need to be disabled.
Deploying a secure kASLR is not easy, especially for end-user distros.

Maybe a CONFIG_RANDOMIZE_BASE_I_MEAN_IT which disables various sources of
information leakage would help too. ;-)

Thanks,
//richard
