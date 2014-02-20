Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaBTMkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:40:47 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15351 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaBTMkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:40:45 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-e7-5305f7cad8c9
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH v4 1/7 fixup] drivers: of: add initialization code for reserved
 memory (fixup)
Date: Thu, 20 Feb 2014 13:40:08 +0100
Message-id: <1392900008-8331-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392893567-31623-2-git-send-email-m.szyprowski@samsung.com>
References: <1392893567-31623-2-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRW0jTYQDF/fa/uhz8WxpfVmKLQKSWSg9fItJD0KeYCHajh9zSoYKbuqU2
	H0qH16XTVuQyr+gMxrwwNS8Z6Bw6DC1THGTaRSIvywsmpW2WzrdzDr/DeTgsIdST/myq4p5M
	qZCmiWg++XZ3dOrc2G8qPmRn6xBy60cYtK4pJNBaSxlA9bYJClU4Gyk06OoFyFleQqK+tlWA
	xjVOBvWUGhj0a/orD1kWZijUWNRMoqn+Ghq12uYY1LE0xENGxyQPNYwWUMhVFYDGHJs0Mtua
	GFRZ1Uqiwjc2Brl7LCRaHioiUbthhUSmfhdASxt28tIJbK4zA/x3Rw/wypNKgKd05TzcVz3H
	4DJnAYUtplIaf5oZoHFn80M8u7tA4Gm7hsJtrmUernCH4Np+HcC6LhPAm5aAuMO3+RFJsrTU
	bJnyfKSEn2J29RIZ3cz9wWexeeAprQXeLOQuwLHHbupAH4Xv59v3cj4r5IwAWkxfyAPziAeH
	Ol7x9imaC4Xan1pP25drBHCzzgMR3GcalkyWeaAjnAQaau0eiOTOQPvua8+EgLsCBw0OQgvY
	vblAWKOP2I+9uSi4WrHI7Gshh6F2sghUAkED8DIBP1lWYobqbrI8TKySylVZimRxYrrcAg5+
	3OoFxpFwK+BYIPIR3HKQ8UJKmq1Sy60AsoTIV9C1TsULBUlSda5MmZ6gzEqTqayAx3r754Hq
	7dydY5ezv0eFKT78ef4uMLHc8SCIrp4NJuWwMO64xG844Vv61XHtYlAODQJy6ltj6cz8s6a+
	l0RMib3l48boQnP3C2PwANhWq8MlIsu/ugm/a/O6GOn10yGdXj+abLS65I7hotiqsa6ZMyNP
	iqJv5g/f4KKLxafoBt9iHxGpSpGGBhNKlfQ/LRl1iqUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename 'align' property to 'alignment' to match documentation.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index cacf04810b87..49cf430a9e2a 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -112,10 +112,10 @@ __reserved_mem_alloc_size(unsigned long node, const char *uname,
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
 
-	prop = of_get_flat_dt_prop(node, "align", &len);
+	prop = of_get_flat_dt_prop(node, "alignment", &len);
 	if (prop) {
 		if (len != dt_root_addr_cells * sizeof(__be32)) {
-			pr_err("Reserved memory: invalid align property in '%s' node.\n",
+			pr_err("Reserved memory: invalid alignment property in '%s' node.\n",
 				uname);
 			return -EINVAL;
 		}
-- 
1.7.9.5

