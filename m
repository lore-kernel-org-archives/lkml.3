Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbbAQHdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 02:33:33 -0500
Received: from m12-12.163.com ([220.181.12.12]:48471 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbbAQHdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 02:33:31 -0500
From: Yaowei Bai <bywxiaobai@163.com>
To: rjw@rjwysocki.net, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add the necessary '/' according to entry rules
Date: Sat, 17 Jan 2015 15:31:07 +0800
Message-Id: <1421479867-3550-1-git-send-email-bywxiaobai@163.com>
X-Mailer: git-send-email 1.9.1
X-CM-TRANSID: DMCowEDptEY3ELpUzekQAA--.666S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw45Xr13Kw48KrW8ur47CFg_yoWxCFX_uw
	1qqF4IqFW8Jr18A348XF97urWYka17WF1kWanxta15AFyxArZxtryqk3s3Za1UWr45urZr
	Was8JryIkF4ftjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0KNt7UUUUU==
X-Originating-IP: [58.208.67.66]
X-CM-SenderInfo: xe1z5x5dretxi6rwjhhfrp/1tbiuxyET1O-sg1SvAAAsR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3589d67..d46a77c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -270,12 +270,12 @@ F:	drivers/acpi/
 F:	drivers/pnp/pnpacpi/
 F:	include/linux/acpi.h
 F:	include/acpi/
-F:	Documentation/acpi
+F:	Documentation/acpi/
 F:	Documentation/ABI/testing/sysfs-bus-acpi
 F:	drivers/pci/*acpi*
 F:	drivers/pci/*/*acpi*
 F:	drivers/pci/*/*/*acpi*
-F:	tools/power/acpi
+F:	tools/power/acpi/
 
 ACPI COMPONENT ARCHITECTURE (ACPICA)
 M:	Robert Moore <robert.moore@intel.com>
-- 
1.9.1


