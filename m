Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbaISVuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:50:04 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:56642 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaISVuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:50:01 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Subject: [PATCH] usb: dwc2: add T: line to MAINTAINERS showing Felipe's tree
Date: Fri, 19 Sep 2014 14:49:36 -0700
Message-Id: <1411163376-1375-1-git-send-email-paulz@synopsys.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with v3.18-rc, patches for dwc2 will go through Felipe's
tree. Add a T: line to MAINTAINERS to document this.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 809ecd6..bffd59c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2848,6 +2848,7 @@ F:	drivers/platform/x86/dell-wmi.c
 DESIGNWARE USB2 DRD IP DRIVER
 M:	Paul Zimmerman <paulz@synopsys.com>
 L:	linux-usb@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
 S:	Maintained
 F:	drivers/usb/dwc2/
 
-- 
2.1.0.24.g4109c28

