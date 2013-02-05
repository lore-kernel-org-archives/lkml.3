Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3BEM5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:57:50 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:65480 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3BEM5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:57:48 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-c2-511101ca2b7f
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
        balbi@ti.com, grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH v3 0/2] ARM: Exynos5250: Enabling samsung usb phy
Date: Tue, 05 Feb 2013 18:33:52 +0530
Message-id: <1360069434-20417-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkSvcUo2Cgwa8zqhaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZdzZ1Mpe8I2j4ljTH+YGxjb2LkZODgkBE4nm
	NWtYIGwxiQv31rOB2EICSxklPs71galZseogYxcjF1B8OqPEs88vmCCcyUwS87+/BpvEJqAr
	0fR2FyOILSKgKvG5bQE7SBGzQAeTxPeJq8GKhAUcJRb9vQRmswAVzd/SxQRi8wp4SNw+c48J
	Yp2CxJvbz5hBmiUETrBJ/G+/zgTRICDxbfIhoFs5gBKyEpsOMEPUS0ocXHGDZQKj4AJGhlWM
	oqkFyQXFSem5RnrFibnFpXnpesn5uZsYgYF2+t8z6R2MqxosDjEKcDAq8fD+uMwfKMSaWFZc
	mXuIUYKDWUmEt/qLQKAQb0piZVVqUX58UWlOavEhxmSg5ROZpUST84FRkFcSb2hsYm5qbGpp
	ZGRmakqasJI4L+OpJwFCAumJJanZqakFqUUwW5g4OKUaGHMTJJpkv5Tov92l+NFQjNVYz+zq
	jvutzky1e/7dXq7i/LnW1Nn4o8MBB8P7/05suiy4vvPdPGlt+78fIu/EZ3N935Gmd+FudnSa
	ldKLDzbFddfEkudP3e493Sax93fgxzbGlHdSBYcmKzExXJzwhsNZZV9DVKdVsNH5F8lWoRIq
	SeUvdbiclFiKMxINtZiLihMBgjVrgXgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQd1TjIKBBq9WiFlc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxZ1Mr
	e8E3jopjTX+YGxjb2LsYOTkkBEwkVqw6yAhhi0lcuLeerYuRi0NIYDqjxLPPL5ggnMlMEvO/
	vwbrYBPQlWh6uwusQ0RAVeJz2wJ2kCJmgQ4mie8TV4MVCQs4Siz6ewnMZgEqmr+liwnE5hXw
	kLh95h4TxDoFiTe3nzFPYORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4kJ9J72Bc
	1WBxiFGAg1GJh/fHZf5AIdbEsuLK3EOMEhzMSiK81V8EAoV4UxIrq1KL8uOLSnNSiw8xJgNt
	n8gsJZqcD4yyvJJ4Q2MTc1NjU0sTCxMzS9KElcR5GU89CRASSE8sSc1OTS1ILYLZwsTBKdXA
	KC2yVULsuL/C8u7WxJMv417sW3txspCFTCXD7VsRr8xsJP7dtV16r33nyeP289V7t539JRRk
	+UBx7t/6ynf6Idtcmpfd63PQcfu2iJF7O9eP2Pfa26Z/v+215oTGEkHNAvm4wz6aoZ83Vr2M
	/xVdec3gs0L39ne6e7cZPb81tcT7w+Gfansb7iqxFGckGmoxFxUnAgCztdO1qAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on for-next of 'linux-samsung' tree.

Aligned with following patches for separate PHY drivers for USB 2.0 and
USB 3.0 for Samsung SoCs.
[PATCH v5 1/2] usb: phy: samsung: Common out the generic stuff
[PATCH v5 2/2] usb: phy: samsung: Add PHY support for USB 3.0 controller

Changes from v2:
 - Putting device nodes in order of device addresses.

Changes from v1:
 - Putting separate device nodes for usb 2.0 phy and usb 3.0 phy
   based on separate driver for samsung usb 3.0 phy and
   samsung usb 2.0 phy:
   [PATCH v3 0/2] Adding USB 3.0 DRD-phy support for exynos5250
   [PATCH v8 0/4] Adding usb2.0 host-phy support for exynos5250
 - Aligning as per the patch:
   usb: phy: samsung: Add support to set pmu isolation
 - Replaced phy-handle approach for PHY CONTROL registers
   to child nodes.
 - Removing AUX data entry from exynos5250 dt file.

Vivek Gautam (2):
  ARM: Exynos5250: Enabling samsung-usb2phy driver
  ARM: Exynos5250: Enabling samsung-usb3phy driver

 arch/arm/boot/dts/exynos5250.dtsi |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

-- 
1.7.6.5

