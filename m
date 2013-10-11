Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab3JKTqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:46:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759118Ab3JKTmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>
Subject: [ 121/135] ARM: multi_v7_defconfig: enable ARM_ATAG_DTB_COMPAT
Date: Fri, 11 Oct 2013 12:40:02 -0700
Message-Id: <20131011193958.417946138@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olof Johansson <olof@lixom.net>

commit a0396b9bd5a4a7baf598b60d2ca53c605c440a42 upstream.

Without this, legacy platforms that can boot with a multiplatform
kernel but that need the DTB to be appended, won't have a way to pass
firmware-set bootargs to the kernel.

This is needed to boot multi_v7_defconfig on snowball, for instance.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/configs/multi_v7_defconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -46,6 +46,7 @@ CONFIG_ARCH_ZYNQ=y
 CONFIG_SMP=y
 CONFIG_HIGHPTE=y
 CONFIG_ARM_APPENDED_DTB=y
+CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_NET=y
 CONFIG_UNIX=y
 CONFIG_INET=y


