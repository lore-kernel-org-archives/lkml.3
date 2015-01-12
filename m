Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbbALIvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:51:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19640 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbbALIvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:51:51 -0500
X-AuditID: cbfee68e-f79b46d000002b74-d3-54b38b24abf6
Message-id: <54B38B24.20804@samsung.com>
Date: Mon, 12 Jan 2015 17:51:48 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kukjin Kim <kgene@kernel.org>
Cc: ben-linux@fluff.org, kyungmin.park@samsung.com, inki.dae@samsung.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH] ARM: EXYNOS: Add exynos3250 suspend-to-ram support
References: <1420681838-4292-1-git-send-email-cw00.choi@samsung.com>
 <54B38989.4030700@kernel.org>
In-reply-to: <54B38989.4030700@kernel.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkQFele3OIwYkpxhYbZ6xntZi07gCT
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzWLG+X1MDpwef1e9YPbYtKqTzWPzknqP
	vi2rGD0+b5ILYI3isklJzcksSy3St0vgyphy5SNbwUK2ii3HJjE2MDaxdjFyckgImEhc3nSK
	DcIWk7hwbz2QzcUhJLCUUeLekha4og8v/jBDJKYzSlz6e4IdwnnNKDF59yImkCpeAQ2Jicf/
	g41iEVCVOLH0DiOIzSagJbH/xQ2wuKhAmMTK6VdYIOoFJX5Mvgdkc3CICChKbF6gADKTWeAF
	o8TzN+eYQWqEBfwkHl57AGYLCaRILFs1G2wOJ9DMt+v/gM1hFtCR2N86jQ3ClpfYvOYt2KUS
	ArfYJRZfnwN1kIDEt8mHwJZJCMhKbDrADPGZpMTBFTdYJjCKzUJy0iwkY2chGbuAkXkVo2hq
	QXJBcVJ6kZFecWJucWleul5yfu4mRmAknv73rG8H480D1ocYBTgYlXh4LaQ2hwixJpYVV+Ye
	YjQFumIis5Rocj4w3vNK4g2NzYwsTE1MjY3MLc2UxHkTpH4GCwmkJ5akZqemFqQWxReV5qQW
	H2Jk4uCUamCcz3HctZDxjufP1EmzDJn3TDYWTFE4WnB/oW6esouFxxfV8nmbqvP23jb91sWz
	61pugczN97vcZyuF92t3r5dmOH2VRYHl2p0CH5bvDf58H/5beJglTTK/5Rs981fOh/oDW3oz
	/GMalyzxv3+opLboe7HtmltnJm47c/pLxYUgZrXC+k22N28rsRRnJBpqMRcVJwIA1Vk9FL8C	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jQV2V7s0hBjP2aVtsnLGe1WLSugNM
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNosZ5/cxOXB6/F31gtlj06pONo/NS+o9
	+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGlCsf2QoW
	slVsOTaJsYGxibWLkZNDQsBE4sOLP8wQtpjEhXvr2boYuTiEBKYzSlz6e4IdwnnNKDF59yIm
	kCpeAQ2Jicf/s4HYLAKqEieW3mEEsdkEtCT2v7gBFhcVCJNYOf0KC0S9oMSPyfeAbA4OEQFF
	ic0LFEBmMgu8YJR4/uYc2GZhAT+Jh9cegNlCAikSy1bNBpvDCTTz7fo/YHOYBXQk9rdOY4Ow
	5SU2r3nLPIFRYBaSFbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCcP5Pe
	wbiqweIQowAHoxIPr4XU5hAh1sSy4srcQ4wSHMxKIryuZUAh3pTEyqrUovz4otKc1OJDjKbA
	EJjILCWanA9MQXkl8YbGJmZGlkbmhhZGxuZK4rxK9m0hQgLpiSWp2ampBalFMH1MHJxSDYxe
	H4/03P8vGJW2ZSuL+vGO82wn0g7w62WGqB4SnW97X8KxKjwiuCXa9bzAhAOFDJ9eO6x6I7fI
	6+axP0EPW8zcqgw9FvY+m8NoEb9/d7HpheoK8z1LT0w5onV9QzmvyRH1pzbxPz0+Pddf43FC
	Ur8x1PTEk3MJv9jCV6avtnjWdlPhjvqXHT1KLMUZiYZazEXFiQCYxdFZCQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

On 01/12/2015 05:44 PM, Kukjin Kim wrote:
> On 01/08/15 10:50, Chanwoo Choi wrote:
>> This patch adds the support for suspend-to-ram feature of Exynos3250 SoC.
>> Exynos3250 don't contain the L2 cache.
>>
>> Cc: Kukjin Kim <kgene@kernel.org>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> Depend on:
>> - v3.19-rc3
>>
> Chanwoo,
> 
> Can you please let me know why this is depending on v3.19-rc3?
> If I apply this on top of my tree not including some stuff between
> v3.19-rc1 and v3.19-rc3, is there a problem?

No problem.
I'm sorry. It is my mistake about using meaning of dependency.
This patch can be applied on v3.19-rc1. I just tested it on v3.19-rc3.

Best Regards,
Chanwoo Choi
