Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaGCNKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:10:52 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40871 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaGCNKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:10:50 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-4f-53b556577224
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org (open list),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH 00/12] drm/exynos/ipp: image post processing improvements,
 part three
Date: Thu, 03 Jul 2014 15:10:25 +0200
Message-id: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xK7rhYVuDDfassLC4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mr48OQLc8E0joqd63MbGN+xdTFycEgImEhM7ijoYuQEMsUkLtxb
	DxTm4hASWMoo8fLWBxYIp49JYsaF/ywgVWwCmhJ/N99kA7FFBJQlVu1rZwcpYhb4yCRxZekb
	ZpCEsEC4xMq5Z8BsFgFVibN/FrGDbOMVcJZoPiYAsU1O4uSxyawTGLkXMDKsYhRNLU0uKE5K
	zzXUK07MLS7NS9dLzs/dxAgJkS87GBcfszrEKMDBqMTD27hiQ7AQa2JZcWXuIUYJDmYlEd6K
	4K3BQrwpiZVVqUX58UWlOanFhxiZODilGhgDDrqY3Z5jqWDGKbty7zsJT8+v7T2JGxM7A7Wn
	2E7/Uxsgc07jSKdypntm6flWBZNzb/gM2uq3HTIW0nXbm/vuiM5Z48B54gUmNs/uMBRvLvBc
	9Mw26fJrBTnBueo9LgK3rtrPv6Jze15wa7BhrZhlbb/Iqfvm9+23fF136WUPQ3kc5/tPskos
	xRmJhlrMRcWJACYcRrPvAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of independent patches contains various improvement and fixes
for exynos_drm ipp framework.
The patchset is based on exynos-drm-next branch.

Regards
Andrzej


Andrzej Hajda (12):
  drm/exynos/ipp: remove type casting
  drm/exynos/ipp: remove unused field from exynos_drm_ipp_private
  drm/exynos/ipp: remove struct exynos_drm_ipp_private
  drm/exynos/ipp: correct address type
  drm/exynos/ipp: remove temporary variable
  drm/exynos/ipp: remove incorrect checks of list_first_entry result
  drm/exynos/ipp: simplify memory check function
  drm/exynos/ipp: remove useless registration checks
  drm/exynos/ipp: simplify ipp_find_obj
  drm/exynos/ipp: remove redundant messages
  drm/exynos/ipp: simplify ipp_create_id
  drm/exynos/ipp: simplify ipp_find_driver

 drivers/gpu/drm/exynos/exynos_drm_drv.h |   7 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 259 +++++++++-----------------------
 drivers/gpu/drm/exynos/exynos_drm_ipp.h |   4 +-
 3 files changed, 73 insertions(+), 197 deletions(-)

-- 
1.9.1

