Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3BRFOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:14:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56715 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3BRFOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:14:08 -0500
X-AuditID: cbfee691-b7f556d000001a24-67-5121b89ee826
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000201ce0d96$9fa550b0$deeff210$%han@samsung.com>
In-reply-to: <000201ce0d96$9fa550b0$deeff210$%han@samsung.com>
Subject: [PATCH 2/5 RESEND] video: s3c-fb: remove duplicated S3C_FB_MAX_WIN
Date: Mon, 18 Feb 2013 14:14:06 +0900
Message-id: <000301ce0d96$c68ba8a0$53a2f9e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Nlp93iQLgxtgRRimJ2C2xwhxUfAAAA+4A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zfd35OxQDDU7vYLQ40feB1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVsW29VsIKtYv6ZCYwNjNNZuxg5OSQETCRen97HBGGL
	SVy4t56ti5GLQ0hgGaPE1CnbWWCKtqxtYodILGKUuHn2ODNIQkjgF6PEguWZIDabgJrEly+H
	gYo4OEQE9CXaWjRA6pkF5jJKXFpzhAWi3lai88VJMJtTwE5i3qVTYHOEBbwlvj57xQZiswio
	StyeeBrM5gWq/3BjLQuELSjxY/I9MJtZQEti/c7jTBC2vMTmNW+ZQfZKCKhLPPqrCxIWETCS
	eHTyPDNEiYjEvhfvGEHukRBYxS4xd+ZuqF0CEt8mH2KB6JWV2HSAGeJfSYmDK26wTGCUmIVk
	8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUIibOIOxvsHrA8xJgOt
	n8gsJZqcD4zQvJJ4Q2NjEzMTUxNzS1NzU9KElcR55S/JBAoJpCeWpGanphakFsUXleakFh9i
	ZOLglGpgDHr6Yo+h3BHt1xURIm2/ryv6frXU3VYjcv66x6abq3bczp3999YmcfG/RdJugc/+
	fzDfdI31K+vBy+cC3T/eLIj7uerz/MNslS/e2ef+33r5s61dozZbUMaT7mPdf9l+pCjPW6Dp
	r9nEdPZ3447V3NExrd2lskd1pNzXTW6alh/ftzOGj3PzAiWW4oxEQy3mouJEAKcbRq7GAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAd15OxQDDc6ftbQ40feB1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbFtvVbCCrWL+
	mQmMDYzTWbsYOTkkBEwktqxtYoewxSQu3FvP1sXIxSEksIhR4ubZ48wgCSGBX4wSC5Zngths
	AmoSX74cBmrg4BAR0Jdoa9EAqWcWmMsocWnNERaIeluJzhcnwWxOATuJeZdOgc0RFvCW+Prs
	FRuIzSKgKnF74mkwmxeo/sONtSwQtqDEj8n3wGxmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eiv
	LkhYRMBI4tHJ88wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGC4/eZ1A7GlQ0WhxgFOBiVeHgZ8hUDhVgTy4orcw8xSnAwK4nwbhIBCvGm
	JFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MLXklcQbGpuYGVkamVkYmZibkyasJM7LeOpJgJBA
	emJJanZqakFqEcwWJg5OqQbGyXdqtlYqZj8vmeJ0anrpM56AgzG7IvrysmOnLv+4s+uJcPqW
	2Itnp1nN1CuRXfWjTvVVqFPaZh9L09NXBSXzy3kLWCru7C1dmDBrXpbsc3VjnZDlr3aZTl4r
	ztrtvT10VY7pZ7UbNpEmP+a9r5d/8pxfMHPjjPZV83X/H3uVuufLW4Gen84vlFiKMxINtZiL
	ihMB9ccVYyMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S3C_FB_MAX_WIN is already defined in 'plat-samsung/include/plat/fb.h'.
So, this definition in 'include/video/samsung_fimd.h' should be
removed to avoid the duplication.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 include/video/samsung_fimd.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/video/samsung_fimd.h b/include/video/samsung_fimd.h
index e755448..0865256 100644
--- a/include/video/samsung_fimd.h
+++ b/include/video/samsung_fimd.h
@@ -438,8 +438,6 @@
 #define BLENDCON_NEW_8BIT_ALPHA_VALUE		(1 << 0)
 #define BLENDCON_NEW_4BIT_ALPHA_VALUE		(0 << 0)
 
-#define S3C_FB_MAX_WIN (5)  /* number of hardware windows available. */
-
 /* Notes on per-window bpp settings
  *
  * Value	Win0	 Win1	  Win2	   Win3	    Win 4
-- 
1.7.2.5


