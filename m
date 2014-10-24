Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbaJXNx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:53:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28895 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbaJXNxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:53:53 -0400
X-AuditID: cbfee68d-f79296d000004278-55-544a59ee0db2
Message-id: <544A59EE.7010300@samsung.com>
Date: Fri, 24 Oct 2014 22:53:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Daniel Drake <drake@endlessm.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, ben-linux@fluff.org,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, thomas.abraham@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        InKi Dae <inki.dae@samsung.com>, geunsik.lim@samsung.com,
        jh80.chung@samsung.com, jaewon02.kim@samsung.com,
        ideal.song@samsung.com, yj44.cho@samsung.com,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 5/5] ARM: dts: Add dts files for Exynos4415 SoC
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
 <1413775935-17743-5-git-send-email-cw00.choi@samsung.com>
 <CAD8Lp46Y1WBF2Bq5SKtQDZ4kUb2fDCsbBs1THFWcV=8-OXh_SQ@mail.gmail.com>
In-reply-to: <CAD8Lp46Y1WBF2Bq5SKtQDZ4kUb2fDCsbBs1THFWcV=8-OXh_SQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSpPsu0ivEYPcdQ4u/k46xW0xad4DJ
	4tH8x8wWfya0slns+nuf0WLS/QksFjsajrBa3PjVxmrRu+Aqm8XZpjfsFlP+LGey2PT4GqvF
	5V1z2CxmnN/HZHH7Mq/F2iN32S2WXr/IZPF0wkU2i1PXPwMlJ79kszg2Ywmjxapdfxgt9u6c
	zOgg7rFm3hpGj5bmHjaP378mMXos+p7l8XfVC2aPnbPusnvcubaHzWPzknqPKyeaWD36tqxi
	9Pi8SS6AO4rLJiU1J7MstUjfLoEro/XtaeaCZWwVSz/rNjBOYu1i5OSQEDCRWH6shxnCFpO4
	cG89G4gtJLCUUWJBfyVMzeXrl1kh4osYJc7MLepi5AKyXzNK7Ft1ggUkwSugJdHa85oJxGYR
	UJVo3fsbrIENKL7/xQ2woaICYRIrp1+BqheU+DH5HpgtAlT/a3kzK8hQZoF9bBL3/h0Au0hY
	wFmi7+h8FohtJxgl7uw5CjSJg4NTIFhi9mUhkBpmAXWJSfMWMUPY8hKb17xlBqmXEHjBIbHs
	4Uk2iIsEJL5NPsQC0ishICux6QDUx5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ
	6UWGesWJucWleel6yfm5mxiBqeT0v2e9OxhvH7A+xCjAwajEw3tjhmeIEGtiWXFl7iFGU6Ar
	JjJLiSbnAxNWXkm8obGZkYWpiamxkbmlmZI4r6LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjEtsmPO5XnVqhU9muJmUobhG5vku5yM/TrwOF9ra817RxDn56Jnur/m7+hU2lX7/JBC5
	/MTqQG7px7orppWlVZ8IbsiZWuPtUSv6JCi27cXTxVK9TKmz003TdLq0bc5kGckw74x64JN/
	xehKRunDvGMz74VNUv/2aX1D0ZrzFXe2F5m5bZmxVYmlOCPRUIu5qDgRAO5s7ZQgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jAd13kV4hBt9Pq1v8nXSM3WLSugNM
	Fo/mP2a2+DOhlc1i19/7jBaT7k9gsdjRcITV4savNlaL3gVX2SzONr1ht5jyZzmTxabH11gt
	Lu+aw2Yx4/w+Jovbl3kt1h65y26x9PpFJounEy6yWZy6/hkoOfklm8WxGUsYLVbt+sNosXfn
	ZEYHcY8189YwerQ097B5/P41idFj0fcsj7+rXjB77Jx1l93jzrU9bB6bl9R7XDnRxOrRt2UV
	o8fnTXIB3FENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6
	bpk5QC8rKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDNa355mLljGVrH0
	s24D4yTWLkZODgkBE4nL1y9D2WISF+6tZwOxhQQWMUqcmVvUxcgFZL9mlNi36gQLSIJXQEui
	tec1E4jNIqAq0br3N1gzG1B8/4sbYM2iAmESK6dfgaoXlPgx+R6YLQJU/2t5MyvIUGaBfWwS
	9/4dYAZJCAs4S/Qdnc8Cse0Eo8SdPUeBJnFwcAoES8y+LARSwyygLjFp3iJmCFteYvOat8wT
	GAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEp6pnUjsYVzZYHGIU
	4GBU4uG9McMzRIg1say4MvcQowQHs5IIr7+/V4gQb0piZVVqUX58UWlOavEhRlNgEExklhJN
	zgem0bySeENjEzMjSyNzQwsjY3Mlcd4DrdaBQgLpiSWp2ampBalFMH1MHJxSDYybljyQett4
	lv9UYq/es4ziqSmma0q/hFyMiw/J6Vi7q9R8wqczh14wLc/NbO59H7f4T1BK1KyT3IvMF9my
	2nLtiuXmcL1xMP6MsdWpf++8Hlx5prxQOfLq9cB11nM7JB8fTP6RxL7xn17clYwCxU9PpixN
	q/i8/Q8Xl+Cz+LRTAZMtBTZYOXxVYinOSDTUYi4qTgQAF9GQTWsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 10/24/2014 10:23 PM, Daniel Drake wrote:
> On Sun, Oct 19, 2014 at 9:32 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch adds new exynos4415.dtsi to support Exynos4415 SoC
>> based on Cortex-A9 quad cores and includes following dt nodes:
> 
> There's a lot in common between your new exynos4415.dtsi and the
> existing exynos4.dtsi.
> Would it make more sense for the 4415 code to extend the existing
> exynos4.dtsi like the other Exynos4 variants do?

I explained the difference between Exynos4415 and existing Exynos4 series
on mail-thread of exynos4415 clock controller.

Exynos4415 has difference clock id from existing Exynos4 clock controller.
because exynos4415 clock controller has fewer difference from Exynos4 series.

Best Regards,
Chanwoo Choi

