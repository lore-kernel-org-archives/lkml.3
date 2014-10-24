Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbaJXLHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:07:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14758 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaJXLHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:07:12 -0400
X-AuditID: cbfee68f-f791c6d000004834-15-544a32ded76f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/2] clk: samsung: Add clock controller driver for Exynos4415
 SoC
Date: Fri, 24 Oct 2014 20:07:06 +0900
Message-id: <1414148828-23719-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWyRsSkUPe+kVeIwbomRovrX56zWvyZ0Mpm
	Men+BBaL3gVX2SzONr1ht7i8aw6bxYzz+5gsDr9pZ7WYMfklm8WqXX8YHbg8ds66y+7Rt2UV
	o8fnTXIBzFFcNimpOZllqUX6dglcGdcX7WUsaOWoOHyFtYFxN1sXIyeHhICJxMcLf5ggbDGJ
	C/fWg8WFBJYyShxdFAtTc3BjI3sXIxdQfDqjROfWzawQThOTxNvO24wgVWwCWhL7X9wA6ubg
	EBEwlLh5SAmkhlngOqPEzFM9YFOFBUIljqz4xAJiswioSjyeegGsnlfAVeL3GmaIZQoSy5bP
	BJsvIdDMLjF3NsgykHoBiW+TD7GA1EsIyEpsOgBVLylxcMUNlgmMggsYGVYxiqYWJBcUJ6UX
	GesVJ+YWl+al6yXn525iBAbv6X/P+ncw3j1gfYhRgINRiYf3xgzPECHWxLLiytxDjKZAGyYy
	S4km5wNjJK8k3tDYzMjC1MTU2Mjc0kxJnHeh1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYwb/P0iStdxGW06dDz5/uLjYS8ms3TP+vTNrFlrUbDs+yDHC4yrmSKv80y40rnUI6FL/xQr
	m3HQJV0vvmuivF/7dhvK2XhPTHt1uuhjo98ls2v1azdtLl+rfbKbWS9ww+SqW9v9vFiTOx/8
	+zhDdHt099xNzl/+pT6b5/x9jZyPk/W7wFtnjk9SYinOSDTUYi4qTgQAv3sqsFkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jQd17Rl4hBqfbzSyuf3nOavFnQiub
	xaT7E1gsehdcZbM42/SG3eLyrjlsFjPO72OyOPymndVixuSXbBardv1hdODy2DnrLrtH35ZV
	jB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAB2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcy4vmgvY0ErR8Xh
	K6wNjLvZuhg5OSQETCQObmxkh7DFJC7cWw8U5+IQEpjOKNG5dTMrhNPEJPG28zYjSBWbgJbE
	/hc3gKo4OEQEDCVuHlICqWEWuM4oMfNUD9hUYYFQiSMrPrGA2CwCqhKPp14Aq+cVcJX4vYYZ
	YpmCxLLlM1knMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcHc+kdzCuarA4xCjA
	wajEw3tjhmeIEGtiWXFl7iFGCQ5mJRHel2peIUK8KYmVValF+fFFpTmpxYcYTYGWT2SWEk3O
	B0ZuXkm8obGJmZGlkbmhhZGxuZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGRgk3QbmeP8Fz
	r4Ym24X88Pxf7mU3L/DnjWQZiVMTe1JZ5apvvditHBLPEFh49IqBj22sw/Kvs+f2L5cQ21Em
	53e0g5PboPzVox+HuXvb8z/fPya1rNzo9lORuicPlb4v+RnFv2nzRZ3G2f5PPrMIqd0wVulv
	MsxYkTR/x8Z5+ucuZ7R/PXKNWYmlOCPRUIu5qDgRALOSKYukAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new clock controller device driver for Exynos4415 SoC.

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
 drivers/clk/samsung/clk-exynos4415.c               | 1133 ++++++++++++++++++++
 include/dt-bindings/clock/exynos4415.h             |  360 +++++++
 4 files changed, 1532 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos4415-clock.txt
 create mode 100644 drivers/clk/samsung/clk-exynos4415.c
 create mode 100644 include/dt-bindings/clock/exynos4415.h

-- 
1.8.5.5

