Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbaA1SzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:55:07 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755167AbaA1SzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:55:05 -0500
Message-ID: <52E7FCFB.90504@nod.at>
Date: Tue, 28 Jan 2014 19:54:51 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>	<CAGXu5jLcy9R_N_FQHMFheVTYSB9uobd-Orh7spEmpMaMXDtwEQ@mail.gmail.com>	<52E6954F.2060303@nod.at>	<CAGXu5jKXqUhTdhX_n8xSe+d3sPmZ0SK-aTQh2jCXWL6TgA5o=w@mail.gmail.com>	<20140128062806.GA20750@gmail.com>	<52E76997.40303@nod.at>	<52E7D2E5.8090208@linux.intel.com>	<52E7D9FF.1080506@nod.at>	<52E7DB15.3090808@zytor.com>	<CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>	<20140128170507.GA16279@gmail.com>	<CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>	<52E7E7D8.2050605@nod.at>	<CA+55aFyYoi_KW5h=RxvjXHe89ZgCifAiS=5DqRnvS=K=Rbitsg@mail.gmail.com>	<52E7EE54.8030408@nod.at> <CA+55aFwm7KQNmWJEQedempzEZHr9jJ7UdS3SBcCY9xteQ16-hw@mail.gmail.com>
In-Reply-To: <CA+55aFwm7KQNmWJEQedempzEZHr9jJ7UdS3SBcCY9xteQ16-hw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 28.01.2014 18:56, schrieb Linus Torvalds:
> On Tue, Jan 28, 2014 at 9:52 AM, Richard Weinberger <richard@nod.at> wrote:
>>
>> x/10i schedule+0x45 works.
> 
> Ok, so it's just list that is braindamaged. Maybe it wants a
> *(schedule+0x45) or something. I dunno. You can obviously get the hex
> number from just doing "p schedule+0x45" and then do that.

Ah, "list *(schedule+0x45)" works.
This reminds my why I never use gdb and like addr2line so much. ;D

Thanks,
//richard
