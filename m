Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaA1UjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:39:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbaA1UjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:39:12 -0500
Message-ID: <52E8153A.2000208@zytor.com>
Date: Tue, 28 Jan 2014 12:38:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <20140128062806.GA20750@gmail.com>	<52E76997.40303@nod.at>	<52E7D2E5.8090208@linux.intel.com>	<52E7D9FF.1080506@nod.at>	<52E7DB15.3090808@zytor.com>	<CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>	<20140128170507.GA16279@gmail.com>	<CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>	<20140128194823.GA18702@gmail.com>	<CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>	<20140128201536.GB5178@pd.tnic> <CA+55aFwpsAatO7dy_jQM1NdM5VfJy33RaQ0tJzx+KN_oJsHcBQ@mail.gmail.com> <52E812F4.50906@nod.at>
In-Reply-To: <52E812F4.50906@nod.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 12:28 PM, Richard Weinberger wrote:
> Am 28.01.2014 21:25, schrieb Linus Torvalds:
>> On Tue, Jan 28, 2014 at 12:15 PM, Borislav Petkov <bp@alien8.de> wrote:
>>>
>>> Shouldn't we hold that down in the Kconfig help text of DEBUG_INFO?
>>> Something like:
>>>
>>> "You don't need to enable this if you want symbolic names for kernel
>>> objects. Enable CONFIG_KALLSYMS instead."
>>
>> Probably. And then we should make sure that allyesconfig/allmodconfig
>> don't pick it.
> 
> Let's make it depend on CONFIG_EXPERT.
> 

That doesn't solve all*config.  My scripts for all*config just overrides
it, maybe we need to do something like that by default?

	-hpa


