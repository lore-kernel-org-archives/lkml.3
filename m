Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437Ab3DHHXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:23:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34202 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934379Ab3DHHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:23:05 -0400
X-AuditID: cbfee690-b7f656d0000007e3-f1-51627053eac3
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mike Turquette'" <mturquette@linaro.org>,
        "'Tushar Behera'" <tushar.behera@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: patches@linaro.org, "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <1364890840-20052-1-git-send-email-tushar.behera@linaro.org>
 <20130404213331.8665.7028@quantum>
In-reply-to: <20130404213331.8665.7028@quantum>
Subject: RE: [PATCH] clk: exynos5250: Fix divider values for sclk_mmc{0,1,2,3}
Date: Mon, 08 Apr 2013 16:22:58 +0900
Message-id: <2c9001ce3429$e5989a50$b0c9cef0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xfBK2adeO+0X8ThGuiyDuue8YPQCpjHSg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zA93ggqRAgxm9/BaXd81hs5hxfh+T
	xdMJF9ksphz+wmJxbMYSRov2v3vZHNg87lzbw+bxeZNcAFMUl01Kak5mWWqRvl0CV8az/weY
	C6axV0w48ZGlgfEZaxcjJ4eEgInEhZ4tTBC2mMSFe+vZuhi5OIQEljFKHGg+wgZTtGfSYVaI
	xCJGiZOTbrNAOH8ZJf5e+ARWxSagIXH4/TN2kISIwFxGiS9rp7CAJJgFXCSa7jxmB7GFBHIl
	3vz9CraPU0BfYteUjWB3CAv4SSxdfoUZxGYRUJV4eeECWA2vgK3E785trBC2oMSPyfeAZnIA
	zVSXmDIlF2K8vMTmNW+ZQcISQOFHf3VBwiICRhI3bx5nhSgRkdj34h0jyGkSApfYJTq+vWaC
	WCUg8W3yIRaIXlmJTQeYIR6WlDi44gbLBEaJWUgWz0JYPAvJ4llINixgZFnFKJpakFxQnJRe
	ZKJXnJhbXJqXrpecn7uJERKVE3Yw3jtgfYgxGWj7RGYp0eR8YFTnlcQbGpsZWZiamBobmVua
	kSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRN+7rPOcvZnuc6+dFra2NN9nv
	W/d2s/m7lexmShOXM2Uyn5zobfh5ycLO3eu/TA5o/Ddr/XpZrd8CKhUdwUdvZc68IjKNYfMe
	iQ9hH10us17Pi7JhfqTByf1C7lvvnoLGLnP5v4ZfSvVW1u43UT+qmr/ddke/m3Gaw6n89jU3
	+bj/mnanWcYpsRRnJBpqMRcVJwIAWIiFj+ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd3ggqRAg+OLuSwu75rDZjHj/D4m
	i6cTLrJZTDn8hcXi2IwljBbtf/eyObB53Lm2h83j8ya5AKaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMZ/8PMBdMY6+YcOIjSwPjM9YuRk4OCQETiT2TDkPZYhIX7q1n
	62Lk4hASWMQocXLSbRYI5y+jxN8Ln9hAqtgENCQOv3/GDpIQEZjLKPFl7RQWkASzgItE053H
	7CC2kECuxJu/X5lAbE4BfYldUzaCrRAW8JNYuvwKM4jNIqAq8fLCBbAaXgFbid+d21ghbEGJ
	H5PvAc3kAJqpLjFlSi7EeHmJzWveMoOEJYDCj/7qgoRFBIwkbt48zgpRIiKx78U7xgmMQrOQ
	DJqFMGgWkkGzkHQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc88+kdzCuarA4xCjA
	wajEw3vga2KgEGtiWXFl7iFGCQ5mJRHeRXlJgUK8KYmVValF+fFFpTmpxYcYk4HenMgsJZqc
	D0xHeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAOO+H7d4L
	Z04xFd/3dExe1/+5f2WStniky6X0JKPn045sVd8be6N+LRsn3/M3WrqRmiWfXZb8ralgDhHP
	ezaTddbhd0dDZZOMk3j5JTWZ3kS3uP2vOPTDrvMVS90sMQdO1gWtdkdf5c8Q/7h1YvTT45/f
	cX+W9XtmNj3SfWZbLrNjxWPx1NV9SizFGYmGWsxFxYkA8UOwfT0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Turquette wrote:
> 
> Quoting Tushar Behera (2013-04-02 01:20:40)
> > In legacy setup, sclk_mmc{0,1,2,3} used PRE_RATIO bit-field (8-bit wide)
> > instead of RATIO bit-field (4-bit wide) for dividing clock rate.
> >
> > With current common clock setup, we are using RATIO bit-field which
> > is creating FIFO read errors while accessing eMMC. Changing over to
> > use PRE_RATIO bit-field fixes this issue.
> >
> > dwmmc_exynos 12200000.dwmmc0: data FIFO error (status=00008020)
> > mmcblk0: error -5 transferring data, sector 1, nr 7, cmd response 0x900,
> card status 0x0
> > end_request: I/O error, dev mmcblk0, sector 1
> >
> > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> > CC: Thomas Abraham <thomas.abraham@linaro.org>
> 
> I guess this will be applied through the samsung tree, so:
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>
> 
Thanks, applied.

- Kukjin

