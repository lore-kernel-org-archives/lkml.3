Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaLRKxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:53:39 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26782 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLRKxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:53:36 -0500
X-AuditID: cbfee691-f79b86d000004a5a-ce-5492b22de804
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH v2 0/2] mfd: arizona: Add support for OUTn_MONO
 register control
Date: Thu, 18 Dec 2014 19:53:14 +0900
Message-id: <1418899996-19744-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWyRsSkUFd306QQgzu7zSymPnzCZvFvyg12
	i/lHzrFa9L9ZyGqx6+99Rotzr1YyWtz/epTR4vKuOWwWS69fZLJY/vY/m8WE6WtZLFr3HmG3
	ON3N6sDrsWbeGkaPy329TB4rl39h89i0qpPN4861PWwe804Geryc+JvNo2/LKkaPz5vkAjij
	uGxSUnMyy1KL9O0SuDKezn7MXjCftWLKh2esDYwTWLoYOTkkBEwkTnxczQphi0lcuLeerYuR
	i0NIYCmjxPwtT4ASHGBF7T2uEPFFjBKrpqyGKprDJPHhRwNYN5uAhsT3z5uZQWwRAR2Jzx+P
	MYMUMQvsYZKYtGA1O0hCWCBe4uy892A2i4CqRN+Hq2A2r4CbxOrbB5ggztCW2Ncwkw3CPsYu
	MelrBUS9gMS3yYdYIC6Sldh0gBmiRFLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtUrTswtLs1L
	10vOz93ECIyL0/+eTdzBeP+A9SFGAQ5GJR5eCb1JIUKsiWXFlbmHGE2BNkxklhJNzgdGX15J
	vKGxmZGFqYmpsZG5pZmSOK+O9M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxcs3d9ieOv
	qopui7bsvSQsOnfOck0zr5n8U1adOJHTPzneRZivcMPkNPkO14BtZo96LpfxephVTLz0Oz1+
	ycRa75nxa5Rshd8L3b2xSJkpIJ+z4PZWeZHI0AtXn91ovtJQ5xS4xNCuun/20l0H9uY3vX7e
	IfT7jqbBw8xLBzgZNgV3fXU2eqPEUpyRaKjFXFScCAC7ArwWhgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jAV3dTZNCDL4e07OY+vAJm8W/KTfY
	LeYfOcdq0f9mIavFrr/3GS3OvVrJaHH/61FGi8u75rBZLL1+kcli+dv/bBYTpq9lsWjde4Td
	4nQ3qwOvx5p5axg9Lvf1MnmsXP6FzWPTqk42jzvX9rB5zDsZ6PFy4m82j74tqxg9Pm+SC+CM
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8XT2Y/aC+awVUz48Y21gnMDS
	xcjBISFgItHe49rFyAlkiklcuLeerYuRi0NIYBGjxKopq6GcOUwSH340sIJUsQloSHz/vJkZ
	xBYR0JH4/PEYM0gRs8AeJolJC1azgySEBeIlzs57D2azCKhK9H24CmbzCrhJrL59gAlinbbE
	voaZbBMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI67Z1I7GFc2WBxiFOBgVOLh
	ldCbFCLEmlhWXJl7iFGCg1lJhDc6ByjEm5JYWZValB9fVJqTWnyI0RRo+0RmKdHkfGBKyCuJ
	NzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRqYDRRrioT+3LfJliT4xnT
	byt/rhsrLfoYtawPXI66/TZt1RuOT9q3TKfIXJD3/M7fea3BI/VfvNKRm9Yrk5u+r1jX5F+1
	OLvP68/KkAvWbG1/bs20l75vOanXU1NsWVvHQwOttfnT4npe3Z/kbCzDFPxPY962IEe/i9FR
	26sbl8rddX7BcEyJX4mlOCPRUIu5qDgRAG7YkGrRAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add support for OUTn_MONO register control using platform data.
Each output signal can be configurated as a mono differential output.
The mono differential configuration is selected using the OUTn_MONO registers.

Changes in v2:
 - fix coding style issue
 - use ">=" instead of "==" in condition check

Inha Song (2):
  mfd: arizona: Add support for OUTn_MONO register control
  mfd: arizona: Update DT binding to support OUTn_MONO init_data

 Documentation/devicetree/bindings/mfd/arizona.txt |  7 +++++++
 drivers/mfd/arizona-core.c                        | 10 ++++++++++
 2 files changed, 17 insertions(+)

-- 
2.0.0.390.gcb682f8

