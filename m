Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab3CGD0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:26:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12491 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3CGD0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:26:31 -0500
X-AuditID: cbfee690-b7f6b6d000004563-bc-513808e6b955
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linus.walleij@linaro.org,
        t.figa@samsung.com, patches@linaro.org
References: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
 <014101ce1ac8$5a4e8600$0eeb9200$%kim@samsung.com>
 <CAJuYYwS9+ZV43QaweUmqh_qFffT1fytM7G9WVbVWdi=hFjvpaw@mail.gmail.com>
In-reply-to: <CAJuYYwS9+ZV43QaweUmqh_qFffT1fytM7G9WVbVWdi=hFjvpaw@mail.gmail.com>
Subject: RE: [PATCH v2 0/3] pinctrl: exynos: add support for Samsung's
 Exynos5250
Date: Thu, 07 Mar 2013 12:26:29 +0900
Message-id: <017b01ce1ae3$8f0486e0$ad0d94a0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4a4wtPPp4qOoxxSMmPjaylP0Pc2gAAFAZQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zY91nHBaBBh1LuSym/FnOZLHp8TVW
	i8u75rBZzDi/j8liyuEvLBbrZ7xmsTg2YwmjA7vHnWt72Dw2L6n36NuyitHj8ya5AJYoLpuU
	1JzMstQifbsEroxd660LtrNVbP91iK2BsZu1i5GTQ0LAROLPk53sELaYxIV769m6GLk4hASW
	MUpMb9zO0sXIAVbU1xwFEZ/OKLFnwTVGCOcvo8TEW33MIN1sAhoSh98/A5skImAgseLwDiaQ
	ImaB9YwSf5vuskN0HGGUuHTjORtIFadAsMTPGefBuoWB7EU7LoJ1swioSixffRzsPl4BW4mf
	846xQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhniVHWJR391IY4wknh79TQjRImIxL4X78Cu
	lhB4yS6x8tpiVohdAhLfJh+CelNWYtMBZkhQSEocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZ
	xSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iRESsxN2MN47YH2IMRlo/URmKdHkfGDM55XEGxob
	m5iZmJqYW5qam5ImrCTOK39JJlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDI9O1p6fP8AvF
	MHjfkPtUeDP7dklB6ZZpVreztZQY8kwOZins/vrYPenHiSmtoqI7k97tTra947TqhGB6x6nw
	00Yv95v/Of/VIyvbcvdiFakbmtpC06+fXDw3xaSvSLZju5Z33dKCC5s2rdTdVPDAVKbbz/Fa
	kIup9eK/O5U2Xu+VPet9h1G8WYmlOCPRUIu5qDgRAInZoNXvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQd1nHBaBBg8OsFpM+bOcyWLT42us
	Fpd3zWGzmHF+H5PFlMNfWCzWz3jNYnFsxhJGB3aPO9f2sHlsXlLv0bdlFaPH501yASxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzdq23LtjOVrH91yG2BsZu1i5GDg4J
	AROJvuaoLkZOIFNM4sK99WxdjFwcQgLTGSX2LLjGCOH8ZZSYeKuPGaSKTUBD4vD7Z+wgtoiA
	gcSKwzuYQIqYBdYzSvxtussO0XGEUeLSjedsIFWcAsESP2ecB+sWBrIX7bgI1s0ioCqxfPVx
	VhCbV8BW4ue8YywQtqDEj8n3wGxmAS2J9TuPM0HY8hKb17xlhjhbXeLRX12II4wk3l49zQhR
	IiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4
	ITyT2sG4ssHiEKMAB6MSDy9HvnmgEGtiWXFl7iFGCQ5mJRHeMHaLQCHelMTKqtSi/Pii0pzU
	4kOMyUCPTmSWEk3OByarvJJ4Q2MTMyNLIzMLIxNzc9KElcR5GU89CRASSE8sSc1OTS1ILYLZ
	wsTBKdXAeIRjqvvGhSJXX3L/tO84c/POStPlJ9dH1Mxdqbzp/IW3X0K2M6c1zlUXfjYrZR+X
	wwxDhW33VGfu3pjB+2XPk4mi0ulh22x6eu5NWxe+JtgqfpZL5Lm4XdlhH/I3aBS+fvTqUtGd
	DIcTl7RDtcUClnc9uXHd91/r5fbsJ/uXnTjX7fbQXStddo4SS3FGoqEWc1FxIgA6VpLTTAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> 
> On 7 March 2013 05:41, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Thomas Abraham wrote:
> >>
> >> Changes since v1:
> >> - Change the compatible string from "samsung,pinctrl-exynos5250" to
> >>   "samsung,exynos5250-pinctrl".
> >> - Rebased to v3.9-rc1
> >>
> >
> > Thomas, this stuff is already in my tree for v3.10, and above changes
> > included in there. Do you want to replace with this patches?
> 
> Dear Mr. Kim,
> 
> The v2 version includes one fix for the compatilble string. It changes
> the compatible string from "samsung,pinctrl-exynos5250" to
> "samsung,exynos5250-pinctrl". So could you pick this v2 series instead
> of the series which you have already merged.
> 

Hey, probably, you didn't check my tree. As I said, already changed/fixed.

- Kukjin

