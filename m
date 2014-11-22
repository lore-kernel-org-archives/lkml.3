Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaKVC1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 21:27:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61243 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaKVC1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 21:27:12 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-ac-546ff47dd0d1
From: Kukjin Kim <kgene@kernel.org>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Kukjin Kim'" <kgene@kernel.org>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Pankaj Dubey'" <pankaj.dubey@samsung.com>,
        "'Vikas Sajjan'" <vikas.sajjan@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <4728982.ETBlJctOKU@amdc1032>
In-reply-to: <4728982.ETBlJctOKU@amdc1032>
Subject: RE: [PATCH v5] ARM: EXYNOS: add Exynos3250 PMU support
Date: Sat, 22 Nov 2014 11:27:09 +0900
Message-id: <02fb01d005fb$d105c1d0$73114570$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLHBiiK4DWzc7VjsX0mTTpTjnIY4pp95wKg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsWyRsSkRbf2S36Iwbn3+hYbZ6xntbj+5Tmr
	Rf/j18wWZ5vesFtsenyN1eLyrjlsFjPO72OyWLT1C7vFql1/GC1uPtvO5MDlsXPWXXaPTas6
	2Tw2L6n36NuyitHj8ya5ANYoLpuU1JzMstQifbsErow7k1QLFglVTJt7lK2BcQl/FyMHh4SA
	iUTviuwuRk4gU0ziwr31bF2MXBxCAksZJba93csGU7PxVSZEfBGjRNO2BawgDUICfxklDrVJ
	g9SwCShLNDbpg4SFBbQkFm5pYgGxRQRiJc5sm8wIYjMLHGWSmL04B6JVU+LB92tsIDYnUH3j
	j5vsEL32ErfP3wOLswioSuw89RQszitgIfG+/xIrhC0o8WPyPRaImVoS63ceZ4Kw5SU2r3nL
	DPGLgsSOs68ZIW4wkpjRegSqRkRi34t3jCC/SAi0cki0T/vGDLFMQOLb5EMsEP/KSmw6ADVH
	UuLgihssExglZyFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMBY
	P/3v2YQdjPcOWB9iFOBgVOLh5biZHyLEmlhWXJl7iNEU6KKJzFKiyfnAhJJXEm9obGZkYWpi
	amxkbmmmJM77WupnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGi/RGx1/Nhu6mq2/lFH7a
	8Xv2XP0Tqzfv4HXo8VrWPzNiXknmyVf7JlxzaCtYZLMk6ekJEfEtZu4Hz/9aMvntggsXsm8E
	LvHsrJhwa0m6ksWhSZbZybqWWi1P0wTev1t5IcnzvszH68+keSUmWbAarTwuHTvjSP0z9fKr
	i9x1GU8Uuh/o5+nYrsRSnJFoqMVcVJwIALlLTWDwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd3aL/khBn/eaFlsnLGe1eL6l+es
	Fv2PXzNbnG16w26x6fE1VovLu+awWcw4v4/JYtHWL+wWq3b9YbS4+Ww7kwOXx85Zd9k9Nq3q
	ZPPYvKTeo2/LKkaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm
	3JmkWrBIqGLa3KNsDYxL+LsYOTgkBEwkNr7K7GLkBDLFJC7cW8/WxcjFISSwiFGiadsCVpCE
	kMBfRolDbdIg9WwCyhKNTfogYWEBLYmFW5pYQGwRgViJM9smM4LYzAJHmSRmL86BaNWUePD9
	GhuIzQlU3/jjJjtEr73E7fP3wOIsAqoSO089BYvzClhIvO+/xAphC0r8mHyPBWKmlsT6nceZ
	IGx5ic1r3jJD3KwgsePsa0aIG4wkZrQegaoRkdj34h3jBEbhWUhGzUIyahaSUbOQtCxgZFnF
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxKnknvYFzVYHGIUYCDUYmHN+F2fogQa2JZcWXu
	IUYJDmYlEV6T00Ah3pTEyqrUovz4otKc1OJDjKZAn05klhJNzgemubySeENjEzMjSyMzCyMT
	c3Mlcd4bN3NDhATSE0tSs1NTC1KLYPqYODilGhj78iqWzn7+nmPJdX4Fjt3nq/6dk91yV3aZ
	gyT73MPSBzTEL+dcr5SImH7u3LHJqcy74pxrr65elqB6T56p86aPQOikLQe+tjw6qqm4e8a7
	QK55F9w6L3tYPM9uy2F+aKy0Q8ot4Pv/VRsqLyQl3OkTnHL13NXL1woTb60RYrJwW1zf3DrB
	/ZSeEktxRqKhFnNRcSIAw1+mFTsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> 
> This patch prepares the PMU code for the future:
> - suspend/resume (S2R) support
> - cpuidle AFTR/W-AFTR modes support
> on Exynos3250.
> 
> Cc: Vikas Sajjan <vikas.sajjan@samsung.com>
> Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> v5:
> - added Reviewed-by tag from Pankaj Dubey
> - fixed form -> from typo
> 
> v4:
> - rebased on top of next-20141114 branch of linux-next kernel tree
>   (it also applies fine to for-next branch of linux-samsung.git)
> - removed writing to undocumented CORE2 and CORE3 related registers
> - fixed values used for EXYNOS3_[G3D,LCD]_SYS_PWR_REG registers
> - added defines for values used for EXYNOS3_*_DURATION registers
> - removed redundat pr_info("EXYNOS3250 PMU Initialize\n")
> 
> v3:
> - rebased on top of for-next branch of linux-samsung.git and
>   [PATCH v7] mfd: syscon: Decouple syscon interface from platform devices
>   (https://lkml.org/lkml/2014/9/30/156)
>   [PATCH v9 0/2] ARM: Exynos: Convert PMU implementation into a platform driver
>   (https://lkml.org/lkml/2014/10/6/89)
>   [PATCH v9 0/2] Adds PMU and S2R support for exynos5420
>   (http://www.spinics.net/lists/arm-kernel/msg368207.html)
> 
> v2:
> - rebased on top of next-20140708 and
>   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32410.html
>   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33660.html
>   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33675.html
> 
>   this patch also applies fine after/before Exynos5800 PMU support:
>   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33835.html
> 
>  arch/arm/mach-exynos/pmu.c      | 167 ++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-exynos/regs-pmu.h | 128 ++++++++++++++++++++++++++++++
>  2 files changed, 295 insertions(+)

Looks good to me, I think each SoC specific pm features would be handled in
each file like cpufreq though...maybe next time? :-)

BTW, I need to sort out pmu related changes from Pankaj, Amit and you. If
anything is required, I'll let you know.

Thanks,
Kukjin

