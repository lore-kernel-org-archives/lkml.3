Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaGKOGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:06:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49236 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGKOFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:46 -0400
X-AuditID: cbfee61a-f79e46d00000134f-c9-53bfef384597
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v4 19/21] of: Add Skyworks Solutions, Inc. vendor prefix
Date: Fri, 11 Jul 2014 16:04:22 +0200
Message-id: <1405087464-13762-20-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jQV2L9/uDDXru8ltsnLGe1WL+kXOs
	Fv1vFrJanHu1ktGi9+pzRouzTW/YLS7vmsNmsfXNOkaLng1bWS2WXr/IZDFh+loWi9a9R9gd
	eDzWzFvD6HG5r5fJY+XyL2wem1Z1snn0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxq1rm5kK
	1nBUfF1V2MA4g72LkYNDQsBE4vMbuy5GTiBTTOLCvfVsXYxcHEIC0xklPu67xgrhtDNJLFt8
	kB2kik3AUOLni9dMILaIQLlEz/tnYB3MAouZJKb2vGADSQgL+Eh8vvwVrIhFQFViyew7bCDb
	eAU8Jdb0yUAsVpCYM8kGpIITKHqw/yZYp5CAh8TDtSfYJzDyLmBkWMUomlqQXFCclJ5rqFec
	mFtcmpeul5yfu4kRHIzPpHYwrmywOMQowMGoxMOrsH5fsBBrYllxZe4hRgkOZiUR3qtv9gcL
	8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRqYFz/rIuvw2it
	3NePV3zfi/NU3nkQuW+powtbRbwW7xexX3IZd+Zev/SncvMjlprjq9au+Vpr7VQf3r7G4+u5
	qKLglV8n+uzaJXT/lHRCfOucys/bdFdM+jFx2cRoh5SJesHtK69sD9V3+bH8Dv9NfwnHuR09
	34Tz1C3eXxa7IPT3s5WUT11+6D8lluKMREMt5qLiRAAVPKQHQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "skyworks" as the vendor prefix for the
Skyworks Solutions, Inc.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 5d27e5a..8d0df4e 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -113,6 +113,7 @@ renesas	Renesas Electronics Corporation
 ricoh	Ricoh Co. Ltd.
 rockchip	Fuzhou Rockchip Electronics Co., Ltd
 samsung	Samsung Semiconductor
+skyworks	Skyworks Solutions, Inc.
 sbs	Smart Battery System
 schindler	Schindler
 seagate	Seagate Technology PLC
-- 
1.7.9.5

