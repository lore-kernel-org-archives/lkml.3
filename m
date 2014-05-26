Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaEZISU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:18:20 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29258 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaEZISS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:18:18 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-2c-5382f8b84533
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        YoungJun Cho <yj44.cho@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 0/9] drm/exynos/ipp: image post processing improvements,
 part deux
Date: Mon, 26 May 2014 10:17:14 +0200
Message-id: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t/xa7o7fjQFG9x5aG5xa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZvF3p2TGR24PO53H2fy6Nuy
	itHj8ya5AOYoLpuU1JzMstQifbsEroy5PZtZC1awV8xoPM3cwPiPtYuRg0NCwERizwSTLkZO
	IFNM4sK99WxdjFwcQgJLGSUWfu9mgnD6mCRaFv1iA6liE9CU+Lv5JpgtIqAs8XfiKkaQImaB
	GcwSl891sYMkhAVCJM4t+skIYrMIqEpMaGlgBtnGK+AscfSQBMQ2OYmTxyazTmDkXsDIsIpR
	NLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJFy+7mBceszqEKMAB6MSD++LvKZgIdbEsuLK3EOM
	EhzMSiK8zR+AQrwpiZVVqUX58UWlOanFhxiZODilGhjj4xRvX18zf/a6U1FZrRlFyxfeivoR
	o5p2VjhcYv1i2Y0pu1e8XfR/nQJvfEA163re/uhXDx7HlcclKZ7lDNucKCzJE/DjWsWB43rc
	/AYBivvFelYc+r/HJrm+8MZx2xkTNvabRU15bX03/PupK7obgv3beXqiVj1/c0aVIS7D/m8p
	g9Xy7HAlluKMREMt5qLiRAD0fTIW9QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the next part of ipp improvement patches, this time made
by YoungJun Cho, I am posting them as he is on leave.

The patchset is based on drm-exynos/exynos-drm-next branch.

Regards
Andrzej


Andrzej Hajda (1):
  drm/exynos: ipp: remove description of non-existing field

YoungJun Cho (8):
  drm/exynos: ipp: remove usless list_empty() functions
  drm/exynos: ipp: remove duplicated setting
  drm/exynos: ipp: rename cmd_lock to lock
  drm/exynos: ipp: add cmd_lock for cmd_list
  drm/exynos: ipp: add ipp_remove_id()
  drm/exynos: ipp: rearrange c_node->mem_lock using routines
  drm/exynos: ipp: rearrange c_node->event_lock using routine
  drm/exynos: ipp: update comment for struct drm_ipp_buf_info

 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 242 ++++++++++++++++----------------
 drivers/gpu/drm/exynos/exynos_drm_ipp.h |   9 +-
 2 files changed, 129 insertions(+), 122 deletions(-)

-- 
1.9.1

