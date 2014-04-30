Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbaD3UAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:00:51 -0400
Received: from li271-223.members.linode.com ([178.79.152.223]:58702 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759428AbaD3UAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:00:49 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2014 16:00:48 EDT
Message-ID: <53615451.4090500@mleia.com>
Date: Wed, 30 Apr 2014 22:51:45 +0300
From: Vladimir Zapolskiy <vz@mleia.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
CC: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, cpgs@samsung.com, t.figa@samsung.com,
        davem@davemloft.net
Subject: Re: [PATCH 0/7 v8] crypto:s5p-sss: Add Device tree and Exynos support
References: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com> <CAHfPSqDc=WYzdkuJuCY6uQQbcZQQ5SuD+kOfy-aymFL1v7=csg@mail.gmail.com> <20140430121450.GA5754@gondor.apana.org.au>
In-Reply-To: <20140430121450.GA5754@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20140430_205228_900046_0CDFD535 
X-CRM114-Status: GOOD (  18.46  )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen, Herbert,

On 04/30/14 15:14, Herbert Xu wrote:
> On Wed, Apr 30, 2014 at 04:38:05PM +0530, Naveen Krishna Ch wrote:
>> Hello All,
>>
>> On 28 April 2014 16:14, Naveen Krishna Chatradhi<ch.naveen@samsung.com>  wrote:
>>> SSS module on Exynos4210, Exynos5250 and Exynos5420 SoCs has added
>>> features to the one on S5PV210. However with minor changes the s5p-sss.c
>>> driver can be reused to support SSS modules on Exynos4 and 5 SoCs.
>>>
>>> This patch set
>>> 1. Adds device tree support to the s5p-sss.c driver and Documentation
>>> 2. Adds code to support SSS module on Exynos4 and 5 SoCs
>>> 3. Adds variant struct to handle the differences in SSS modules
>>> 4. Adds clk_prepare/clk_unprepare clocks to the s5p-sss.c driver
>>>
>>> Note: Compatible "exynos4210-secss" should work for Exynos4412 and
>>>        Exynos5260 (Exynos5260, for which ARCH code is under review)
>>> I couldn't test on Exynos4412 and Exynos4210 boards, Should be able to
>>> test with addition of DT node and clocks support.
>>>
>>> These patches are under review at
>>> https://lkml.org/lkml/2014/2/17/124
>>>
>>> Naveen Krishna Chatradhi (7):
>>>    crypto:s5p-sss: Use platform_get_irq() instead of _byname()
>>>    crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS driver
>>>    crypto:s5p-sss: Look for the next request in the queue
>>>    crypto:s5p-sss: Add device tree support
>>>    crypto:s5p-sss: Add support for SSS module on Exynos
>>>    crypto:s5p-sss: validate iv before memcpy
>>>    crypto:s5p-sss: Use clk_prepare/clk_unprepare
>>>
>>>   .../devicetree/bindings/crypto/samsung-sss.txt     |   35 +++++
>>>   drivers/crypto/Kconfig                             |    6 +-
>>>   drivers/crypto/s5p-sss.c                           |  145 +++++++++++++++-----
>>>   3 files changed, 150 insertions(+), 36 deletions(-)
>>>   create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt
>>
>> Can we get this series merged in.
>> Its has got reviewed and re-based several times and got acked by a
>> couple of seniors.
>
> Do you want me to pick these series up?
>
> Cheers,

thank you for this changeset, in my opinion it is quite good. To all changes

Acked-by: Vladimir Zapolskiy <vz@mleia.com>

--
With best wishes,
Vladimir
