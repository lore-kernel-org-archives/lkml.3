Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3FXGig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:38:36 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:56756 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3FXGie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:38:34 -0400
Subject: [PATCH v2] powerpc/pseries: Enable PSTORE in pseries_defconfig
To: linuxppc-dev@ozlabs.org, mikey@neuling.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: mahesh@linux.vnet.ibm.com, ananth@in.ibm.com
Date: Mon, 24 Jun 2013 12:08:19 +0530
Message-ID: <20130624063644.15559.68973.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062406-5140-0000-0000-0000036B96A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now we have pstore support for nvram in pseries, enable it
in the default config. With this config option enabled, pstore
infra-structure will be used to read/write the messages from/to nvram.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/configs/pseries_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index c4dfbaf..9630a50 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -347,3 +347,4 @@ CONFIG_VIRTUALIZATION=y
 CONFIG_KVM_BOOK3S_64=m
 CONFIG_KVM_BOOK3S_64_HV=y
 CONFIG_VHOST_NET=m
+CONFIG_PSTORE=y

