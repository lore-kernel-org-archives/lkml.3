Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3IXPGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:06:46 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61589 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3IXPGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:06:44 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-fe-5241aa828388
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: linus.walleij@linaro.org, thomas.abraham@linaro.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] pinctrl: Correct number of pins for s5pv210
Date: Tue, 24 Sep 2013 17:06:31 +0200
Message-id: <2660734.r2Dp8L0F5K@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1380035051-24526-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380035051-24526-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xy7pNqxyDDBa9MrboXXCVzeJs0xt2
	iyl/ljNZbHp8jdXi8q45bBYzzu9jsji95hSzxbEZSxgdODzuXNvD5rF5Sb3HwXd7mDz6tqxi
	9Pi8SS6ANYrLJiU1J7MstUjfLoErY8vtp8wFq1kqenZfYGtgPMXcxcjJISFgItE9dz0LhC0m
	ceHeejYQW0hgKaPEnVM5XYxcQHYXk8SCI1fAGtgE1CQ+NzwCKxIRMJV4d/caG0gRs8ATRok3
	d14BORwcwgIOEo9PWoDUsAioSqx88o8dxOYV0JQ493MqI4jNL6Au8W7bUyYQW1TAVeLTwo3s
	IK2cAv4Sc7aKg5hCAn4SW+4bQHQKSvyYfA/sTGYBeYl9+6eyQthaEut3HmeawCg4C0nZLCRl
	s5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREgFfdjAuPmZ1iFGAg1GJh/digkOQ
	EGtiWXFl7iFGCQ5mJRFezVrHICHelMTKqtSi/Pii0pzU4kOMTBycUg2M0juN8mx/7Y7d7fhE
	RPz9E58tOtJt220b9m3snffi5vxMN/UJ3nPqL5rvDu0K+Viae4zP5WPHmiWrW82lPlgvmJdx
	q/gZw4mEtAfZ/30ZA89sFGKbeSndYBXT7cM1F/ZYGJS1rM1dI/OXoazH2bQnzeJN8Kmp9pN2
	yh6Zs02f3+6Rvt31WFsFJZbijERDLeai4kQAm8jfPl4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Tuesday 24 of September 2013 16:35:07 Mateusz Krawczuk wrote:
> Values of pins in table s5pv210 bank are incorrect. This patch correct values.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/pinctrl/pinctrl-exynos.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Acked-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

P.S. Please be more careful next time when defining things like this.

