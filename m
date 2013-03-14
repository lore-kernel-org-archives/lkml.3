Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab3CNKtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:49:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11085 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab3CNKrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:47:20 -0400
X-AuditID: cbfee690-b7f656d0000007e3-dc-5141aab6ad3b
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        dianders@chromium.org
Subject: [PATCH 0/2] dwc3: exynos: Device tree fixes
Date: Thu, 14 Mar 2013 16:14:56 +0530
Message-id: <1363257898-17504-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSo7t9lWOgwc4VTBYH79dbHJj9kNXi
	7LKDbBbNi9ezWfQuuMpmcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxeEVB5gsjs1YwujA7bHg8xV2
	j9kNF1k87lzbw+axf+4ado/zMxYyevRtWcXocfzGdiaPz5vkAjiiuGxSUnMyy1KL9O0SuDJm
	7zvNUrCBo+LhnKtsDYxv2LoYOTkkBEwkvm1cwQhhi0lcuLceKM7FISSwlFFi++kf7F2MHGBF
	89oyIeLTGSX2/FjKBOFMYZI4PvEj2CQ2AV2Jpre7wCaJCKRL/L/bD2YzC5xhlHj5IhbEFgYa
	dHjGZ7A4i4CqxKHWTiYQm1fAQ6Kt+TELxBUKEm9uP2MGWSAhsIldYvH7XjaIBgGJb5MPsUBc
	JCux6QAzRL2kxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREY+qf/PZuw
	g/HeAetDjMlA4yYyS4km5wNjJ68k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC
	1KL4otKc1OJDjEwcnFINjFmiT5hlm59/ma7bfjN4TVnDt6VmLHHFmxNUSmW2ya3WTUz5eWLO
	4frvvV3irx7pfbO753HqrFTVC6ZHklKBXf+rL92ObXvJEdeyLrmpd9mvveq1O9/3pdzgrGwq
	DjnUyida729gou3HE/l+96N5dws+/U5fIeGX29Fk4GrQ21WTNNOy3nqBEktxRqKhFnNRcSIA
	yPRzi5MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQd1tqxwDDda0mlkcvF9vcWD2Q1aL
	s8sOslk0L17PZtG74CqbxeVdc9gsZi/pZ7GYcX4fk8WiZa3MFodXHGCyODZjCaMDt8eCz1fY
	PWY3XGTxuHNtD5vH/rlr2D3Oz1jI6NG3ZRWjx/Eb25k8Pm+SC+CIamC0yUhNTEktUkjNS85P
	ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VEmhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOYMXvfaZaCDRwVD+dcZWtgfMPWxcjBISFgIjGvLbOLkRPI
	FJO4cG89UJiLQ0hgOqPEnh9LmSCcKUwSxyd+ZAOpYhPQlWh6u4sRxBYRSJf4f7cfzGYWOMMo
	8fJFLIgtDDT08IzPYHEWAVWJQ62dTCA2r4CHRFvzYxaIbQoSb24/Y57AyL2AkWEVo2hqQXJB
	cVJ6rpFecWJucWleul5yfu4mRnBkPZPewbiqweIQowAHoxIPb4SoY6AQa2JZcWXuIUYJDmYl
	EV5PL6AQb0piZVVqUX58UWlOavEhxmSg7ROZpUST84FRn1cSb2hsYm5qbGppYmFiZkmasJI4
	78FW60AhgfTEktTs1NSC1CKYLUwcnFLACN67cLFTrkrMxJshdqt7u1352T63L/7LPJeL99NG
	9dWeXzZGaIn639ox455Sk0xbyhtV89s62yefWdfScl79ucq1XPnrwizL9n14cnb5j9e3ldbN
	CzeZJeV1YLW1wCkh7T89fm09r+tbtP3PPzQUapr5XytifviLjog1e44lPJ3vsfn09YikeUos
	xRmJhlrMRcWJAJAdSYXwAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set modifies dwc3-exynos as per latest bindings
available for dwc3. Now the dwc3 core also has device support,
there's no need to add platform device for core in glue layers.
This change has come as a result of discussion happened in:
[PATCH RFC] usb: dwc3: Get PHY from platform specific dwc3 dt node.

Additionally, now that Samsung exynos series has moved to common
clock framework, we use clock_prepare_enable() and clock_disable_unprepare()
APIs.
Some cleanup is also done here.

Based on 'usb-next' plus Felipe's 'testing' branch patches;
(some 194 patches in fact ;-), on top of 3.9rc2 tag).
Also based on: "usb: dwc3: set dma_mask for dwc3_omap device" by Kishon
in which DMA mask for dwc3-core is being set from its parent.

Vivek Gautam (2):
  usb: dwc3: exynos: Use of_platform API to create dwc3 core pdev
  usb: dwc3: exynos: use clk_prepare_enable and clk_disable_unprepare

 drivers/usb/dwc3/dwc3-exynos.c |   54 ++++++++++++++--------------------------
 1 files changed, 19 insertions(+), 35 deletions(-)

-- 
1.7.6.5

