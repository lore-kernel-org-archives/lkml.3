Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaKHRZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 12:25:54 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37891 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaKHRZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 12:25:52 -0500
From: Darshana Padmadas <darshanapadmadas@gmail.com>
To: devicetree@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        opw-kernel@googlegroups.com,
        Darshana Padmadas <darshanapadmadas@gmail.com>
Subject: [PATCH v5 2/4] dt-bindings: Document deprecated device vendor name to fix related warning
Date: Sat,  8 Nov 2014 22:52:06 +0530
Message-Id: <1415467328-9745-3-git-send-email-darshanapadmadas@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415467328-9745-1-git-send-email-darshanapadmadas@gmail.com>
References: <1415467328-9745-1-git-send-email-darshanapadmadas@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents deprecated vendor name "isil" to fix warning of
undocumented string for device isl29028 as reported while running checkpatch.pl
on drivers/staging/iio/light/isl29028.c. This is done to maintain compatibility
with older kernels.

Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index ac7269f..ab97459 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -68,6 +68,7 @@ img	Imagination Technologies Ltd.
 intel	Intel Corporation
 intercontrol	Inter Control Group
 isee	ISEE 2007 S.L.
+isil    Intersil (deprecated, use isl)
 isl	Intersil
 karo	Ka-Ro electronics GmbH
 keymile	Keymile GmbH
-- 
1.9.1

