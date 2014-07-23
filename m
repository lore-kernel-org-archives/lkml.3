Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaGWMH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:07:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59433 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaGWMHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:07:54 -0400
From: benoitm974 <yahoo@perenite.com>
To: benoitm@perenite.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: benoitm974 <yahoo@perenite.com>
Subject: [PATCH 2/2] Adding lenovo in vendor
Date: Wed, 23 Jul 2014 05:07:12 -0700
Message-Id: <1406117232-5962-2-git-send-email-yahoo@perenite.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406117232-5962-1-git-send-email-yahoo@perenite.com>
References: <1406117232-5962-1-git-send-email-yahoo@perenite.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: benoitm974 <yahoo@perenite.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 46a311e..de81a87 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -72,6 +72,7 @@ keymile	Keymile GmbH
 lacie	LaCie
 lantiq	Lantiq Semiconductor
 lg	LG Corporation
+lenovo	LENOVO
 linux	Linux-specific binding
 lsi	LSI Corp. (LSI Logic)
 lltc	Linear Technology Corporation
-- 
1.9.1

