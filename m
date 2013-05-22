Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3EVImb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:42:31 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:36178 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3EVIm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:42:29 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: greg@kroah.com, rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <PuZZleDucK@gmail.com>, Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH] Documentation: Updated broken link in HOWTO
Date: Wed, 22 May 2013 18:42:07 +1000
Message-Id: <1369212127-9199-1-git-send-email-PuZZleDucK@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated broken "The Perfect Patch" link in HOWTO to a copy at kerneltrap.org.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>

---
 Documentation/HOWTO | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index a9f288f..27faae3 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -112,7 +112,7 @@ required reading:
 
     Other excellent descriptions of how to create patches properly are:
 	"The Perfect Patch"
-		http://userweb.kernel.org/~akpm/stuff/tpp.txt
+		http://kerneltrap.org/node/3737
 	"Linux kernel patch submission format"
 		http://linux.yyz.us/patch-format.html
 
-- 
1.8.1.2

