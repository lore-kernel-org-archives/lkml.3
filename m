Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaIPWen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:34:43 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:52936 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753268AbaIPWeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:34:23 -0400
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>
Cc: linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH v9 4/4] MAINTAINERS: entry for APM X-Gene PCIe host driver
Date: Tue, 16 Sep 2014 15:33:44 -0700
Message-Id: <1410906824-9321-5-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410906824-9321-1-git-send-email-tinamdar@apm.com>
References: <1410906824-9321-1-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entry for AppliedMicro X-Gene PCIe host driver.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e7866a..cd9bb3da 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6941,6 +6941,14 @@ L:	linux-pci@vger.kernel.org
 S:	Maintained
 F:	drivers/pci/host/*spear*
 
+PCI DRIVER FOR APPLIEDMICRO XGENE
+M:	Tanmay Inamdar <tinamdar@apm.com>
+L:	linux-pci@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/pci/xgene-pci.txt
+F:	drivers/pci/host/pci-xgene.c
+
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
-- 
1.9.1

