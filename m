Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab3IFQDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:03:08 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33658 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3IFQDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:03:07 -0400
From: Yi Li <yi.li@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-uefi-internal@linaro.org, yi.li@linaro.org
Subject: [PATCH] Add dmi driver support on arm
Date: Sat,  7 Sep 2013 00:02:50 +0800
Message-Id: <1378483371-19858-1-git-send-email-yi.li@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liyi <yi.li@linaro.org>

x86 and IA64 have the DMI support, which is useful for supporting
SMBIOS specification. All these SMBIOS tables will give the hardware
information for user or applications.

This patch depends on EFI runtime service function which
not yet upstreamed, it has been generated against the tag
leg-20130906.0 on git://git.linaro.org/people/graemegregory/linux.git."

liyi (1):
  ARM:DMI: Add dmi driver support on arm

 arch/arm/Kconfig           |    9 +++++++++
 arch/arm/include/asm/dmi.h |   12 ++++++++++++
 arch/arm/kernel/setup.c    |    7 ++++++-
 3 files changed, 27 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/asm/dmi.h

-- 
1.7.9.5

