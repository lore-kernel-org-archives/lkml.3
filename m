Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaKRA1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:27:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34131 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaKRA1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:27:05 -0500
X-AuditID: cbfee68e-f79b46d000002b74-69-546a9256f103
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>, lee.jones@linaro.org,
        broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sameo@linux.intel.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-2-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1416184980-532-2-git-send-email-cw00.choi@samsung.com>
Subject: RE: [PATCH 1/5] mfd: sec-core: Add support for S2MPS13 device
Date: Tue, 18 Nov 2014 09:26:50 +0900
Message-id: <011f01d002c6$5f56f960$1e04ec20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBIGxsMOaDFXn+jUEunj34K9G6SgKFGC5tm+8iRaA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsWyRsSkQzdsUlaIwbN7IhZLLl5lt5j68Amb
	xfUvz1kt5h85x2rxZ0Irm8Wk+xNYLM42vWG3uP/1KKPFtysdTBaXd81hs3g64SKbxeluVgce
	j52z7rJ7bFrVyeZx59oeNo95JwM9+rasYvSYPu8nk8fnTXIB7FFcNimpOZllqUX6dglcGZcn
	7GcrWMtU8fTHAdYGxs+MXYycHBICJhLzV55lh7DFJC7cW8/WxcjFISSwlFGi4/Ajdpiif1sX
	sUIkFjFKXL08H6xbSOA3o8SCCzwgNpuAhsTK3W/BukUEmhkldl5/wwLiMAtsY5SY8PcUO0RH
	rcTyjzvYQGxOAReJk//nAdkcHMICbhIL9yaAhFkEVCVuXT3DAhLmFbCUODGrECTMKyAo8WPy
	PRYQm1lAS2L9zuNMELa8xOY1b5khDlWQ2HH2NdhtIgJWEvcvnWaGqBGR2PfiHSPIORICCzkk
	9vWeZITYJSDxbfIhsF0SArISmw5AzZGUOLjiBssERolZSFbPQrJ6FpLVs5CsWMDIsopRNLUg
	uaA4Kb3ISK84Mbe4NC9dLzk/dxMjMAGc/vesbwfjzQPWhxgFOBiVeHh3ZGeGCLEmlhVX5h5i
	NAW6aCKzlGhyPjDN5JXEGxqbGVmYmpgaG5lbmimJ8yZI/QwWEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwMg/Q7NWj0Mh+FfyNJZD629FbFtYu5Tz6M5H/P8PFP+/zbt9f0rtz2vtFtXOiy47
	n/u23Xuy8glNgz6eqJd1YjXW3s+UGwI8xdZ7aW/oag7K9u/bXG3VsN+69fve1inbH/9c8MV1
	x9+Yy7Lrf4jW2twWzvsyXcWldkr/nT2/zlnJh4R+a/VxdlFiKc5INNRiLipOBACKH5Wp+wIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAd2wSVkhBm9mC1gsuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsTjb9Ibd4v7Xo4wW3650MFlc3jWHzeLphItsFqe7WR14
	PHbOusvusWlVJ5vHnWt72DzmnQz06NuyitFj+ryfTB6fN8kFsEc1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8y4PGE/W8FapoqnPw6wNjB+Zuxi5OSQEDCR+Ld1ESuELSZx
	4d56ti5GLg4hgUWMElcvzwcrEhL4zSix4AIPiM0moCGxcvdbsCIRgWZGiZ3X37CAOMwC2xgl
	Jvw9xQ7RUSux/OMONhCbU8BF4uT/eUA2B4ewgJvEwr0JIGEWAVWJW1fPsICEeQUsJU7MKgQJ
	8woISvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmiEMVJHacfQ12m4iAlcT9S6eZIWpEJPa9eMc4
	gVFoFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBKeXZ9I7GFc1
	WBxiFOBgVOLh3ZGdGSLEmlhWXJl7iFGCg1lJhPdcd1aIEG9KYmVValF+fFFpTmrxIUZToEcn
	MkuJJucDU19eSbyhsYmZkaWRmYWRibm5kjjvwVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbG6pXb
	TsTM72l827urt2d35eYtm7/sMPt2LO/rWu/Pi7kenpSYXSLENvkV16u+e3OW5OtcvZui/vFH
	wQOhtV7rXVwEjr7//YD9zolFzGFqGo9WOL1t8FU084y2+/rc8OKn49fvfph70uKEktb3zMrH
	XRx3WY5tvCdt7j3RSjOusplpj5TuN29/OSWW4oxEQy3mouJEAGbIqyRFAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Monday, November 17, 2014 9:43 AM, Chanwoo Choi wrote:

> This patch adds the support for Samsung S2MPS13 PMIC device to the sec-core MFD
> driver. The S2MPS13 is very similar with existing S2MPS14 and includes PMIC/
> RTC/CLOCK devices.

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

