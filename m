Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3K2ASL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:18:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:35768 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab3K2ASH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:18:07 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-98-5297dd3e9bc3
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
 <1385626183-22990-6-git-send-email-k.kozlowski@samsung.com>
 <20131128171434.GN27568@sirena.org.uk>
In-reply-to: <20131128171434.GN27568@sirena.org.uk>
Subject: RE: [PATCH v2 5/5] mfd: sec: Constify regmap configs and regmap irqs
Date: Fri, 29 Nov 2013 09:18:08 +0900
Message-id: <05ce01ceec98$7b4e3470$71ea9d50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIn7cDk689h23sBcLg83vR3zAVxUwJkxD4VApxplN6ZYUtwkA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+Zoa7d3elBBqdXKFksuXiV3WLqwyds
	Fs9u7WWyeP3C0OJs0xt2i/tfjzJafLvSwWRxedccNou1R+6yW+zv7GC0ON3N6sDtsXPWXXaP
	PRNPsnlsWtXJ5nHn2h42j0OHOxg95p0M9OjbsorRY/q8n0wenzfJBXBGcdmkpOZklqUW6dsl
	cGV09e1kLehhqlh/bD9bA+NNxi5GTg4JAROJlz+ns0LYYhIX7q1nA7GFBJYxSkxcIQJTM7vl
	AVANF1B8EaPE5NuLWSCcP4wS81buBpvEJqAhsXL3W7BuEYEIiclHD7KDFDELvGWSWNg8gRmi
	Yx2jxKK9zUxdjBwcnALGEnd32oE0CAv4SlzvuAR2BouAqkTvwyNgQ3kFLCUmT+xhhbAFJX5M
	vscCYjMLaEms33mcCcKWl9i85i0zxKkKEjvOvmYEGS8i4CTxZLk6RImIxL4X7xhBTpAQWMoh
	8Wz/Q6hdAhLfJh9iAamXEJCV2HQAaoykxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkF
	yQXFSelFRnrFibnFpXnpesn5uZsYIYmgbwfjzQPWhxiTgdZPZJYSTc4HJpK8knhDYzMjC1MT
	U2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDI7fDxrGxxXehJg6o7
	mtIOubYFB8vinRmfq33fd/IV2xILi9trUqd98bpitN73zqFd37SPruo7vaLlw7JZdUxzbxmc
	7XTYIGkffoTj7jqb75tdJV4vvZaow16nL1Q4Vy9S3SonNiY3XeC+7ffpDbxfX2w0alW63Bju
	yqyetzr8bkbOp2c6CYxKLMUZiYZazEXFiQAZL2JwGgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jAV27u9ODDI7+lbVYcvEqu8XUh0/Y
	LJ7d2stk8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt9jf2cFocbqb1YHbY+esu+we
	eyaeZPPYtKqTzePOtT1sHocOdzB6zDsZ6NG3ZRWjx/R5P5k8Pm+SC+CMamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0dW3k7Wgh6li/bH9bA2MNxm7GDk5JARMJGa3PGCF
	sMUkLtxbz9bFyMUhJLCIUWLy7cUsEM4fRol5K3eDdbAJaEis3P2WDcQWEYiQmHz0IDtIEbPA
	WyaJhc0TmCE61jFKLNrbzNTFyMHBKWAscXenHUiDsICvxPWOS2DrWARUJXofHgEbyitgKTF5
	Yg8rhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5khTlWQ2HH2NSPIeBEBJ4kny9UhSkQk9r14
	xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ5pnUjsY
	VzZYHGIU4GBU4uFd0T09SIg1say4MvcQowQHs5II768ioBBvSmJlVWpRfnxRaU5q8SHGZKBH
	JzJLiSbnA5NgXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	dtuHLXywdYPj6xsPS50Yp+h/+8af/2qD+ooNzfVOHsb9Qfy8qu0GjcIh/FXN7TN3PH62yUbt
	ArdL4mGRTXmZzBLlzM9EREtl/U0/Kv6a+2ZK15a4xbPbpjpzKoU9mBam+K3t3N9r01sOLTax
	e2r0uIX9yhS/Y3N7QnL8E4zue9y62S+lfSFIiaU4I9FQi7moOBEAQgh3GngDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 29, 2013 2:15 AM, Mark Brown wrote:
> > Add "const" to "static struct regmap_irq" and "static struct
> > regmap_config".
> 
> Reviewed-by: Mark Brown <broonie@linaro.org>

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

