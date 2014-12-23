Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaLWQcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:32:46 -0500
Received: from tex.lwn.net ([70.33.254.29]:51390 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293AbaLWQcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:32:22 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6/7] Docs: Mention device tree binding info
Date: Tue, 23 Dec 2014 09:32:06 -0700
Message-Id: <1419352327-4517-7-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419352327-4517-1-git-send-email-corbet@lwn.net>
References: <1419352327-4517-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/SubmittingPatches | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index e6cbe59d890f..1f4e8c8710a7 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -15,7 +15,8 @@ format.  For detailed information on how the kernel development process
 works, see Documentation/development-process.  Also, read
 Documentation/SubmitChecklist for a list of items to check before
 submitting code.  If you are submitting a driver, also read
-Documentation/SubmittingDrivers.
+Documentation/SubmittingDrivers; for device tree binding patches, read
+Documentation/devicetree/bindings/submitting-patches.txt.
 
 Many of these steps describe the default behavior of the git version
 control system; if you use git to prepare your patches, you'll find much
-- 
2.1.0

