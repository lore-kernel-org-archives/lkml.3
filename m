Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3L3Rvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 12:51:32 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22750 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3L3Rva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:51:30 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-12-52c1b2a05d4e
From: Tomasz Figa <t.figa@samsung.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stephen Warren <swarren@nvidia.com>,
        James Hogan <james.hogan@imgtec.com>,
        Padmavathi Venna <padma.v@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: exynos: File scope reg_save array should depend on
 PM_SLEEP
Date: Mon, 30 Dec 2013 18:51:06 +0100
Message-id: <24377867.Lxp9m9lerI@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <20131219075510.18119.67210@quantum>
References: <1387274199-470-1-git-send-email-k.kozlowski@samsung.com>
 <20131219075510.18119.67210@quantum>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=utf-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xK7oLNh0MMlj4SMvi3bwXzBavXxha
	9C64ymax6fE1VovLu+awWcw4v4/J4umEi2wWv29+Z7M4+aeX0eLHmW4WixvTW1gduD0u9/Uy
	efTsPMPocefaHjaPzUvqPXqb37F59G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV8bcCceZC16y
	VNzYs4G1gbGFpYuRg0NCwETiwnfGLkZOIFNM4sK99WxdjFwcQgJLGSVuTP3NDpIQEuhiktjQ
	xg1iswmoSXxueMQGYosIaElsO9AK1sAs0MYsMWn7cWaQhLBAuMS7v41gRSwCqhITPz8Hs3mB
	GhY1Xwez+QXUJd5te8oEYosKuEm82LcFbBmngKFE5+X/jBCLcyQap96D6hWU+DH5HguIzSyg
	LfHk3QVWkAeYgeZMmZI7gVFwFpKqWUiqZiFULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yf
	u4kREjFfdjAuPmZ1iFGAg1GJhzfgxoEgIdbEsuLK3EOMEhzMSiK8LTUHg4R4UxIrq1KL8uOL
	SnNSiw8xMnFwSjUw9nRm/xbT9tt1s2phzfzGm9f/X3jX57z0jRlfnYDXw7lFlnN6s7WKdpy/
	cYGh/91pFmbnSzLXa/g6jprw335j0yWhfGN5qfTd164zDFaffSHydZLEeTvX89tb5skvbLHZ
	XLAhTz/Mc+FPidwNxbdmMSQfuzHTO74lol9l2d4r73n6XLi0f2+7q8RSnJFoqMVcVJwIADg1
	Uph2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 of December 2013 23:55:10 Mike Turquette wrote:
> Quoting Krzysztof Kozlowski (2013-12-17 01:56:39)
> > Move reg_save[] into CONFIG_PM_SLEEP dependency block as it is used only
> > by suspend and resume functions.
> > 
> > This fixes the warning on CONFIG_PM_SLEEP=n:
> > drivers/clk/samsung/clk-exynos-audss.c:29:22: warning: ‘reg_save’ defined but not used [-Wunused-variable]
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>

Applied onto fixes branch.

Best regards,
Tomasz

