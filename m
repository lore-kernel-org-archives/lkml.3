Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbaFTCgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 22:36:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46321 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbaFTCgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 22:36:07 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-1d-53a39e138d4e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wolfram Sang'" <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
In-reply-to: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
Subject: Re: [PATCH 0/3] Remove devm_request_and_ioremap()
Date: Fri, 20 Jun 2014 11:36:03 +0900
Message-id: <000c01cf8c30$613759d0$23a60d70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+MKFKiWnMIy0wJTm2a17geQQp8BwAB10yg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zY13heYuDDU7M17e48vU9m0Xz4vVs
	FpcXXmK1WNi2hMXi8q45bBYrT8xidmDz2D93DbvH/e7jTB59W1Yxepw89YTF4/MmuQDWKC6b
	lNSczLLUIn27BK6MiR09LAXfOSvWLvdqYDzJ3sXIySEhYCLxZv1HRghbTOLCvfVsILaQwDJG
	ibUXZGBqfjyazgoRX8QocainoIuRC8j+zSgxa/FXsGY2ATWJL18Ogw0VEXCR2Pj/FhtIEbPA
	TEaJGd2NzBDdDhIb32wC28Ap4Chx9/B5MFtYwEpi05E/YDaLgKpE7+b1YEN5BWwlJi3/xwJh
	C0r8mHwPzGYW0JJYv/M4E4QtL7F5zVug+RxAl6pLPPqrC3GDkcTds/PYIEpEJPa9eMcIco+E
	wD12ibWPdrFD7BKQ+Db5EAtEr6zEpgPMEA9LShxccYNlAtB7SDbPQrJ5FpLNs5CsWMDIsopR
	NLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJGIn7mC8f8D6EGMy0PqJzFKiyfnAiM8riTc0NjOy
	MDUxNTYytzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZ9u3Jdc1ZOn7V6
	Rpvx1fIZlyW5n6Qf3Jn4Re7sH6au2K28l0027FrC+Ez8Xt0c5ceNkX4Bj/n77M+5JE6INpu1
	aro886dkFgF3x8z5PSr+3AYf+q69fHnzeuXys9nfowQvz38S23HbICN/070uN/nPSa9car3t
	qx9U+1zjfXX3fNOV+3Y3I04psRRnJBpqMRcVJwIAqrIxV+4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAV3heYuDDe72a1tc+fqezaJ58Xo2
	i8sLL7FaLGxbwmJxedccNouVJ2YxO7B57J+7ht3jfvdxJo++LasYPU6eesLi8XmTXABrVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjIkdPSwF3zkr1i73amA8yd7FyMkh
	IWAi8ePRdFYIW0ziwr31bCC2kMAiRolDPQVdjFxA9m9GiVmLvzKCJNgE1CS+fDkM1iwi4CKx
	8f8tNpAiZoGZjBIzuhuZIbodJDa+2QQ2iVPAUeLu4fNgtrCAlcSmI3/AbBYBVYnezevBhvIK
	2EpMWv6PBcIWlPgx+R6YzSygJbF+53EmCFteYvOat0DzOYAuVZd49FcX4gYjibtn57FBlIhI
	7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITgjP
	pHcwrmqwOMQowMGoxMPbYbo4WIg1say4MvcQowQHs5IIL9s0oBBvSmJlVWpRfnxRaU5q8SHG
	ZKBHJzJLiSbnA5NVXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFw
	SjUAU9y8HEPX2wx/IhYG/MnrC9o7UW+d59Zl9ziNq3MLvvOWtFut57h9buL1hOLH+7YbX0/1
	Nl/wckJ2za2lUttF1RnncUdK5z364e3E+Fz+PI+MvMRj1vMaPrM41ua89VT/cp/zD7v+qj17
	VFeypU35kPL/VH7Mb23rA6qv9zp9TnvAcvhOsOwtJZbijERDLeai4kQAZD+8jUwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 20, 2014 3:49 AM, Wolfram Sang wrote:
> 
> Pretty much a year ago, Tushar cleaned up a lot of deprecated uses of
> devm_request_and_ioremap, yet some remains are still left. Remove the last two
> users, and let the function rest in peace. I'd suggest that this series is
> picked up as a whole to have that case finally closed. Greg? Are you interested
> in picking it up?

(+cc Greg Kroah-Hartman)

I already sent the same patch as one single patch to Greg Kroah-Hartman. [1]
Also, it was accepted by Greg Kroah-Hartman. [2] Thank you.

[1] https://lkml.org/lkml/2014/6/11/26
[2] https://lkml.org/lkml/2014/6/11/649

Best regards,
Jingoo Han

> 
>    Wolfram
> 
> 
> Tushar Behera (2):
>   DRM: Armada: Use devm_ioremap_resource
>   lib: devres: Remove deprecated devm_request_and_ioremap
> 
> Wolfram Sang (1):
>   bus: brcmstb_gisb: Use devm_ioremap_resource
> 
>  Documentation/driver-model/devres.txt |  1 -
>  drivers/bus/brcmstb_gisb.c            |  6 +++---
>  drivers/gpu/drm/armada/armada_crtc.c  |  8 +++-----
>  include/linux/device.h                |  2 --
>  lib/devres.c                          | 28 ----------------------------
>  5 files changed, 6 insertions(+), 39 deletions(-)
> 
> --
> 2.0.0

