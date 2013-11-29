Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab3K2AKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:10:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28253 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3K2AKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:10:40 -0500
X-AuditID: cbfee691-b7f666d0000048b0-2e-5297db799f89
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <1385626183-22990-3-git-send-email-k.kozlowski@samsung.com>
 <20131128134641.GI27568@sirena.org.uk>
In-reply-to: <20131128134641.GI27568@sirena.org.uk>
Subject: RE: [PATCH v2 2/5] rtc: s5m: Fix unsuccesful IRQ request during probe
Date: Fri, 29 Nov 2013 09:10:36 +0900
Message-id: <05c501ceec97$6d8ae8c0$48a0ba40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIn7cDk689h23sBcLg83vR3zAVxUwGV9uTkANXNQtKZdfSZkA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+ZkW7V7elBBrc0LZZcvMpuMfXhEzaL
	Z7f2Mlm8fmFocbbpDbvF/a9HGS2+Xelgsri8aw6bxdojd9kt9nd2MFqc7mZ14PbYOesuu8ee
	iSfZPDat6mTzuHNtD5vHocMdjB7zTgZ69G1Zxegxfd5PJo/Pm+QCOKO4bFJSczLLUov07RK4
	MmYeUCiYzFTRNmU1ewPjfcYuRg4OCQETidZ7Bl2MnECmmMSFe+vZuhi5OIQEljFKLPh9hhUi
	YSLRcX0BI0RiEaPEjrkLWCCcP4wSz7pmsYNUsQloSKzc/ZYNxBYRiJCYfPQgO0gRs8BbJomF
	zROYITrWMUps2HiXEaSKU8BYonvRFjBbWMBP4sarG2A2i4CqxIafa1hAbF4BS4nJmy4xQtiC
	Ej8m3wOLMwtoSazfeZwJwpaX2LzmLTPErQoSO86+ZoS4wkni2LtfrBA1IhL7XrwD+0FCYC6H
	xMZzv5kglglIfJt8iAUSGLISmw5AzZGUOLjiBssERolZSFbPQrJ6FpLVs5CsWMDIsopRNLUg
	uaA4Kb3IVK84Mbe4NC9dLzk/dxMjJBFM3MF4/4D1IcZkoPUTmaVEk/OBiSSvJN7Q2MzIwtTE
	1NjI3NKMNGElcd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhizZp47tKJeIy8scNEz
	GaOQu/O9XxqGaKV4P3Iq7Kj5mcc865Tkjqwjh3XevF3jYZk2XSjK+ujRCDkdpnDZH0rccidU
	ZJ8edbUIuq74rVM3gvmTIregj5fepzXNczKf5FyrP6Kw4/PGX2lTM/YtLzzOk7vo+tyMY/nM
	ytvUIiW1Xs1gXZ6r2qnEUpyRaKjFXFScCACzcOVXGgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsVy+t9jAd3K29ODDCa8s7BYcvEqu8XUh0/Y
	LJ7d2stk8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt9jf2cFocbqb1YHbY+esu+we
	eyaeZPPYtKqTzePOtT1sHocOdzB6zDsZ6NG3ZRWjx/R5P5k8Pm+SC+CMamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMfOAQsFkpoq2KavZGxjvM3YxcnJICJhIdFxfAGWL
	SVy4t56ti5GLQ0hgEaPEjrkLWCCcP4wSz7pmsYNUsQloSKzc/ZYNxBYRiJCYfPQgO0gRs8Bb
	JomFzROYITrWMUps2HgXbC6ngLFE96ItYLawgJ/EjVc3wGwWAVWJDT/XsIDYvAKWEpM3XWKE
	sAUlfky+BxZnFtCSWL/zOBOELS+xec1bZohbFSR2nH3NCHGFk8Sxd79YIWpEJPa9eMc4gVFo
	FpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBKeaZ9I7GFc1WBxi
	FOBgVOLhXdE9PUiINbGsuDL3EKMEB7OSCO+vIqAQb0piZVVqUX58UWlOavEhxmSgTycyS4km
	5wPTYF5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MOrUnZds
	W7SMJ+9fUGvF/1y5U5tbzv0pF0iMn5f4N1C76Zml0NHPnl+S61s1/T95GR7bkfLuvNOpKY9e
	l7Hdz4jrufBk8dJw28ym77K+hifiA5Mff4gJ/uR9N2Ll1JqqkHuBh5ZxftN+xeT08XbEzc7c
	+28MX35Xt1Z+etFKXYNLSWlz/SGJHUosxRmJhlrMRcWJAGRM9Fp5AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 10:47 PM, Mark Brown wrote:
> > Fix rtc-s5m interrupt request by using regmap_irq_get_virq() for mapping
> > the IRQ.
> 
> Reviwed-by: Mark Brown <broonie@linaro.org>

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

