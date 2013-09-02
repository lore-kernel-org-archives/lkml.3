Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab3IBPST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:18:19 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38631 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab3IBPSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:18:18 -0400
MIME-Version: 1.0
In-Reply-To: <5224247E.3050600@roeck-us.net>
References: <1377914435-24206-1-git-send-email-linux@roeck-us.net>
	<CAF0htA6gW3h82p2sBBpFEi4s0MkQ-NUn79VXWLieZmYNuUPA6w@mail.gmail.com>
	<5224247E.3050600@roeck-us.net>
Date: Mon, 2 Sep 2013 23:18:17 +0800
Message-ID: <CAF0htA6sYZOvLt_JczGpfjEJZep6cAquJV9tZ2FwYC+C6ngzXQ@mail.gmail.com>
Subject: Re: [PATCH] Remove support for score architecture
From: Lennox Wu <lennox.wu@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liqin Chen <liqin299@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we start the development of the S+core, Sunplus had licensed
ARM and MIPS. We develop S+core for other reason such as the price.
Some products on the web of Sunplus adopt S+core , for example
the SPV7050.(http://w3.sunplus.com/products/spv7050.asp) These products
could still be bought from the market. Some high-end products adopt
ARM or MIPS. So, there is no conflict for a company adopts multiple
architectures.

As I said, we recognize that we rarely update because of the limited
applications and rare requests from customers. Maybe we don’t
understand the culture enough; we think that it is unnecessary if we
have no new bugs or new functions, the thought seems wrong. We can
commit some patches in the near future.

Best,
Lennox

2013/9/2 Guenter Roeck <linux@roeck-us.net>:
> On 09/01/2013 09:13 PM, Lennox Wu wrote:
>>
>> Dear all,
>>
>> Indeed, Sunplus S+core is not a popular architecture and there is no
>> standalone to be sold so you should not find related news on the
>> Internet.  However, the s+core is adopted by our SoCs and these SoCs
>> are indeed adopted by some companies, we hope the architecture can be
>> reserved to provide the more and more powerful Linux for our
>> customers. It is true that we rarely update the code because that we
>> are rarely requested to add new functions and to correct bugs by our
>> customers, and it is also because we have no new product to release.
>> In the near future, we will release some patches for the existed
>> S+core architecture.
>>
>
> Key question is not if the platform is popular, but if it is maintained.
> The commit log over the last two years strongly suggests that this is
> not the case. I suspect that the code is far from compilable at this point,
> much less executable. Unfortunately this is hard to verify, as a pre-built
> or even buildable toolchain is not easily available.
>
> From a company perspective, you might want to decide if you want to put
> resources into this architecture to keep it alive, or focus on more recent
> chips and architectures. Information available on the internet suggests
> that Suncore's more recent chips are based on ARM. Given that, it appears
> somewhat unlikely that resources for maintaining S+core will be made
> available. Guess we'll see if the situation changes.
>
> Guenter
>
>
>> 2013/8/31 Guenter Roeck <linux@roeck-us.net>:
>>>
>>> The web site associated with the score architecture in MAINTAINERS
>>> is non-functional and available for sale. The last Ack from one
>>> of the maintainers was in December 2012. The main maintainer's last
>>> commit was in 2011. The last maintainer pull request was early 2011.
>>>
>>> Cc: Lennox Wu <lennox.wu@gmail.com>
>>> Cc: Chen Liqin <liqin.chen@sunplusct.com>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>>> More housekeeping.
>>>
>>> Maybe this removal request is a bit early, but architecture support seems
>>> to have vanished entirely. At the very least this puts interested parties
>>> (if there are any) on notice.
>>>
>
