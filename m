Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3DCXfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 19:35:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53027 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3DCXfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 19:35:13 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Cc: arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 5/7] ARM: dt: add header to define GPIO flags
Date: Wed,  3 Apr 2013 17:34:56 -0600
Message-Id: <1365032098-22825-5-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365032098-22825-1-git-send-email-swarren@wwwdotorg.org>
References: <1365032098-22825-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Many GPIO device tree bindings use the same flags. Create a header to
define those.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: No change.
v1: Moved header. Added include guard.
    (this patch was previously posted separately, hence there are
    changes in v1!)
---
 include/dt-bindings/gpio/gpio.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 include/dt-bindings/gpio/gpio.h

diff --git a/include/dt-bindings/gpio/gpio.h b/include/dt-bindings/gpio/gpio.h
new file mode 100644
index 0000000..e6b1e0a
--- /dev/null
+++ b/include/dt-bindings/gpio/gpio.h
@@ -0,0 +1,15 @@
+/*
+ * This header provides constants for most GPIO bindings.
+ *
+ * Most GPIO bindings include a flags cell as part of the GPIO specifier.
+ * In most cases, the format of the flags cell uses the standard values
+ * defined in this header.
+ */
+
+#ifndef _DT_BINDINGS_GPIO_GPIO_H
+#define _DT_BINDINGS_GPIO_GPIO_H
+
+#define GPIO_ACTIVE_HIGH 0
+#define GPIO_ACTIVE_LOW 1
+
+#endif
-- 
1.7.10.4

