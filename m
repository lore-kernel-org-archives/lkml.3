Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaENFyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:54:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29840 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaENFym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:54:42 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-30-537305202e47
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, arnd@arndb.de, t.figa@samsung.com, pullip.cho@samsung.com,
        shaik.samsung@gmail.com, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH] documentation/iommu: Add note on existing DT binding status
Date: Wed, 14 May 2014 11:23:33 +0530
Message-id: <1400046813-15248-1-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkTleBtTjYYO0scYu/k46xW8w/co7V
	YsF+a4vO2RvYLTY9vsZqcXnXHDaLGef3MVn86z3IaHHk4W52i3U7J7FbrJ/xmsWB2+PJwXlM
	Hr9/TWL02DnrLrvH5iX1HpNvLGf06NuyitHj8ya5APYoLpuU1JzMstQifbsEroy23yEFjzkr
	1i7tYmxgnMfRxcjJISFgItHcfYMJwhaTuHBvPVsXIxeHkMBSRonj628xdzFygBU1XKqAiE9n
	lJh2ay0rhDOBSWJV7xJmkG42AUOJ7feugCVEBFYzSvRdPMMO4jALTGOUOH/gCRtIlbCAj8TS
	BbsYQWwWAVWJC8+OsXQxsnPwCrhLvLaCWKYgMWeSDUinhMAmdom5x46wQlQLSHybfIgFokZW
	YtMBZoijJSUOrrjBMoFRcAEjwypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwFA//e9Z7w7G
	2wesDzEmA42byCwlmpwPjJW8knhDYzMjC1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5akZqemFqQW
	xReV5qQWH2Jk4uCUamBk3cZefSRtglr0khPXeGqSWC7v2WZ98bnfjZb/5+8osL+Pd5mu88Fh
	1Zst+bcv8Rx6mJ62UD62ZPVj7aKwr4vn3G4NDizUKnHfnLqITfj+1lj5ow8WzuTdnRuVud6q
	Y59/W3BimkM7YzFDSpZWcYXu/qX/q1qLoiNXbG5gWZJudtP7gl+dsokSS3FGoqEWc1FxIgAv
	x7xMiwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jQV0F1uJgg1U7eS3+TjrGbjH/yDlW
	iwX7rS06Z29gt9j0+BqrxeVdc9gsZpzfx2Txr/cgo8WRh7vZLdbtnMRusX7GaxYHbo8nB+cx
	efz+NYnRY+esu+wem5fUe0y+sZzRo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8
	g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BuVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jBmtP0OKXjMWbF2aRdjA+M8ji5GDg4JAROJhksVXYycQKaYxIV769m6
	GLk4hASmM0pMu7WWFcKZwCSxqncJM0gVm4ChxPZ7V8ASIgKrGSX6Lp5hB3GYBaYxSpw/8IQN
	pEpYwEdi6YJdjCA2i4CqxIVnx1i6GNk5eAXcJV5bQSxWkJgzyWYCI/cCRoZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGMGR9Ex6B+OqBotDjAIcjEo8vDeci4KFWBPLiitzDzFKcDArifCW
	bwEK8aYkVlalFuXHF5XmpBYfYkwGWj2RWUo0OR8Y5Xkl8YbGJuamxqaWJhYmZpakCSuJ8x5s
	tQ4UEkhPLEnNTk0tSC2C2cLEwSnVwNh/5ElQ5cIZC01rc/UkbMP+cX08eq7kg4hlrFie680v
	12cpNAvNqG/sM5mUV+4gc2Thohl+BbLLmRVCzaxVU6Y9+bNZqPH579taxtfUDk55eTRlebv4
	C3629I+mK67bdZ9ZIXJcydvD7clszi/NWd6z7t/YxljpeXRrzzyfOY4zDN3+HogT+63EUpyR
	aKjFXFScCAD+y9qE6AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current dt binding for Exynos System MMU can be changed, if found
incompatible with the support for "Generic IOMMU Binding".
This patch adds a note to the binding documentation stating the same.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 .../devicetree/bindings/iommu/samsung,sysmmu.txt   |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
index 15b2a2b..6fa4c73 100644
--- a/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
+++ b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
@@ -27,6 +27,11 @@ The drivers must consider how to handle those System MMUs. One of the idea is
 to implement child devices or sub-devices which are the client devices of the
 System MMU.
 
+Note:
+The current DT binding for the Exynos System MMU is incomplete.
+The following properties can be removed or changed, if found incompatible with
+the "Generic IOMMU Binding" support for attaching devices to the IOMMU.
+
 Required properties:
 - compatible: Should be "samsung,exynos-sysmmu"
 - reg: A tuple of base address and size of System MMU registers.
-- 
1.7.9.5

