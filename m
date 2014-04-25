Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaDYKwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:52:53 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46296 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaDYKwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:52:49 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: wim@iguana.be, linux-watchdog@vger.kernel.org, thomas.mingarelli@hp.com,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] doc: watchdog: Add an usage note on hpwdt with hp-asrd
Date: Fri, 25 Apr 2014 19:52:29 +0900
Message-Id: <1398423149-5028-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0.38.g1697bf3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An agent software called hp-asrd from Hewlett Packard
updates same iLO watchdog timer as hpwdt does update.
So they can not be uses simultaneously.
Add this usage note in hpwdt.txt.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/watchdog/hpwdt.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/watchdog/hpwdt.txt b/Documentation/watchdog/hpwdt.txt
index 9488078..719c38d 100644
--- a/Documentation/watchdog/hpwdt.txt
+++ b/Documentation/watchdog/hpwdt.txt
@@ -89,7 +89,8 @@ Last reviewed: 06/02/2009
 
 	Hypertransport/CSI Error       31h
 
-
+hpwdt can not work as expected if hp-asrd is running simultaneously.
+Because both hpwdt and hp-asrd update same iLO watchdog timer.
 
  -- Tom Mingarelli
     (thomas.mingarelli@hp.com)
-- 
2.0.0.rc0.38.g1697bf3

