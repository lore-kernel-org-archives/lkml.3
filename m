Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaJXK7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:59:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61360 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbaJXK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:59:25 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-7e-544a310a814a
Message-id: <544A310A.7090803@samsung.com>
Date: Fri, 24 Oct 2014 19:59:22 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        ben-linux@fluff.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
        arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        mturquette@linaro.org, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        geunsik.lim@samsung.com, jh80.chung@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com, yj44.cho@samsung.com
Subject: Re: [PATCH 2/5] clk: samsung: exynos4415: Add clocks using common
 clock framework
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
 <1413775935-17743-2-git-send-email-cw00.choi@samsung.com>
 <544A2FF2.1000105@samsung.com>
In-reply-to: <544A2FF2.1000105@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42JZI2JSoMtl6BVi0LRc3eLvpGPsFpPWHWCy
	+DOhlc1i19/7jBaT7k9gsdjRcITV4savNlaL3gVX2SzONr1ht5jyZzmTxabH11gtLu+aw2Yx
	4/w+Jovbl3ktll6/yGTxdMJFNotT1z+zWRx+085qMWPySzaLYzOWMFqs2vWH0WLvzsmMDmIe
	a+atYfRoae5h8/j9axKjx99VL5g9ds66y+5x59oeNo/NS+o9rpxoYvXo27KK0ePzJrkArigu
	m5TUnMyy1CJ9uwSujLvt6xkLLnFUzFm7ibWBcTJ7FyMnh4SAicT9mYuZIGwxiQv31rOB2EIC
	SxkltmxTgamZtf0mUD0XUHwRo8T2JSeZIJzXjBIvP7xn7WLk4OAV0JJ4dDsapIFFQFXi3oxn
	rCA2G1B4/4sbYENFBcIkVk6/wgJi8woISvyYfA/MFhHQl1iy6iJYDbPAVBaJv+9MQGxhgRiJ
	rllXWOEWX2x/C3Y1p4C2xMHfIB9wADXoSdy/qAXRKy+xec1bZpB6CYE7HBJ/J15hhThIQOLb
	5EMsIPUSArISmw4wQzwmKXFwxQ2WCYxis5CcNAth6iwkUxcwMq9iFE0tSC4oTkovMtErTswt
	Ls1L10vOz93ECEwbp/89m7CD8d4B60OMAhyMSjy8BrM9Q4RYE8uKK3MPMZoCHTGRWUo0OR+Y
	nPJK4g2NzYwsTE1MjY3MLc2UxHlfS/0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBYa6S1
	8ZlAqdAVzRO77/Cs8PVbo3vjh7+P3CkuIYmnBXzcquqf4t6U/3x0emHqPLZli4ze77q1Rf90
	auqXNudWjWkiT/rytsed2H7k6LerTgVrP5yvvrTkbO//2SVcE5tnqqZr2Jl83La406lX1Tdh
	bU7XTw493dtHXRjzCvcedXi+xHZ57+J1SizFGYmGWsxFxYkAtfocHxYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAV0uQ68Qg773shZ/Jx1jt5i07gCT
	xZ8JrWwWu/7eZ7SYdH8Ci8WOhiOsFjd+tbFa9C64ymZxtukNu8WUP8uZLDY9vsZqcXnXHDaL
	Gef3MVncvsxrsfT6RSaLpxMuslmcuv6ZzeLwm3ZWixmTX7JZHJuxhNFi1a4/jBZ7d05mdBDz
	WDNvDaNHS3MPm8fvX5MYPf6uesHssXPWXXaPO9f2sHlsXlLvceVEE6tH35ZVjB6fN8kFcEU1
	MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2qpFCW
	mFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcy4276eseASR8WctZtYGxgns3cx
	cnJICJhIzNp+E8oWk7hwbz1bFyMXh5DAIkaJ7UtOMkE4rxklXn54z9rFyMHBK6Al8eh2NEgD
	i4CqxL0Zz1hBbDag8P4XN9hAbFGBMImV06+wgNi8AoISPybfA7NFBPQllqy6CFbDLDCVReLv
	OxMQW1ggRqJr1hVWuMUX29+CXcQpoC1x8DfIpRxADXoS9y9qQfTKS2xe85Z5AqPALCQrZiFU
	zUJStYCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcFp6JrWDcWWDxSFGAQ5GJR7eGzM8
	Q4RYE8uKK3MPMUpwMCuJ8L5U8woR4k1JrKxKLcqPLyrNSS0+xGgKDICJzFKiyfnAlJlXEm9o
	bGJmZGlkbmhhZGyuJM57oNU6UEggPbEkNTs1tSC1CKaPiYNTqoGxlNdF22N/ZtiZou1nnqwx
	WrjlXlFt3ARV7++7un2/9G+PXJv1sMhz8tGkG9E/0mP3sMvWL+OIfpTqd5eHT+mGiccEFZWr
	pqYpjz2zmv4ZnOI9qu+9IWX1V/1H0lf/37GL9O7gC3CysTtYEVbn5nn32T0faZkP/JeFN7Cb
	JwRtiN0a8m/2l31KLMUZiYZazEXFiQAVwRHRYQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 07:54 PM, Sylwester Nawrocki wrote:
> On 20/10/14 05:32, Chanwoo Choi wrote:
>> This patch adds the new clock driver of Exynos4415 SoC based on Cortex-A9
>> using common clock framework. The CMU (Clock Management Unit) of Exynos4415
>> controls PLLs(Phase Locked Loops) and generates system clocks for CPU, buses
>> and function clocks for individual IPs.
>>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> The patch looks good to me, I've applied it to my tree and will
> be sending in a pull request to Mike next week, if there is no
> objections.

Thanks,

I'll send new patchset(v2) for following Exynos4412 patches right now.

  clk: samsung: exynos4415: Add clocks using common clock framework
  clk: samsung: Document binding for Exynos4415 clock controller

Best Regards,
Chanwoo Choi
