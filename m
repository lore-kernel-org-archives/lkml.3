Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3IKBAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:00:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9725 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3IKBAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:00:51 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-f7-522fc0c2e930
From: Jingoo Han <jg1.han@samsung.com>
To: "'Michael Opdenacker'" <michael.opdenacker@free-electrons.com>
Cc: davem@davemloft.net, emilio@elopez.com.ar, mugunthanvnm@ti.com,
        hsweeten@visionengravers.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1378531257-5446-1-git-send-email-michael.opdenacker@free-electrons.com>
In-reply-to: <1378531257-5446-1-git-send-email-michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] net: korina: remove deprecated IRQF_DISABLED
Date: Wed, 11 Sep 2013 10:00:49 +0900
Message-id: <003001ceae8a$5b0ad700$11208500$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6rigzd6hkl1y62RPawu6ebhvjYMwDAAzyg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zfd1DB/SDDHa/Ybd4eUjTYs75FhaL
	Zxu+sFjMnfOd3eLyrjlsFg8mrGKzuPqg3OLYAjEHDo8tK28yefx55+7xZNNFRo++LasYPY7f
	2M7k8XmTnMfzMz/YAtijuGxSUnMyy1KL9O0SuDIu3mpkL/jOXNH56zdjA+N05i5GTg4JAROJ
	6X+XsEDYYhIX7q1n62Lk4hASWMYosfl/MztM0fb/XawQiUWMEod7X0BV/WKUmH7tDytIFZuA
	msSXL4eBOjg4RAQcJP5/MAGpYRaYxSjRevgU2DohgTCJPVuvs4LUcAqES/zaALZAWMBR4syf
	DjCbRUBVYuGSRWA2r4CtxOfft1ghbEGJH5PvgV3KLKAlsX7ncSYIW15i85q3zCAjJQTUJR79
	1QUJiwgYSfz88QeqRERi34t3jCDnSAj8ZZdoXP2bEWKXgMS3yYdYIHplJTYdgAaKpMTBFTdY
	JjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCEx3b+D8e4B
	60OMyUDrJzJLiSbnA1NCXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoYtzcVds4XuRA95ULwEnG5BpPexgC5w2qLJllsNHRbW/BHy8/pMqO4dHa+
	XPve61byB/J7bb4xtaxQmlo9Y4o+u8fVi7NjD11vcwzO2Nyb481ab/68x+BylNgm9XXZW5gv
	Xr/wzvTt508u0589vhqWVx2x6Cr3tC2GqxfzGQf9veIa8lv/roebEktxRqKhFnNRcSIAdqjm
	6/8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAd1DB/SDDI5eZbZ4eUjTYs75FhaL
	Zxu+sFjMnfOd3eLyrjlsFg8mrGKzuPqg3OLYAjEHDo8tK28yefx55+7xZNNFRo++LasYPY7f
	2M7k8XmTnMfzMz/YAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJz
	U22VXHwCdN0yc4BOUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmXLzV
	yF7wnbmi89dvxgbG6cxdjJwcEgImEtv/d7FC2GISF+6tZ+ti5OIQEljEKHG49wWU84tRYvq1
	P2BVbAJqEl++HGbvYuTgEBFwkPj/wQSkhllgFqNE6+FTYFOFBMIk9my9zgpSwykQLvFrAztI
	WFjAUeLMnw4wm0VAVWLhkkVgNq+ArcTn37dYIWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsM
	MlJCQF3i0V9dkLCIgJHEzx9/oEpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBCeMZ1I7GFc2WBxiFOBgVOLhvSGnHyTEmlhWXJl7iFGCg1lJ
	hHeqE1CINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84HJLK8k3tDYxMzI0sjMwsjE3Jw0YSVx
	3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGOVvxys5693cNn9Suk1R5bv/t1S7t76ba57Lwbbk
	958HN856i+99xt5yS9B603QvlbDvTf9zHkxdujzg/NGukqzJXJwz2+bGOHaqnddkdeN4xfdO
	hF3k1LJfGXqeTyzsrp9QDFqiwRlmx+4kZeBWLWvk++JIktf379bP+23aZm6fHNN0+NXrT0os
	xRmJhlrMRcWJAPfDkIFcAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 07, 2013 2:21 PM, Michael Opdenacker wrote:
> 
> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/korina.c
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/net/ethernet/korina.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

