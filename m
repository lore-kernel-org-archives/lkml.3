Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab3EWMwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:52:19 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38872 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335Ab3EWMwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:52:16 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: greg@kroah.com, rob@landley.net
Cc: Ben Minerds <PuZZleDucK@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] Documentation: Updating a broken link in "the perfect patch"
Date: Thu, 23 May 2013 22:49:58 +1000
Message-Id: <95e6b8218195f2be60823ce6de5ea524b727fe11.1369312746.git.PuZZleDucK@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1369312746.git.PuZZleDucK@gmail.com>
References: <cover.1369312746.git.PuZZleDucK@gmail.com>
In-Reply-To: <cover.1369312746.git.PuZZleDucK@gmail.com>
References: <cover.1369312746.git.PuZZleDucK@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The link to Andrews patches were out of date. Replacing with new links. Also
 slightly reformatted to allow easier selection of links.

 Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 Documentation/development-process/patches/The-Perfect-Patch.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/development-process/patches/The-Perfect-Patch.txt b/Documentation/development-process/patches/The-Perfect-Patch.txt
index 217a303..63eccbb 100644
--- a/Documentation/development-process/patches/The-Perfect-Patch.txt
+++ b/Documentation/development-process/patches/The-Perfect-Patch.txt
@@ -160,8 +160,8 @@ Overall
 
 
 
-The patch management scripts at http://www.zip.com.au/~akpm/linux/patches/
-implement all of the above.
+The patch management scripts here implement all of the above:
+  https://www.kernel.org/pub/linux/kernel/people/akpm/patches/
 
-The patch management tools at https://savannah.nongnu.org/projects/quilt/ also
-implement all of the above.
\ No newline at end of file
+The patch management tools here implement all of the above:
+  https://savannah.nongnu.org/projects/quilt/
-- 
1.8.1.2

