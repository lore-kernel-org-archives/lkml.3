Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaJGPTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:19:50 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36410 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaJGPTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:19:47 -0400
From: Darshana Padmadas <darshanapadmadas@gmail.com>
To: opw-kernel@googlegroups.com
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        linux-arm-kernel@lists.infradead.org, jic23@kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Darshana Padmadas <darshanapadmadas@gmail.com>
Subject: [PATCH v4 2/4] Documentation: devicetree: bindings: Document deprecated device vendor name to fix related warning
Date: Tue,  7 Oct 2014 20:49:27 +0530
Message-Id: <1412695169-22815-3-git-send-email-darshanapadmadas@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com>
References: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents deprecated vendor name of device isl29028 for compatibility with older kernels.

Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
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

