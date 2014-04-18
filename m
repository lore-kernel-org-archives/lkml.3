Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaDRCUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:20:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12182 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDRCUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:20:33 -0400
X-AuditID: cbfee68e-b7f566d000002344-e9-53508bef8b0c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] Support cpufreq driver for Exynos3250
Date: Fri, 18 Apr 2014 11:20:32 +0900
Message-id: <1397787634-9334-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkQPd9d0Cwwfe11hZPm36wW1z/8pzV
	onfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Rx5vQlVouNXz0cuDzuXNvD5rF5Sb3H
	lqvtLB59W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CV0bt6AXPBE7aK3X3bWBoY97J2MXJySAiY
	SJyY+YAFwhaTuHBvPVsXIxeHkMBSRom1n6axwRTtP3mYHSKxiFHizOE9jBBOE5PEipOnwKrY
	BLQk9r+4AWRzcIgI6En8/VwLUsMs8ItRYnLfHLB1wgJWEhs2b2UEsVkEVCU+XzrLDmLzCrhI
	HP35FOokOYkPex6BbZMQmM4u0XzkGFSDgMS3yYdYQBZICMhKbDrADFEvKXFwxQ2WCYyCCxgZ
	VjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIEhvTpf8/6djDePGB9iDEZaNxEZinR5HxgTOSV
	xBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkb1o/zl
	3umsbdx7s9cJNBpraVrOf3r+y9/G78IOSzqULyrt3axzpWoGa+nNtD1bqjSmfTPPe/DBpyFo
	netM46eHZPbP1bT+0bfn+syFC1XTBZ8c9jzfb6eXtd1KU7fw/9Hvdhe9fQ6XbLPveViosudG
	2ImQ18U7D896fPbpklM5P7v10vmcz/xVYinOSDTUYi4qTgQAHoXsVn8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jAd333QHBBlfPGFs8bfrBbnH9y3NW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PFmdOXWC02fvVw4PK4c20Pm8fmJfUe
	W662s3j0bVnF6PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJe
	Ym6qrZKLT4CuW2YO0FFKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoze
	1QuYC56wVezu28bSwLiXtYuRk0NCwERi/8nD7BC2mMSFe+vZuhi5OIQEFjFKnDm8hxHCaWKS
	WHHyFBtIFZuAlsT+FzeAbA4OEQE9ib+fa0FqmAV+MUpM7psDNlVYwEpiw+atjCA2i4CqxOdL
	Z8E28Aq4SBz9+RRqs5zEhz2P2Ccwci9gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwx
	z6R3MK5qsDjEKMDBqMTDe+Grf7AQa2JZcWXuIUYJDmYlEV7l0oBgId6UxMqq1KL8+KLSnNTi
	Q4zJQNsnMkuJJucDozmvJN7Q2MTMyNLI3NDCyNicNGElcd6DrdaBQgLpiSWp2ampBalFMFuY
	ODilGhi9Zi8M33qvunXblhk2VpXsPNVvdA791bH+YFPVIWj0ak/EHa7/3v9VdT1vnY1XkG64
	/tC182T6subnF2X7zNn82bp+3hTr+J73x/ju7on17ivdPBeXftyckMK6zkorsPxCePrLQq24
	E5PvvLp/PI/rdWDLR89VKcLveKLZ+d59+iqyUbtFabYSS3FGoqEWc1FxIgAI0okr3AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support cpufreq driver for Exynos3250 which uses the Cortex-A7
dual cores and has a target speed of 1.0 GHz and code clean using dev_err/info
instead of pr_err/info function.

This patchset has a dependency on following patchset[1] to support Exynos3250:
[1] https://lkml.org/lkml/2014/4/17/669

Chanwoo Choi (2):
  cpufreq: exynos: Use dev_err/info function instead of pr_err/info
  cpufreq: exynos: Add new Exynos3250 cpufreq driver

 drivers/cpufreq/Kconfig.arm          |  11 +++
 drivers/cpufreq/Makefile             |   1 +
 drivers/cpufreq/exynos-cpufreq.c     |  25 +++---
 drivers/cpufreq/exynos-cpufreq.h     |  18 ++++
 drivers/cpufreq/exynos3250-cpufreq.c | 158 +++++++++++++++++++++++++++++++++++
 5 files changed, 203 insertions(+), 10 deletions(-)
 create mode 100644 drivers/cpufreq/exynos3250-cpufreq.c

-- 
1.8.0

