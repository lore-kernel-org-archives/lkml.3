Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaJ0BMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:12:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16903 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaJ0BMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:12:03 -0400
X-AuditID: cbfee68e-f79b46d000002b74-71-544d9be0f759
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/2] clk: samsung: Add clock controller driver for Exynos4415
 SoC
Date: Mon, 27 Oct 2014 10:11:56 +0900
Message-id: <1414372318-594-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRsSkSPfBbN8Qg78TeC2uf3nOavFnQiub
	xaT7E1gsehdcZbM42/SG3eLyrjlsFjPO72OyOPymndVixuSXbBardv1hdODy2DnrLrtH35ZV
	jB6fN8kFMEdx2aSk5mSWpRbp2yVwZbQ/f8Bc8Iuj4s3qtUwNjLPZuxg5OSQETCQWfTzGCGGL
	SVy4t54NxBYSWMoosfZQHUzN4QefWLoYuYDi0xklnizaxwrhNDFJ7H3TxgxSxSagJbH/xQ2g
	bg4OEQFDiZuHlEBqmAWuM0rMPNUDNlVYIFTi4dc1YJtZBFQlJk5sANvMK+AscXjDfDaIbQoS
	y5bPZIWw29klFs+zh6gXkPg2+RALyHwJAVmJTQeYIUokJQ6uuMEygVFwASPDKkbR1ILkguKk
	9CIjveLE3OLSvHS95PzcTYzA8D3971nfDsabB6wPMQpwMCrx8FoU+oYIsSaWFVfmHmI0Bdow
	kVlKNDkfGCV5JfGGxmZGFqYmpsZG5pZmSuK8CVI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFw
	SjUwyry6Kr2Q2T9Bd9euqaUcnZ1813eYe0jPL7xqMFN93mv7Y/0Szzljlyzh+1uyalFF5uwD
	xcY9xZrdG071Hn6UtFvh9KnkdxYz2kukA4o2JHFGFqR717KFXgi9u3fFjjCZwuucYa0hhnbH
	bPprtp24ra34l/vMXfXrvtNKBLqlOrdnX25IeZCpxFKckWioxVxUnAgAcTZj3loCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jQd0Hs31DDE5PZbe4/uU5q8WfCa1s
	FpPuT2Cx6F1wlc3ibNMbdovLu+awWcw4v4/J4vCbdlaLGZNfslms2vWH0YHLY+esu+wefVtW
	MXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjGj/fkD5oJfHBVv
	Vq9lamCczd7FyMkhIWAicfjBJxYIW0ziwr31bF2MXBxCAtMZJZ4s2scK4TQxSex908YMUsUm
	oCWx/8UNoCoODhEBQ4mbh5RAapgFrjNKzDzVwwZSIywQKvHw6xqwDSwCqhITJzYwgti8As4S
	hzfMZ4PYpiCxbPlM1gmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEfIM6kdjCsb
	LA4xCnAwKvHwWhT6hgixJpYVV+YeYpTgYFYS4RXNBwrxpiRWVqUW5ccXleakFh9iNAXaPpFZ
	SjQ5Hxi9eSXxhsYmZkaWRuaGFkbG5krivAdarQOFBNITS1KzU1MLUotg+pg4OKUaGPWbNj3+
	wV5bNilKJ6Vdo/vHPdtJnhczZSJ/3uD1adZ49bJ5Wvnum6xmPjMipvx6GCxlMcH16PbPC74m
	xAh1mc1pDS4Oyb11ZM6fztAkHcsjl9s4m6JcHTrYZf5rFCW+rFn7O55lDb9mG++P3IQ575q+
	m3bHddd/ku0oULO/ef/jKvmAmdPWKLEUZyQaajEXFScCABHRGlOmAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new clock controller device driver for Exynos4415 SoC.

Changes from v2:
- Fix issue by checkpatch.pl
- Add 'exynos4415' prefix to the name of tables/functions/variables

Changes from v1:
- Separate only clock patches from Exynos4415 patchset[1]
 [1] [PATCH 0/5] Support new Exynos4415 SoC based on Cortex-A9 quad cores
  : https://lkml.org/lkml/2014/10/19/253
- Fix string issue on documentation file of Exynos4415 clock controller

Chanwoo Choi (2):
  clk: samsung: exynos4415: Add clocks using common clock framework
  clk: samsung: Document binding for Exynos4415 clock controller

 .../devicetree/bindings/clock/exynos4415-clock.txt |   38 +
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos4415.c               | 1142 ++++++++++++++++++++
 include/dt-bindings/clock/exynos4415.h             |  360 ++++++
 4 files changed, 1541 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos4415-clock.txt
 create mode 100644 drivers/clk/samsung/clk-exynos4415.c
 create mode 100644 include/dt-bindings/clock/exynos4415.h

-- 
1.8.5.5

