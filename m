Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaAYVi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:38:56 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:42342 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaAYViz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:38:55 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Belisko <marek@goldelico.com>
Subject: [PATCH] of: add vendor prefix for Honeywell
Date: Sat, 25 Jan 2014 22:38:44 +0100
Message-Id: <1390685924-11877-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 3f900cd..b14c617 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -40,6 +40,7 @@ gmt	Global Mixed-mode Technology, Inc.
 gumstix	Gumstix, Inc.
 haoyu	Haoyu Microelectronic Co. Ltd.
 hisilicon	Hisilicon Limited.
+honeywell	Honeywell
 hp	Hewlett Packard
 ibm	International Business Machines (IBM)
 idt	Integrated Device Technologies, Inc.
-- 
1.8.3.2

