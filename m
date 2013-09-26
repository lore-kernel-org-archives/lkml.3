Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab3IZFoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:44:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57203 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3IZFoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:44:14 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-6f-5243c9ac0bbf
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mateusz Krawczuk'" <m.krawczuk@partner.samsung.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com, t.figa@samsung.com, m.szyprowski@samsung.com,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1380043160-16824-1-git-send-email-m.krawczuk@partner.samsung.com>
In-reply-to: <1380043160-16824-1-git-send-email-m.krawczuk@partner.samsung.com>
Subject: RE: [RFC] clk: samsung:  Remove old clock drivers for s5pc100 and
 s5pv210
Date: Thu, 26 Sep 2013 14:44:12 +0900
Message-id: <02f401ceba7b$6dc16e20$49444a60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65Sj/VUdQa9U/sQhinydiFkQXLVABL2DDg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zA901J52DDP4v1rbYOGM9q8XZpjfs
	FpseX2O1uLxrDpvFjPP7mCxuX+a1OL3mFLPF2iN32S3Wz3jN4sDp0dLcw+axeUm9x8F3e5g8
	+rasYvT4vEkugDWKyyYlNSezLLVI3y6BK+Nl1xXGgttcFW8nrWFvYHzI0cXIySEhYCJxqXMG
	C4QtJnHh3nq2LkYuDiGBZYwSp1o7mWCKZt7bxg6RmM4ocX7WFUYI5y9Q1dvnzCBVbAIaEoff
	P2MHsUUEzCVuXtoANopZ4A+jxOMJ3WAJIQE/icUrGtlAbE4Bf4lZO96DrRAWCJHYdPsG2B0s
	AqoS52fPARvKK2Ar8fxCByOELSjxY/I9sBpmAS2J9TuPM0HY8hKb17wFqucAOlVd4tFfXYgb
	jCSOTP4HVS4ise/FO7CjJQR+skscOLyWHWKXgMS3yYdYIHplJTYdYIb4WFLi4IobLBMYJWYh
	2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQiJ6wg/HeAetDjMlA
	6ycyS4km5wMTQl5JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGDUq/R+skEoUDzlclOH2jL+8+/iUpSpFU9UPbps0a/pm59XZPJPY/zaqzDrBpi5l
	bRLa2eaudMNFepdmwln98Kxfdupec+UfXbsgfuEYzxpHm+Syhjtx7pcclgtnZK4J2r72dUhb
	s/7xv8dOLViRPUP9da5L21lx1wfLNDKvqOxun22W7nLATImlOCPRUIu5qDgRAGtMSuD+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jQd01J52DDK79VrPYOGM9q8XZpjfs
	FpseX2O1uLxrDpvFjPP7mCxuX+a1OL3mFLPF2iN32S3Wz3jN4sDp0dLcw+axeUm9x8F3e5g8
	+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGy64rjAW3
	uSreTlrD3sD4kKOLkZNDQsBEYua9bewQtpjEhXvr2boYuTiEBKYzSpyfdYURwvnLKHHq7XNm
	kCo2AQ2Jw++fgXWICJhL3Ly0AayDWeAPo8TjCd1gCSEBP4nFKxrZQGxOAX+JWTveM4HYwgIh
	Eptu32ABsVkEVCXOz54DNpRXwFbi+YUORghbUOLH5HtgNcwCWhLrdx5ngrDlJTaveQtUzwF0
	qrrEo7+6EDcYSRyZ/A+qXERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZwungmvYNxVYPFIUYBDkYlHt4LzM5BQqyJZcWVuYcYJTiYlUR4vxkB
	hXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmMrySuINjU3MjCyNzCyMTMzNSRNWEuc92God
	KCSQnliSmp2aWpBaBLOFiYNTqoHR5bTSTZNl5dpNK8Raek95fFqo3Llb9/zH9Zxv0yy3v7pR
	blRguvyKfL9Qwqnoe0onphxfvPulz4H+9aefceWrtSWqTogUf5SvuOJIaUWazAonIYsyph9Z
	UxpPF0zb3XG/7uf9oEUnvpd7X+VOvdidOu8N+97ykMMeDg3/lNtzpkxU02RLyHiuxFKckWio
	xVxUnAgABuu9t1sDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mateusz Krawczuk wrote:
> 
> This patch removes old clock management code for S5PC100 and
> S5PC110/S5PV210,
> since the platform has been already moved to the new clock driver
> using Common Clock Framework.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> This patch series require
> S5PC100 and S5PV210 patch series moving to common clock framework.
> 
>  arch/arm/mach-s5pc100/Kconfig  |    2 +-
>  arch/arm/mach-s5pc100/Makefile |    1 -
>  arch/arm/mach-s5pc100/clock.c  | 1361 -----------------------------------
> ----
>  arch/arm/mach-s5pv210/Kconfig  |    2 +-
>  arch/arm/mach-s5pv210/Makefile |    1 -
>  arch/arm/mach-s5pv210/clock.c  | 1365 -----------------------------------
> -----
>  6 files changed, 2 insertions(+), 2730 deletions(-)
>  delete mode 100644 arch/arm/mach-s5pc100/clock.c
>  delete mode 100644 arch/arm/mach-s5pv210/clock.c
> 
In this case, would be easier to review with using "-D" for format-patch.

And this should be followed by moving common clk series for s5pc100/s5pv210.
See s3c64xx common clk patches in v3.13-next/common-clk-s3c64xx branch as a
reference.

And I have never seen common clk stuff for s5pc100. In addition, I'm not
sure we _still_ need to support s5pc100 in mainline.

Thanks,
- Kukjin

