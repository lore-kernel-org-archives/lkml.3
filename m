Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaCXLLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:11:13 -0400
Received: from 2.241-151-88.om-powered.net ([88.151.241.2]:42038 "EHLO
	zimbra.inuits.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaCXLLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:11:11 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Mar 2014 07:11:11 EDT
Date: Mon, 24 Mar 2014 12:02:46 +0100
From: Julien Pivotto <roidelapluie@inuits.eu>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] stable: Spelling s/than/then
Message-ID: <20140324110246.GA16896@tungsten>
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
