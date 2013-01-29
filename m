Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3A2Wsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:48:41 -0500
Received: from mail-oa0-f73.google.com ([209.85.219.73]:42449 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3A2Wsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:48:39 -0500
Subject: [PATCH] MAINTAINERS: update SGI & ia64 Altix stuff
To: Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jes Sorensen <jes@trained-monkey.org>, Dimitri Sivanich <sivanich@sgi.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lori Gilbertson <loriann@sgi.com>, Robin Holt <holt@sgi.com>
Date: Tue, 29 Jan 2013 15:48:37 -0700
Message-ID: <20130129224837.7237.78495.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri and Robin have taken over GRU maintenance.

Linux on Altix is no longer maintained except as part of ia64, and
there's already a separate IA64 maintainer entry.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 MAINTAINERS |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa309ab..0526e21 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6768,7 +6768,8 @@ S:	Supported
 F:	drivers/net/ethernet/sfc/
 
 SGI GRU DRIVER
-M:	Jack Steiner <steiner@sgi.com>
+M:	Dimitri Sivanich <sivanich@sgi.com>
+M:	Robin Holt <holt@sgi.com>
 S:	Maintained
 F:	drivers/misc/sgi-gru/
 
@@ -6963,14 +6964,6 @@ L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/smscufx.c
 
-SN-IA64 (Itanium) SUB-PLATFORM
-M:	Jes Sorensen <jes@sgi.com>
-L:	linux-altix@sgi.com
-L:	linux-ia64@vger.kernel.org
-W:	http://www.sgi.com/altix
-S:	Maintained
-F:	arch/ia64/sn/
-
 SOC-CAMERA V4L2 SUBSYSTEM
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org

