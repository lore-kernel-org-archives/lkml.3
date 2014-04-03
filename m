Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaDCM5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 08:57:11 -0400
Received: from 2.241-151-88.om-powered.net ([88.151.241.2]:40355 "EHLO
	zimbra.inuits.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaDCM5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 08:57:08 -0400
Date: Thu, 3 Apr 2014 14:56:55 +0200
From: Julien Pivotto <roidelapluie@inuits.eu>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com,
        linux-doc@vger.kernel.org
Subject: [PATCH v2] stable: Spelling s/than/then
Message-ID: <20140403125655.GA30846@tungsten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Julien Pivotto <roidelapluie@inuits.eu>
---
 Documentation/stable_kernel_rules.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index b0714d8..33e1b2c 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -39,7 +39,7 @@ Procedure for submitting patches to the -stable tree:
    the stable tree without anything else needing to be done by the author
    or subsystem maintainer.
  - If the patch requires other patches as prerequisites which can be
-   cherry-picked than this can be specified in the following format in
+   cherry-picked then this can be specified in the following format in
    the sign-off area:
 
      Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched: Check for idle
-- 
1.9.0
