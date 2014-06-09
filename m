Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbaFIPzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:55:54 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:47920 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933356AbaFIPzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:55:50 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: trivial@kernel.org, "GitAuthor: Pranith Kumar" <bobby.prani@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/6] update reference, kerneltrap.org no longer works
Date: Mon,  9 Jun 2014 11:55:23 -0400
Message-Id: <1402329327-6766-3-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402329327-6766-1-git-send-email-bobby.prani@gmail.com>
References: <1402329327-6766-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kerneltrap.org no longer works, update to a working reference

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/security/LSM.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/security/LSM.txt b/Documentation/security/LSM.txt
index c335a76..3db7e67 100644
--- a/Documentation/security/LSM.txt
+++ b/Documentation/security/LSM.txt
@@ -22,7 +22,7 @@ system, building their checks on top of the defined capability hooks.
 For more details on capabilities, see capabilities(7) in the Linux
 man-pages project.
 
-Based on http://kerneltrap.org/Linux/Documenting_Security_Module_Intent,
+Based on https://lkml.org/lkml/2007/10/26/215,
 a new LSM is accepted into the kernel when its intent (a description of
 what it tries to protect against and in what cases one would expect to
 use it) has been appropriately documented in Documentation/security/.
-- 
1.9.1

