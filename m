Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab3CGALs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:11:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56865 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab3CGALq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:11:46 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-0d-5137db4165df
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, t.figa@samsung.com, patches@linaro.org
References: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
In-reply-to: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
Subject: RE: [PATCH v2 0/3] pinctrl: exynos: add support for Samsung's
 Exynos5250
Date: Thu, 07 Mar 2013 09:11:44 +0900
Message-id: <014101ce1ac8$5a4e8600$0eeb9200$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aWUmgh0qMmtAMSU2Hl7tNW9trOwAbp9ZQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zQ13H2+aBBrN2S1lc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW8X7qcrWAeV8XqNVOZGxincHQxcnJICJhITNhwmQ3C
	FpO4cG89kM3FISSwjFHiweXPTDBF7W/fsUMkFjFKNK85zQTh/GWU6NtwixWkik1AQ+Lw+2fs
	ILaIgJ/E+Z1fwDqYBfoZJZ5c2cICkhAS8JR4OP8pYxcjBwengJfEx+tGIGFhgWCJRTsugvWy
	CKhKPP/ZyA5SwitgK/H2tBxImFdAUOLH5HtgU5gFtCTW7zzOBGHLS2xe85YZpFxCQF3i0V9d
	iAuMJK5P/soMUSIise/FO0aQayQENrFLrF76nQ1ilYDEt8mHWCB6ZSU2HWCG+FdS4uCKGywT
	GCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkBjr28F484D1
	IcZkoPUTmaVEk/OBMZpXEm9obGxiZmJqYm5pam5KmrCSOK/8JZlAIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYyioteT88zWi7SqvX0z8fSVZ0+KRNLu2zrK9UksY3QqaZ4xof+YQv+qREUF
	BqlJi0OPxQYuu1Z46EmucsWLr8e5inUfLuW8MHuPZMfbJTw1l16cmp+g3Vq9/PtzRQeGq/f3
	WTUv8JpqdeZOWPp8N5klG2T+O5Zc0nzOJW3UujyDZ4prg/uPybuUWIozEg21mIuKEwEvbmSn
	xwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAV3H2+aBBltbxCwu75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz3i9dzlYwj6ti
	9ZqpzA2MUzi6GDk5JARMJNrfvmOHsMUkLtxbz9bFyMUhJLCIUaJ5zWkmCOcvo0TfhlusIFVs
	AhoSh98/A+sQEfCTOL/zCztIEbNAP6PEkytbWEASQgKeEg/nP2XsYuTg4BTwkvh43QgkLCwQ
	LLFox0WwXhYBVYnnPxvZQUp4BWwl3p6WAwnzCghK/Jh8D2wKs4CWxPqdx5kgbHmJzWveMoOU
	SwioSzz6qwtxgZHE9clfmSFKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel
	5xrpFSfmFpfmpesl5+duYgRH8DPpHYyrGiwOMQpwMCrx8G7MMQ8UYk0sK67MPcQowcGsJMJ7
	dwlQiDclsbIqtSg/vqg0J7X4EGMy0J8TmaVEk/OBySWvJN7Q2MTMyNLIzMLIxNycNGElcV7G
	U08ChATSE0tSs1NTC1KLYLYwcXBKNTCyOj9Pc2a4M+Mg36KPoSu2NMSpiq2/cdxqher/bUvN
	72zxddSS+/W/abvFjrDHYkwai7MrJZbv/31DhM/cKHlzv9HUMynTpfa9L2iq1Xnz5Wdn78XM
	3iWKLLenyzTJr/740vft7xXzmY0NP7gydm7cMWlj2V+BK3vT3j0v5tWWjK187awhH1yqxFKc
	kWioxVxUnAgAQ3IarSQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> 
> Changes since v1:
> - Change the compatible string from "samsung,pinctrl-exynos5250" to
>   "samsung,exynos5250-pinctrl".
> - Rebased to v3.9-rc1
> 

Thomas, this stuff is already in my tree for v3.10, and above changes
included in there. Do you want to replace with this patches?

- Kukjin

> This patch series add pinctrl driver support for Samsung's Exynos5250 SoC.
> The first patch adds the required Exynos5250 SoC specific data which is
> used by the Samsung pinctrl driver to setup the pinctrl/pinmux/eint
> controllers. The second and third patches skips the wakeup interrupt and
> gpiolib registration if the pinctrl support is enabled for Exynos5250.
> 
> Thomas Abraham (3):
>   pinctrl: exynos: add exynos5250 SoC specific data
>   gpio: samsung: skip gpiolib registration if pinctrl support is enabled
> for exynos5250
>   arm: exynos: skip wakeup interrupt registration for exynos5250 if
> pinctrl is enabled
> 
>  arch/arm/mach-exynos/common.c     |    1 +
>  drivers/gpio/gpio-samsung.c       |    1 +
>  drivers/pinctrl/pinctrl-exynos.c  |  108
> +++++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/pinctrl-samsung.c |    2 +
>  drivers/pinctrl/pinctrl-samsung.h |    1 +
>  5 files changed, 113 insertions(+), 0 deletions(-)

