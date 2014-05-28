Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaE1LKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:10:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8302 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaE1LKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:10:17 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-ad-5385c4179871
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/4] regulator: s2mps11: Add support S2MPU02 PMIC device
Date: Wed, 28 May 2014 20:10:07 +0900
Message-id: <1401275411-21947-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkQFf8SGuwwffLvBZTHz5hs7j+5Tmr
	RefZJ8wWZ5vesFvc/3qU0eLblQ4mi8u75rBZ3G5cwWZxupvV4uKKL0wOXB47Z91l99i0qpPN
	4861PWwe804GevRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGhMv9bAXHOSoWXVzK2sC4mK2L
	kZNDQsBEYm/nCRYIW0ziwr31QHEuDiGBpYwSPQeXMncxsoMVnReACE9nlHiyeDMzhNPEJPFy
	dQc7SDObgJbE/hc3wJpFBHoZJfpn9jOBJJgFKiVur7sFtkFYwENi+tubjCA2i4CqxOm9t8Bq
	eAVcJVbN3sIKcYWcxIc9j9hBBkkILGKXmNZ/nAWiQUDi2+RDQDYHUEJWYtMBZoh6SYmDK26w
	TGAUXMDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMLRP/3s2cQfj/QPWhxiTgcZNZJYS
	Tc4HxkZeSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTAG/t9kKcx6+HNvxBZX9bTXDI9l+5l5U353lgjqXnvAm6vYWGStnCb5LsneQ034ZPcP6VPv
	ZnDMnqYnbft/26Zroq5eJeo8kSovsz9r1tx/s9/tXOCCikMXBWv1Fa/KeDGJWrYXrptzav1y
	nxqmzuDnDrzOWekH3rKfms2jqaex/mvv9CePVJVYijMSDbWYi4oTAcTsLIKDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jQV3xI63BBqePs1pMffiEzeL6l+es
	Fp1nnzBbnG16w25x/+tRRotvVzqYLC7vmsNmcbtxBZvF6W5Wi4srvjA5cHnsnHWX3WPTqk42
	jzvX9rB5zDsZ6NG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYMyZc7mcrOM5RsejiUtYGxsVsXYzsHBICJhLnBboYOYEsMYkL99YDRbk4hASmM0o8WbyZ
	GcJpYpJ4ubqDHaSKTUBLYv+LG2BVIgK9jBL9M/uZQBLMApUSt9fdYgGxhQU8JKa/vckIYrMI
	qEqc3nsLrIZXwFVi1ewtrBDr5CQ+7HnEPoGRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT8
	3E2M4Mh5Jr2DcVWDxSFGAQ5GJR7eA4tbgoVYE8uKK3MPMUpwMCuJ8JrvbQ0W4k1JrKxKLcqP
	LyrNSS0+xJgMtH0is5Rocj4wqvNK4g2NTcyMLI3MDS2MjM1JE1YS5z3Yah0oJJCeWJKanZpa
	kFoEs4WJg1OqgXFJdsZkWf/dUX86jCTrzh2Qv/Hk3o1nqm833/w0ZRWXHV+zd9yU0k25y3xV
	Jn7mzRFQFdlqKaFtyF6l5PPy0e0lr6R84q2rA/ZJTr2gvyTt3+Ef7lZzfrrf7OSquVJuKM9m
	OVkld+alL3OluYR13x1WXbX0ocnc6X3fvxtnbTg04+gWvrfx3JVKLMUZiYZazEXFiQAhR6K2
	4AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Samsung S2MPU02 PMIC device driver in exiting S2MPS11 PMIC
driver because S2MPU02 has a little different between S2MPU02 and S2MPS1x.
The S2MPU02 PMIC has LDO[1-28] and BUCK[1-7] regulators.

Chanwoo Choi (3):
  mfd: sec-core: Add support for S2MPU02 device
  regulator: s2mps11: Add support S2MPU02 regulator device
  dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC

Jonghwa Lee (1):
  regulator: s2mps11: Set offset to voltage hexadecimal code of S2MPU02 LDO regulators

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   7 +-
 drivers/mfd/sec-core.c                            |  45 ++++
 drivers/mfd/sec-irq.c                             |  88 ++++++
 drivers/regulator/s2mps11.c                       | 315 ++++++++++++++++++++--
 include/linux/mfd/samsung/core.h                  |   1 +
 include/linux/mfd/samsung/irq.h                   |  24 ++
 include/linux/mfd/samsung/s2mpu02.h               | 205 ++++++++++++++
 7 files changed, 667 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

-- 
1.8.0

