Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaJ0Js6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:48:58 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8635 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaJ0Js4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:48:56 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-16-544e1506574d
Content-transfer-encoding: 8BIT
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Thierry Reding <treding@nvidia.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/5] MAINTAINERS: Add entry for MIPI DSI bus
Date: Mon, 27 Oct 2014 10:48:26 +0100
Message-id: <1414403310-6316-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
References: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xq7pson4hBh8PaVrcWneO1eLK1/ds
	FpPuT2CxuLxrDpvF7d98Dqwe97uPM3n0Nr9j8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	D1PesxR8Zan4vb+NsYGxj6WLkYNDQsBEYtcrxi5GTiBTTOLCvfVsXYxcHEICSxklLh7dzQ6S
	4BUQlPgx+R5YPbOAvMSRS9kgYWYBdYlJ8xYxQ9T3MUlcen0ZbBCbgKbE38032UBsEQFlib8T
	VzGCFDELzGSU2PrlMitIQljARuLxnk9gC1gEVCUuzYSI8wo4SfTcWMkOcZGcxMljk8HinALO
	En+nfgcbKgRUc/zjOZYJjAKzkNw3C+G+WUjuW8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/
	dxMjJIS/7mBceszqEKMAB6MSD++EYt8QIdbEsuLK3EOMEhzMSiK8jj+BQrwpiZVVqUX58UWl
	OanFhxiZODilGhg5Fm7oN7dqi99suo2b7fKa39um7dGbFZj5N2e744rf9dMPnT4/eznvqbIZ
	/SqBjOGHPczMZq9e7n3vkExNxKSzMbeXek2auvxP1FztNFnrTyIpJhxNjEZH+4qu2C1oiza0
	MvLk4p27snvXareOaQsTttga/LH1nnuPt4BfNfGOuHzIyl8NxdeVWIozEg21mIuKEwFOHYOG
	PwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index dd31933..476679c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3071,6 +3071,13 @@ F:	drivers/gpu/vga/
 F:	include/drm/
 F:	include/uapi/drm/
 
+DRM MIPI DSI BUS
+M:	Andrzej Hajda <a.hajda@samsung.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Supported
+F:	drivers/gpu/drm/drm_mipi_dsi.c
+F:	include/drm/drm_mipi_dsi.h
+
 RADEON DRM DRIVERS
 M:	Alex Deucher <alexander.deucher@amd.com>
 M:	Christian König <christian.koenig@amd.com>
-- 
1.9.1

