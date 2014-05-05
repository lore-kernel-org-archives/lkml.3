Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaEEVsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:48:15 -0400
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:32985 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932148AbaEEVsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:48:11 -0400
From: Iyappan Subramanian <isubramanian@apm.com>
To: davem@davemloft.net, netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Iyappan Subramanian <isubramanian@apm.com>,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Subject: [PATCH v4 1/4] MAINTAINERS: Add entry for APM X-Gene SoC ethernet driver
Date: Mon,  5 May 2014 14:47:24 -0700
Message-Id: <1399326447-2329-2-git-send-email-isubramanian@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399326447-2329-1-git-send-email-isubramanian@apm.com>
References: <1399326447-2329-1-git-send-email-isubramanian@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a MAINTAINERS entry for APM X-Gene SoC
ethernet driver.

Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
Signed-off-by: Ravi Patel <rapatel@apm.com>
Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7bb7ead..02c737e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -686,6 +686,14 @@ S:	Maintained
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
1.7.9.5

