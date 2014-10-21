Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaJUF6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:58:46 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44215 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbaJUF6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:58:44 -0400
From: Ankit Jindal <ankit.jindal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Ankit Jindal <ankit.jindal@linaro.org>
Subject: [PATCH v3 6/6] MAINTAINERS: Add entry for APM X-Gene QMTM UIO driver
Date: Tue, 21 Oct 2014 11:26:50 +0530
Message-Id: <1413871011-4101-7-git-send-email-ankit.jindal@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org>
References: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entry to maintainer list for APM X-Gene QMTM UIO driver.

Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e7866a..138663f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -727,6 +727,13 @@ S:	Supported
 F:	drivers/net/ethernet/apm/xgene/
 F:	Documentation/devicetree/bindings/net/apm-xgene-enet.txt
 
+APPLIED MICRO (APM) X-GENE QMTM UIO DRIVER
+M:	Ankit Jindal <ankit.jindal@linaro.org>
+M:	Tushar Jagad <tushar.jagad@linaro.org>
+S:	Supported
+F:	drivers/uio/uio_xgene_qmtm.c
+F:	Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
+
 APTINA CAMERA SENSOR PLL
 M:	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
1.7.9.5

