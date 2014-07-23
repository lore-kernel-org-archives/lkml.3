Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973AbaGWWfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:35:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62387 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933689AbaGWWfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:35:37 -0400
From: Benoit Masson <yahoo@perenite.com>
To: benoitm@perenite.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jason@lakedaemon.net, andrew@lunn.ch, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com,
        Benoit Masson <yahoo@perenite.com>
Subject: [PATCH 1/2] Adding Lenovo - Lenovo Group Ltd. to the vendor-prefixes list.
Date: Wed, 23 Jul 2014 15:35:22 -0700
Message-Id: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lenovo Group Ltd. (stylized as lenovo) is a Chinese multinational computer technology company with headquarters in Beijing, China, and Morrisville, North Carolina, United States.

http://www.lenovo.com/
Signed-off-by: Benoit Masson <yahoo@perenite.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 46a311e..ae09892 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -71,6 +71,7 @@ karo	Ka-Ro electronics GmbH
 keymile	Keymile GmbH
 lacie	LaCie
 lantiq	Lantiq Semiconductor
+lenovo	Lenovo Group Ltd.
 lg	LG Corporation
 linux	Linux-specific binding
 lsi	LSI Corp. (LSI Logic)
-- 
1.9.1

