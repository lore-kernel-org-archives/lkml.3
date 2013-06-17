Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3FQPzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:55:49 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47372 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3FQPzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:55:46 -0400
Message-ID: <51BF317A.7040008@samsung.com>
Date: Tue, 18 Jun 2013 00:55:38 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Joe Perches <joe@perches.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] MAINTAINERS: Add exynos filename match to ARM/S5P
 EXYNOS ARM ARCHITECTURES
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>	<1371421068-28743-1-git-send-email-dianders@chromium.org>	<1371421068-28743-2-git-send-email-dianders@chromium.org>	<51BF2D52.2040000@samsung.com> <CAD=FV=Wy5H0JzDTtwo4p6TCk186G0KOecB7Tk=t2s0_XwzO2nw@mail.gmail.com>
In-Reply-To: <CAD=FV=Wy5H0JzDTtwo4p6TCk186G0KOecB7Tk=t2s0_XwzO2nw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/13 00:48, Doug Anderson wrote:
> Kukjin,
>
> On Mon, Jun 17, 2013 at 8:37 AM, Kukjin Kim<kgene.kim@samsung.com>  wrote:
>> On 06/17/13 07:17, Doug Anderson wrote:
>>>
>>> This will help direct patches related to exynos to the
>>> linux-samsung-soc mailing list for discussion.
>>>
>>> Suggested by Joe Perches.
>>>
>>> Signed-off-by: Doug Anderson<dianders@chromium.org>
>>
>>
>> Acked-by: Kukjin Kim<kgene.kim@samsung.com>
>
> I _think_ you can even apply this to your tree.  Looking at commits to
> MAINTAINERS it looks individual maintainers just include this in their
> trees, though I could be wrong.
>
OK, let me take this into samsung tree.

Thanks,
- Kukjin
