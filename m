Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3KEED4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 23:03:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57082 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3KEEDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 23:03:55 -0500
Date: Mon, 4 Nov 2013 20:03:32 -0800
From: tip-bot for Chen Gang <tipbot@zytor.com>
Message-ID: <tip-7f71be4c9f9a334e7bd0adc66225db4eb88c3bc4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gang.chen@asianux.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gang.chen@asianux.com, tglx@linutronix.de
In-Reply-To: <52784DFF.8040004@asianux.com>
References: <52784DFF.8040004@asianux.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, defconfig:
  Add DEVTMPFS and DEVTMPFS_MOUNT to *86*_defconfig
Git-Commit-ID: 7f71be4c9f9a334e7bd0adc66225db4eb88c3bc4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 20:03:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f71be4c9f9a334e7bd0adc66225db4eb88c3bc4
Gitweb:     http://git.kernel.org/tip/7f71be4c9f9a334e7bd0adc66225db4eb88c3bc4
Author:     Chen Gang <gang.chen@asianux.com>
AuthorDate: Tue, 5 Nov 2013 09:46:39 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 4 Nov 2013 20:01:55 -0800

x86, defconfig: Add DEVTMPFS and DEVTMPFS_MOUNT to *86*_defconfig

The defconfig kernel can not run under neither fedora16 x86_64 laptop
nor fedora17 x86_64 pc. After enable DEVTMPFS* in x86_64_defconfig, it
will be OK.

DEVTMPFS* is only related with software, so for i386_defconfig may also
need them (at least, it has no negative effect for defconfig).

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Link: http://lkml.kernel.org/r/52784DFF.8040004@asianux.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/configs/i386_defconfig   | 2 ++
 arch/x86/configs/x86_64_defconfig | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 9444708..a7fef26 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -142,6 +142,8 @@ CONFIG_MAC80211=y
 CONFIG_MAC80211_LEDS=y
 CONFIG_RFKILL=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_DEBUG_DEVRES=y
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 671524d..c1119d4 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -141,6 +141,8 @@ CONFIG_MAC80211=y
 CONFIG_MAC80211_LEDS=y
 CONFIG_RFKILL=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_DEBUG_DEVRES=y
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
