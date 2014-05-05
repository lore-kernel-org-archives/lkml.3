Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbaEELQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:16:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54738 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaEELQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:16:23 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-2e-53677305bf36
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 00/10] thermal: exynos: various cleanups
Date: Mon, 05 May 2014 13:15:29 +0200
Message-id: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e+xgC5rcXqwwdkTFhYNV0MsNs5Yz2qx
	Zv9PJouzTW/YLS7vmsNm8bn3CKPFjPP7mCzOnL7EavHkYR+bxfoZr1kcuDwW73nJ5LHlajuL
	R9+WVYwex29sZ/L4vEkugDWKyyYlNSezLLVI3y6BK+P3o7OMBQe5Kyb2LGFrYFzG2cXIySEh
	YCJx+8FDFghbTOLCvfVsXYxcHEICixglnv+dywThdDFJND7dwQRSxSZgJTGxfRUjiC0ioCdx
	48UTsCJmgeNMEj9/n2cDSQgLWEhc/nIKzGYRUJU4+OMbM4jNK+AucXVBN9Q6RYnuZxPYJjBy
	L2BkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHETPpHYwrmywOMQowMGoxMObwJweLMSa
	WFZcmXuIUYKDWUmENzsRKMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1oJBAemJJanZqakFq
	EUyWiYNTqoFx+UQtlfdcuVXP7h5d5R7GbK/wsTZzd7yQdMjSaw5bu3uC9kYH8WvNynOXvCOx
	6buVeYb5w85QJxWXswunVU7JV5r1ordSbt77NiuxHlvnL98nbDikEHrrnlxTvZxxdsHCHRuu
	nM3Vso5+8NHtVY+QUG3oBsf9L3bdXGpT8sXxZC3vNlGvyRJKLMUZiYZazEXFiQD5f5+CHgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series contains various cleanups for EXYNOS thermal
driver.  Overall it decreases driver's LOC by 13%.  It is based
on next-20140428 kernel.  It should not cause any functionality
changes.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (10):
  thermal: exynos: remove unused struct exynos_tmu_registers entries
  thermal: exynos: remove unused defines
  thermal: exynos: remove dead code for HW_MODE calibration
  thermal: exynos: remove dead code for TYPE_TWO_POINT_TRIMMING
    calibration
  thermal: exynos: remove redundant pdata checks from
    exynos_tmu_initialize()
  thermal: exynos: remove redundant threshold_code checks from
    exynos_tmu_initialize()
  thermal: exynos: simplify temp_to_code() and code_to_temp()
  thermal: exynos: cache non_hw_trigger_levels in pdata
  thermal: exynos: remove redundant pdata checks from
    exynos_tmu_control()
  thermal: exynos: remove identical values from exynos*_tmu_registers
    structures

 drivers/thermal/samsung/exynos_thermal_common.h |   1 -
 drivers/thermal/samsung/exynos_tmu.c            | 181 ++++--------------------
 drivers/thermal/samsung/exynos_tmu.h            |  86 +----------
 drivers/thermal/samsung/exynos_tmu_data.c       |  40 +-----
 drivers/thermal/samsung/exynos_tmu_data.h       |  32 +----
 5 files changed, 37 insertions(+), 303 deletions(-)

-- 
1.8.2.3

