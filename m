Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3IBFjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 01:39:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55381 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3IBFjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 01:39:13 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5224247E.3050600@roeck-us.net>
Date: Sun, 01 Sep 2013 22:39:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lennox Wu <lennox.wu@gmail.com>
CC: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liqin Chen <liqin299@gmail.com>
Subject: Re: [PATCH] Remove support for score architecture
References: <1377914435-24206-1-git-send-email-linux@roeck-us.net> <CAF0htA6gW3h82p2sBBpFEi4s0MkQ-NUn79VXWLieZmYNuUPA6w@mail.gmail.com>
In-Reply-To: <CAF0htA6gW3h82p2sBBpFEi4s0MkQ-NUn79VXWLieZmYNuUPA6w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2013 09:13 PM, Lennox Wu wrote:
> Dear all,
>
> Indeed, Sunplus S+core is not a popular architecture and there is no
> standalone to be sold so you should not find related news on the
> Internet.  However, the s+core is adopted by our SoCs and these SoCs
> are indeed adopted by some companies, we hope the architecture can be
> reserved to provide the more and more powerful Linux for our
> customers. It is true that we rarely update the code because that we
> are rarely requested to add new functions and to correct bugs by our
> customers, and it is also because we have no new product to release.
> In the near future, we will release some patches for the existed
> S+core architecture.
>

Key question is not if the platform is popular, but if it is maintained.
The commit log over the last two years strongly suggests that this is
not the case. I suspect that the code is far from compilable at this point,
much less executable. Unfortunately this is hard to verify, as a pre-built
or even buildable toolchain is not easily available.

 From a company perspective, you might want to decide if you want to put
resources into this architecture to keep it alive, or focus on more recent
chips and architectures. Information available on the internet suggests
that Suncore's more recent chips are based on ARM. Given that, it appears
somewhat unlikely that resources for maintaining S+core will be made
available. Guess we'll see if the situation changes.

Guenter

> 2013/8/31 Guenter Roeck <linux@roeck-us.net>:
>> The web site associated with the score architecture in MAINTAINERS
>> is non-functional and available for sale. The last Ack from one
>> of the maintainers was in December 2012. The main maintainer's last
>> commit was in 2011. The last maintainer pull request was early 2011.
>>
>> Cc: Lennox Wu <lennox.wu@gmail.com>
>> Cc: Chen Liqin <liqin.chen@sunplusct.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> More housekeeping.
>>
>> Maybe this removal request is a bit early, but architecture support seems
>> to have vanished entirely. At the very least this puts interested parties
>> (if there are any) on notice.
>>

