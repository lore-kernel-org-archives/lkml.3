Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaETA2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:28:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34115 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaETA2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:28:04 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-d2-537aa192b346
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>
References: <20140519125124.6504764d@canb.auug.org.au>
 <1911725.FzcK6v311f@vostro.rjw.lan>
In-reply-to: <1911725.FzcK6v311f@vostro.rjw.lan>
Subject: RE: linux-next: manual merge of the pm tree with the samsung tree
Date: Tue, 20 May 2014 09:27:58 +0900
Message-id: <013b01cf73c2$5bbe1fb0$133a5f10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIIb85tTBjRSQiHf0XUouzoyVElVAHpY+vKmsdZlLA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zA91JC6uCDXY3y1tc//Kc1WJJM7fF
	5V1z2CwOLmxjtDhz+hKrxda9V9kd2Dwab9xg89hytZ3Fo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDKu7z3LVDCFveLWrrmMDYy3WLsYOTkkBEwknkz6xQ5hi0lcuLeerYuRi0NIYBmjxMk5
	P5hhilZe+ssMkVjEKDH7UR8LhPOXUeLEzSawUWwCGhKH3z8DGyUiECXR0rMNrINZYDKjRMPp
	BYwgCSGBGIlbVxczgdicAgYS//7sYgOxhQW8JL6ubQMbxCKgKrHkxhEwm1fAUmLdtavMELag
	xI/J91hAbGYBdYlJ8xYxQ9jyEpvXvIU6VUFix9nXjBBHWEm8eziLEaJGRGLfi3eMIAdJCNxj
	l5j8fwUzxDIBiW+TDwEN5QBKyEpsOgA1R1Li4IobLBMYJWYhWT0LyepZSFbPQrJiASPLKkbR
	1ILkguKk9CJDveLE3OLSvHS95PzcTYyQaO3dwXj7gPUhxmSg9ROZpUST84HRnlcSb2hsZmRh
	amJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjHpRQuGXn639yOXw
	bremAG+UZDObRfSHwx8sSjjVOzrmH3h64X5fk+vZ0Kzg2wy1XHOtj0vv7Jgud6SjNM6G9WWs
	Yr3ZJdf1+psMP2RXyjJMUdmjvieTReeakdyG9fxH0munChwwXi17bIU5m+P7v8suTd7GWLDi
	TaNOl0TxCUbFXT0JKv+NlFiKMxINtZiLihMBlkCPzuwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAd1JC6uCDZo/Sllc//Kc1WJJM7fF
	5V1z2CwOLmxjtDhz+hKrxda9V9kd2Dwab9xg89hytZ3Fo2/LKkaPz5vkAliiGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CWKymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzru89y1Qwhb3i1q65jA2Mt1i7GDk5JARMJFZe
	+ssMYYtJXLi3nq2LkYtDSGARo8TsR30sEM5fRokTN5vAOtgENCQOv3/GDmKLCERJtPRsYwYp
	YhaYzCjRcHoBI0hCSCBG4tbVxUwgNqeAgcS/P7vYQGxhAS+Jr2vbwAaxCKhKLLlxBMzmFbCU
	WHftKjOELSjxY/I9FhCbWUBdYtK8RcwQtrzE5jVvoU5VkNhx9jUjxBFWEu8ezmKEqBGR2Pfi
	HeMERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnAqeSe9g
	XNVgcYhRgINRiYf3gHhVsBBrYllxZe4hRgkOZiUR3p2pQCHelMTKqtSi/Pii0pzU4kOMyUCf
	TmSWEk3OB6apvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg
	1F/MaDN9snphuNkh6ZMF+zsPPDidxvYpfs2zD5q7C6fu/BqncXVv+ubrnZHbQ2qb+aYfWrPr
	4qZE2XBeWW4RuaR+23qGd/O2P/izZF/rtKmfZ1/L+edc+lv4oq/Ne3a/PVKeW/pf74ietzGJ
	83O+1+mHu1qfOxkX+d9uW72gf+2O696vtabKJCixFGckGmoxFxUnAgCcvaPLSQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> On Monday, May 19, 2014 12:51:24 PM Stephen Rothwell wrote:
> >
> > --Sig_/n+GoYBpTr9ERl.sTIEYr/Og
> > Content-Type: text/plain; charset=US-ASCII
> > Content-Transfer-Encoding: quoted-printable
> >
> > Hi Rafael,
> >
> > Today's linux-next merge of the pm tree got conflicts in
> > drivers/cpufreq/exynos-cpufreq.c and drivers/cpufreq/exynos-cpufreq.h
> > between commit 2b07f4085479 ("cpufreq: exynos: Fix the compile error")
> > from the samsung tree and commit e5eaa445b0dc ("cpufreq: exynos: Use
> > dev_err/info function instead of pr_err/info") from the pm tree.
> >
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> 
> Thanks for fixing that Stephen!
> 
Same here ;-)

> Kukjin, are you going to handle all Exynos cpufreq commits in the future?
> 
If you're OK, would be better to us I think.

- Kukjin

