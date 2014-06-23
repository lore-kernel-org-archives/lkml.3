Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaFWRZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:25:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38912 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaFWRZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:25:05 -0400
From: Dave Chiluk <chiluk@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, davem@davemloft.net
Cc: Dave Chiluk <chiluk@canonical.com>
Subject: [PATCH v2] stable_kernel_rules: Add pointer to netdev-FAQ for network patches
Date: Mon, 23 Jun 2014 12:24:40 -0500
Message-Id: <1403544280-21182-1-git-send-email-chiluk@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403541530.15811.1.camel@joe-AO725>
References: <1403541530.15811.1.camel@joe-AO725>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stable_kernel_rules should point submitters of network stable patches to the
netdev_FAQ.txt as requests for stable network patches should go to netdev
first.

Signed-off-by: Dave Chiluk <chiluk@canonical.com>
---
 Documentation/stable_kernel_rules.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index cbc2f03..a39a0d7 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -29,6 +29,9 @@ Rules on what kind of patches are accepted, and which ones are not, into the
 
 Procedure for submitting patches to the -stable tree:
 
+ - If the patch covers files in net/ or drivers/net please follow netdev stable
+   sumissision guidelines as described in
+   Documentation/networking/netdev-FAQ.txt
  - Send the patch, after verifying that it follows the above rules, to
    stable@vger.kernel.org.  You must note the upstream commit ID in the
    changelog of your submission, as well as the kernel version you wish
-- 
1.9.1

