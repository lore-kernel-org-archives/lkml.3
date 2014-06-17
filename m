Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaFQATZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:19:25 -0400
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:57274 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753004AbaFQATX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:19:23 -0400
From: Iyappan Subramanian <isubramanian@apm.com>
To: davem@davemloft.net, netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Iyappan Subramanian <isubramanian@apm.com>,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Subject: [PATCH v6 1/4] MAINTAINERS: Add entry for APM X-Gene SoC ethernet driver
Date: Mon, 16 Jun 2014 17:18:43 -0700
Message-Id: <1402964326-11147-2-git-send-email-isubramanian@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402964326-11147-1-git-send-email-isubramanian@apm.com>
References: <1402964326-11147-1-git-send-email-isubramanian@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a MAINTAINERS entry for APM X-Gene SoC
ethernet driver.

Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
Signed-off-by: Ravi Patel <rapatel@apm.com>
Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 134483f..d65a3be 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -700,6 +700,14 @@ S:	Maintained
 F:	drivers/net/appletalk/
 F:	net/appletalk/
 
+APPLIED MICRO (APM) X-GENE SOC ETHERNET DRIVER
+M:	Iyappan Subramanian <isubramanian@apm.com>
+M:	Keyur Chudgar <kchudgar@apm.com>
+M:	Ravi Patel <rapatel@apm.com>
+S:	Supported
+F:	drivers/net/ethernet/apm/xgene/
+F:	Documentation/devicetree/bindings/net/apm-xgene-enet.txt
+
 APTINA CAMERA SENSOR PLL
 M:	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
1.9.1

