Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbaJXNg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:36:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17228 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbaJXNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:36:22 -0400
X-AuditID: cbfee68f-f791c6d000004834-28-544a55d3adf0
Message-id: <544A55D3.8000809@samsung.com>
Date: Fri, 24 Oct 2014 22:36:19 +0900
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
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/5] clk: samsung: exynos4415: Add clocks using common
 clock framework
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
 <1413775935-17743-2-git-send-email-cw00.choi@samsung.com>
 <CAD8Lp45F_6UWXx0f2xVGZL+Rgemg2fzkYhnfPdaeaiky0rKPgw@mail.gmail.com>
In-reply-to: <CAD8Lp45F_6UWXx0f2xVGZL+Rgemg2fzkYhnfPdaeaiky0rKPgw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTURzHObu7d3cz6+bzOLBgENFAy2dHDIsIvEZBpflHSrbs4nvarloR
	mqg9EHVzs1xDTE2x1tDSCDUzXw3zQYnTCfkgNZk5QVQs3+1B4H/f8/19z+d8D/xIzKkQF5IJ
	0nRGJpUkiwgBV+fiz3oNXz0fcUI/JEbbSj0PKes7OGj6xQyGthQPCdS6PQWQckrBRc05PTga
	23iEo6LKEQIN5pp5qHSrjoMaZ0ZxNNxaTiD1t3YO+jHsiGqNQxz0SzFEoD7jCoG6zY9xpFbN
	E0ivrgFI27oF0KcWFTjjTusqdIDOzysk6M0NJaCr/yTS21oTRrdoJnj0+GgbQTfVPKANvbk4
	XfxeC+iVxkOXHK4JTt1ikhMyGdnxkBuC+C/jmWnV5N1c4wieAyaIAsAnIeUPlyfagF27we+T
	DTbfiaoF0Kzx+J95Oj+NFwCBxS8D0FhSzbEfFgBcM69i1pQjJYadpSZLiiS51BFoqE+x2oTF
	/mwas0FdqUj4uszAtccPwr+qSZt2scQ36vJsD2BUOwGXP/TZBs5UNCzQGHB7o14A88dTrXw+
	FQ4b3oZabYw6CpUV1ZhdH4ZNukXMyoGUiYS/izU864BLUXBN1cW13oWUJ2zswOwf84Cdr8a4
	CuCm2VNJswer2YOtBJgWuDJpsWnszTiZnzcrSWEzpHHesakpjcCyJP07c/JmMNER3AUoEoj2
	OY6pwyKccEkmey+lCwRYWpRgQtfYVMteSdNjfPwCfVGAf4Cf78mgQJG7Y5VwPdyJipOkM0kM
	k8bIYmQZyQzbBTgkX5gDop7NKQ7oB/n5hDoJCXgf33hJ918Je76dVD+wEGXIYiuPna3aaAoJ
	kS/1r+5u3t99eSAnyHP9a4T3Zu/1rSLhQHa8sSTUHPxOf1GMk7Q8sTvOmBVmWpxN0t6uuHDn
	9LCzqGczeslzfSdy9mfwE2FheUB2Jqd51sFZTvHzzmVcFnHZeImPGJOxkn92kb4jHwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jQd3LoV4hBj//Klj8nXSM3WLSugNM
	Fo/mP2a2+DOhlc1i19/7jBaT7k9gsdjRcITV4savNlaL3gVX2SzONr1ht5jyZzmTxabH11gt
	Lu+aw2Yx4/w+Jovbl3ktll6/yGTxdMJFNotT1z+zWRx+085qMWPySzaLYzOWMFqs2vWH0WLv
	zsmMDuIea+atYfRoae5h8/j9axKjx6LvWR5/V71g9tg56y67x51re9g8Ni+p97hyoonVo2/L
	KkaPz5vkArijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BeVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmHL1TVrCIo6Lp
	+lXWBsa7bF2MnBwSAiYSU18+YoWwxSQu3FsPFOfiEBKYzihxfeIiJgjnNaPEtzdfmEGqeAW0
	JA5OeQHUwcHBIqAqcWVdLkiYDSi8/8UNsKGiAmESK6dfYYEoF5T4MfkemC0CVP5reTMryExm
	gX1sEp+2nQJLCAvESHTNugJ2hZDACUaJljv5IPM5BYIl1m9wBwkzC6hLTJq3iBnClpfYvOYt
	8wRGgVlIVsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGJ6pnUDsaVDRaH
	GAU4GJV4eG/M8AwRYk0sK67MPcQowcGsJMLr7+8VIsSbklhZlVqUH19UmpNafIjRFBgAE5ml
	RJPzgUk0ryTe0NjEzMjSyNzQwsjYXEmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QD48H0aTKL
	2idOmlzzYJ76QVd3Jk+TCPlVf5qk5IvfpSwxW/JBNY1v9eqEo5HW2X/CYx/cm3WCS0VH+PW7
	pp3ndlV+inweXOgg8t06/sD9z6pMlpvO7csVTkrK2eX6+PSWW5qy2YW3Gf4W7n+3vvP7d8Of
	UXPVzkncbJ3I0RkUWG/PsGsK7+vAciWW4oxEQy3mouJEAAPziIdqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 10/24/2014 10:18 PM, Daniel Drake wrote:
> On Sun, Oct 19, 2014 at 9:32 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch adds the new clock driver of Exynos4415 SoC based on Cortex-A9
>> using common clock framework. The CMU (Clock Management Unit) of Exynos4415
>> controls PLLs(Phase Locked Loops) and generates system clocks for CPU, buses
>> and function clocks for individual IPs.
> 
> There seems to be a lot in common here with other exynos4 variants in
> clk-exynos4.c. Have you considered just adding support for the 4415 in
> the existing driver?

Yes, It is difficult and to make existing clk-exynos4.c more complicated.
Exynos4415 has fewer difference from existing clk-exynos4.c and
different parent source of mux.

For exmaple about PLL,
There are different PLLs between Exynos4412 and Exynos4415.
- Exynos4412 has APLL, MPLL, EPLL, VPLL.
- Exynos4415 has APLL, EPLL, G3D_PLL, ISP_PLL, DISP_PLL and MPLL.
Also, MPLL of Exynos4415 was included in CMU_DMC scope.

Best Regards,
Chanwoo Choi

