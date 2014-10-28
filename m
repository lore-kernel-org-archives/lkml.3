Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaJ1E2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:28:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31352 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaJ1E23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:28:29 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-8f-544f1b66e577
From: Kukjin Kim <kgene@kernel.org>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Kukjin Kim'" <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        yj44.cho@samsung.com, jaewon02.kim@samsung.com, ideal.song@samsung.com
References: <1414373759-4362-1-git-send-email-cw00.choi@samsung.com>
 <1414373759-4362-2-git-send-email-cw00.choi@samsung.com>
 <02b501cff262$127d44b0$3777ce10$@kernel.org> <544F15F0.9080102@samsung.com>
In-reply-to: <544F15F0.9080102@samsung.com>
Subject: RE: [PATCHv2 1/2] ARM: EXYNOS: Add EXYNOS4415 SoC ID
Date: Tue, 28 Oct 2014 13:28:22 +0900
Message-id: <031101cff267$9b8daba0$d2a902e0$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI8RNIEvKbq0iSBkCqwA7nWAb+6GAE/eoRUAvluUTYBxGmU+5s8Wkww
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+ZoW6atH+IwaT9MhZ/Jx1jt7j+5Tmr
	xa6/9xktJt2fwGKxo+EIq0X/49fMFmeb3rBbbHp8jdXi8q45bBYzzu9jslh75C67xdLrF5ks
	Tl3/DBSb/JLNYtWuP4wWe3dOZnQQ8Fgzbw2jx+9fkxg9ds66y+6xaVUnm8fmJfUeV040sXr0
	bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXRk/Tc9aCE+wVnzfeYWxg7GPrYuTkkBAwkbg5rYkR
	whaTuHBvPVhcSGAZo8T7powuRg6wmuVHRboYuYDCixgl/i97ww7h/GWUWPj6IBtIEZuAskRj
	kz5Ir7CAlsTCLU0sILaIgLfEnP83WUDqmQVeMElcXv8Wqvkso8Ty94/BtnEKaEv8f7iWEaLb
	VuLVq8XMIDaLgKrE1YOz2EFsXgELic2nXrNB2IISPybfA9vADLRt/c7jTBC2vMTmNW+ZIb5R
	kNhx9jUjxBVuEsfvdLJB1IhI7HvxjhHkCAmBExwS60/MYIdYJiDxbfIhFoiXZSU2HYCaIylx
	cMUNlgmMkrOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZIMpmw
	g/HeAetDjAIcjEo8vAYP/UKEWBPLiitzDzGaAl00kVlKNDkfmLLySuINjc2MLExNTI2NzC3N
	lMR5X0v9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKPP44f9c8d98nJbpRSmz91R+bltl
	U+M28WzHjMqzT1WcDF6XTFV2T7P9/sx7Z7iozodQdsfANO1l1dypm1sWPBdmb4vkc9p90+OE
	8eWXrA5dOdc2Rc85VfBjtd9XuR7T8FQnjvP/Gle3rRZgmnNc5MijIqfmbUWRycZ/hT7NbH2U
	8euWW99CJZbijERDLeai4kQARFINaiEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jAd00af8QgxXd4hZ/Jx1jt7j+5Tmr
	xa6/9xktJt2fwGKxo+EIq0X/49fMFmeb3rBbbHp8jdXi8q45bBYzzu9jslh75C67xdLrF5ks
	Tl3/DBSb/JLNYtWuP4wWe3dOZnQQ8Fgzbw2jx+9fkxg9ds66y+6xaVUnm8fmJfUeV040sXr0
	bVnF6PF5k1wAR1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKL
	T4CuW2YO0AtKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoyepuesBSfY
	Kz5vvMPYwNjH1sXIwSEhYCKx/KhIFyMnkCkmceHeeqAwF4eQwCJGif/L3rBDOH8ZJRa+PgjW
	wCagLNHYpA/SICygJbFwSxMLiC0i4C0x5/9NFpB6ZoEXTBKX17+Faj7LKLH8/WM2kCpOAW2J
	/w/XMkJ020q8erWYGcRmEVCVuHpwFjuIzStgIbH51Gs2CFtQ4sfke2AbmIG2rd95nAnClpfY
	vOYtM8TZChI7zr5mhLjCTeL4nU42iBoRiX0v3jFOYBSehWTULCSjZiEZNQtJywJGllWMoqkF
	yQXFSem5hnrFibnFpXnpesn5uZsYwcnqmdQOxpUNFocYBTgYlXh4DR76hQixJpYVV+YeYpTg
	YFYS4fXaARTiTUmsrEotyo8vKs1JLT7EaAr06URmKdHkfGAizSuJNzQ2MTOyNDKzMDIxN1cS
	5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwBgWfpV/7cKpW9RnbPJeHPh0xf1kjdMarzYXKPSV
	rdCYwfFRnOv6Etb26Mv713/X7f6ozOnTMb250XKGZoFm4uqH+rkvA1q1DVPemdXt4jA7ZC46
	vXfzNMvvK2wV+8+35xYYv9RbtCTmrtu8dCtBW6umcNbqH78b5NINIwWeehqvuth4X0EtWYml
	OCPRUIu5qDgRAMa0IBNsAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo Choi wrote:
> 
> Dear Kukjin,
> 

[...]

> >>
> >> +config SOC_EXYNOS4415
> >> +	bool "SAMSUNG EXYNOS4415"
> >> +	default y
> >> +	depends on ARCH_EXYNOS4
> >> +
> >
> > I think, this is not required more...
> 
> But,
> The clock driver must need to CONFIG_SOC_EXYNOS4415 configuration
> to build it. The clock driver[1] of exynos4415 used CONFIG_SOC_EXYNOS4415 as following diff:
>   [1] https://lkml.org/lkml/2014/10/26/159
> 
Oh, yes. OK.

Thanks for quick reply.

- Kukjin

> diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
> index 8909c93..4561297 100644
> --- a/drivers/clk/samsung/Makefile
> +++ b/drivers/clk/samsung/Makefile
> @@ -5,6 +5,7 @@
>  obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-pll.o clk-cpu.o
>  obj-$(CONFIG_SOC_EXYNOS3250)	+= clk-exynos3250.o
>  obj-$(CONFIG_ARCH_EXYNOS4)	+= clk-exynos4.o
> +obj-$(CONFIG_SOC_EXYNOS4415)	+= clk-exynos4415.o
> 
> Best Regards,
> Chanwoo Choi

