Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaBNOZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:25:52 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41725 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBNOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:25:48 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        jic23@kernel.org
Cc: pmeerw@pmeerw.net, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 2/2] Documentation: iio: Extend documentation for hmc5843 bindings.
Date: Fri, 14 Feb 2014 15:25:29 +0100
Message-Id: <1392387929-31491-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392387929-31491-1-git-send-email-marek@goldelico.com>
References: <1392387929-31491-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt b/Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt
index 90d5f34..b8cbdd5 100644
--- a/Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt
+++ b/Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt
@@ -3,6 +3,9 @@
 Required properties:
 
   - compatible : should be "honeywell,hmc5843"
+  Other models which are supported with driver are:
+	"honeywell,hmc5883"
+	"honeywell,hmc5883l"
   - reg : the I2C address of the magnetometer - typically 0x1e
 
 Optional properties:
-- 
1.8.3.2

