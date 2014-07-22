Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbaGVWko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:40:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbaGVWZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:25:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        gaurav.minocha@alumni.ubc.ca, Ralf Baechle <ralf@linux-mips.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 029/116] MIPS: DTS: Fix missing device_type="memory" property in memory nodes
Date: Tue, 22 Jul 2014 15:20:40 -0700
Message-Id: <1406067727-19683-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leif Lindholm <leif.lindholm@linaro.org>

commit 1d530fa42a317deca1c4a4780d18e2dbf316e0cb upstream.

A few platforms lack a 'device_type = "memory"' for their memory
nodes, relying on an old ppc quirk in order to discover its memory.
Add the missing data so that all parsing code can find memory nodes
correctly.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: John Crispin <blogic@openwrt.org>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: linux-mips@linux-mips.org
Cc: devicetree@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: gaurav.minocha@alumni.ubc.ca
Patchwork: https://patchwork.linux-mips.org/patch/6989/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
[ kamal: backport to 3.8-stable: only lantiq/dts/easy50712.dts ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/mips/lantiq/dts/easy50712.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/lantiq/dts/easy50712.dts b/arch/mips/lantiq/dts/easy50712.dts
index 68c1731..de53a1b 100644
--- a/arch/mips/lantiq/dts/easy50712.dts
+++ b/arch/mips/lantiq/dts/easy50712.dts
@@ -8,6 +8,7 @@
 	};
 
 	memory@0 {
+		device_type = "memory";
 		reg = <0x0 0x2000000>;
 	};
 
-- 
1.9.1

