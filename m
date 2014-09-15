Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbaIOXFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:05:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbaIOWNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chiluk <chiluk@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 069/187] stable_kernel_rules: Add pointer to netdev-FAQ for network patches
Date: Mon, 15 Sep 2014 15:07:59 -0700
Message-Id: <1410818997-9432-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chiluk <chiluk@canonical.com>

commit b76fc285337b6b256e9ba20a40cfd043f70c27af upstream.

Stable_kernel_rules should point submitters of network stable patches to the
netdev_FAQ.txt as requests for stable network patches should go to netdev
first.

Signed-off-by: Dave Chiluk <chiluk@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/stable_kernel_rules.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index b0714d8..8dfb6a5 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -29,6 +29,9 @@ Rules on what kind of patches are accepted, and which ones are not, into the
 
 Procedure for submitting patches to the -stable tree:
 
+ - If the patch covers files in net/ or drivers/net please follow netdev stable
+   submission guidelines as described in
+   Documentation/networking/netdev-FAQ.txt
  - Send the patch, after verifying that it follows the above rules, to
    stable@vger.kernel.org.  You must note the upstream commit ID in the
    changelog of your submission, as well as the kernel version you wish
-- 
1.9.1

