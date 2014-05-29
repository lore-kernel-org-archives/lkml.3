Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbaE2E7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:59:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036AbaE2EiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 3.10 11/86] ARM: multi_v7_defconfig: enable ARM_ATAG_DTB_COMPAT
Date: Wed, 28 May 2014 21:36:46 -0700
Message-Id: <20140529043515.026932952@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olof Johansson <olof@lixom.net>

commit a0396b9bd5a4a7baf598b60d2ca53c605c440a42 upstream.

Without this, legacy platforms that can boot with a multiplatform
kernel but that need the DTB to be appended, won't have a way to pass
firmware-set bootargs to the kernel.

This is needed to boot multi_v7_defconfig on snowball, for instance.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/configs/multi_v7_defconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -23,6 +23,7 @@ CONFIG_AEABI=y
 CONFIG_HIGHMEM=y
 CONFIG_HIGHPTE=y
 CONFIG_ARM_APPENDED_DTB=y
+CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_VFP=y
 CONFIG_NEON=y
 CONFIG_NET=y


