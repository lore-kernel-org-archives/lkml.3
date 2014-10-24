Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbaJXNey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:34:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45854 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbaJXNex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:34:53 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-79-544a5579f097
Message-id: <544A5578.7030009@samsung.com>
Date: Fri, 24 Oct 2014 15:34:48 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Daniel Drake <drake@endlessm.com>, Chanwoo Choi <cw00.choi@samsung.com>
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
        ideal.song@samsung.com, yj44.cho@samsung.com
Subject: Re: [PATCH 5/5] ARM: dts: Add dts files for Exynos4415 SoC
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
 <1413775935-17743-5-git-send-email-cw00.choi@samsung.com>
 <CAD8Lp46Y1WBF2Bq5SKtQDZ4kUb2fDCsbBs1THFWcV=8-OXh_SQ@mail.gmail.com>
In-reply-to: <CAD8Lp46Y1WBF2Bq5SKtQDZ4kUb2fDCsbBs1THFWcV=8-OXh_SQ@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t/xy7pVoV4hBvM3MFn8nXSM3WLSugNM
	Fte/PGe1eDT/MbPFnwmtbBa7/t5ntJh0fwKLxY6GI6wWN361sVr0LrjKZnG26Q27xZQ/y5ks
	Nj2+xmpxedccNosZ5/cxWdy+zGux9PpFJounEy6yWZy6/hkoPvklm8WxGUsYLVbt+sNosXfn
	ZEYHcY8189YwerQ097B5/P41idFj0fcsj7+rXjB77Jx1l93jzrU9bB6bl9R7XDnRxOrRt2UV
	o8fnTXIB3FFcNimpOZllqUX6dglcGcd+r2craGCvWLyoh7GB8QprFyMnh4SAicSas//ZIGwx
	iQv31gPZXBxCAksZJX5928YK4XxilFj24SRYB6+AlsTq9weAbA4OFgFViZ/XjEDCbAKGEl1v
	u8AGiQrESNzfuZoNolxQ4sfkeywg5SIC3hInvxeDjGQW6GeT+Hn2PxNIjbCAs0Tf0fksELtO
	MErc2XOUDaSBUyBYYvZlIZAaZgEziS8vD7NC2PISm9e8ZZ7AKDALyYpZSMpmISlbwMi8ilE0
	tTS5oDgpPddIrzgxt7g0L10vOT93EyMkdr/uYFx6zOoQowAHoxIP748tniFCrIllxZW5hxgl
	OJiVRHj9/b1ChHhTEiurUovy44tKc1KLDzEycXBKNTCuaDAxLJ+Q3MO8b+Fav1f3vtytbT9+
	72mvd/qHOUrVih/kj36fPE/yz9kM0wxB7TUl6g9eyhdOPDrx+Ou2JytcXQV2lyx8fK9IyDHp
	6pc7FU80Cpp8lN/1qiaEv0vnnfwjcROT7tfLTWL8IrYsL2Tk/L2SfsxrvL6AXb9etNOTsYwt
	JNbJxUmJpTgj0VCLuag4EQA6O1weuwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-24 15:23, Daniel Drake wrote:
> On Sun, Oct 19, 2014 at 9:32 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch adds new exynos4415.dtsi to support Exynos4415 SoC
>> based on Cortex-A9 quad cores and includes following dt nodes:
> There's a lot in common between your new exynos4415.dtsi and the
> existing exynos4.dtsi.
> Would it make more sense for the 4415 code to extend the existing
> exynos4.dtsi like the other Exynos4 variants do?

Well, I also thought about such approach, but there are some fundamental 
differences:
interrupt and clock controllers are completely different. Using a common 
exynos4.dtsi
and overriding them in every node will result in a code, which is a bit 
hard to follow.
IMHO with such differences justifies using separate base dtsi file.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

