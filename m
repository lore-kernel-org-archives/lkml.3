Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbaIWCdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:33:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:37331 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147AbaIWCdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:33:42 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Chiluk <chiluk@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 01/45] stable_kernel_rules: Add pointer to netdev-FAQ for network patches
Date: Tue, 23 Sep 2014 10:31:03 +0800
Message-Id: <1411439507-30391-1-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chiluk <chiluk@canonical.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit b76fc285337b6b256e9ba20a40cfd043f70c27af upstream.

Stable_kernel_rules should point submitters of network stable patches to the
netdev_FAQ.txt as requests for stable network patches should go to netdev
first.

Signed-off-by: Dave Chiluk <chiluk@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 Documentation/stable_kernel_rules.txt |    3 +++
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
1.7.9.5

