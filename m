Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaIWPok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:44:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294AbaIWPoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:44:38 -0400
From: Michal Marek <mmarek@suse.cz>
To: sfr@canb.auug.org.au, rdunlap@infradead.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: [PATCH 5/5] sparc: Set CONFIG_NET=y in defconfigs
Date: Tue, 23 Sep 2014 17:44:04 +0200
Message-Id: <1411487044-14071-5-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1411487044-14071-1-git-send-email-mmarek@suse.cz>
References: <54218AEF.5090200@suse.cz>
 <1411487044-14071-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5d6be6a5 ("scsi_netlink : Make SCSI_NETLINK dependent on NET
instead of selecting NET") removed what happened to be the only instance
of 'select NET'. Defconfigs that were relying on the select now lack
networking support.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/sparc/configs/sparc64_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 9d8521b..6b68f12 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -29,6 +29,7 @@ CONFIG_PCI=y
 CONFIG_PCI_MSI=y
 CONFIG_SUN_OPENPROMFS=m
 CONFIG_BINFMT_MISC=m
+CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_XFRM_USER=m
-- 
1.8.4.5

