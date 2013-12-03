Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3LCMkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:40:37 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44043 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab3LCMkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:40:35 -0500
From: Mark Brown <broonie@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        virtualization@lists.linux-foundation.org,
        Mark Brown <broonie@linaro.org>
Date: Tue,  3 Dec 2013 12:40:21 +0000
Message-Id: <1386074421-20662-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.5
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] virtio: Update spec address
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

According to the README at the existing URL the spec has moved to github
so update the documentation to match.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 Documentation/devicetree/bindings/virtio/mmio.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/virtio/mmio.txt b/Documentation/devicetree/bindings/virtio/mmio.txt
index 5069c1b8e193..0648851d2a25 100644
--- a/Documentation/devicetree/bindings/virtio/mmio.txt
+++ b/Documentation/devicetree/bindings/virtio/mmio.txt
@@ -1,6 +1,6 @@
 * virtio memory mapped device
 
-See http://ozlabs.org/~rusty/virtio-spec/ for more details.
+See https://github.com/rustyrussell/virtio-spec for more details.
 
 Required properties:
 
-- 
1.8.5

