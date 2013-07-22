Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3GVAPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:15:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35658 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753054Ab3GVAPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:15:50 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/18] MAINTAINERS: Trivial pattern changes
Date: Sun, 21 Jul 2013 17:15:27 -0700
Message-Id: <cover.1374451988.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A collection of little tiny patches...

Joe Perches (18):
  MAINTAINERS: EXYNOS - Remove board files
  MAINTAINERS: ARM: OMAP2/3: Remove unused clockdomain files
  MAINTAINERS: OMAP POWERDOMAIN, update patterns
  MAINTAINERS: ARM: S3C2410: Update patterns
  MAINTAINERS: ARM: spear: Consolidate sections
  MAINTAINERS: ARM: plat-nomadik: Update patterns
  MAINTAINERS: ARM: S3C24XX: Remove plat-s3c24xx
  MAINTAINERS: ghes_edac: Update pattern
  MAINTAINERS: gpio: vt8500: Remove file pattern
  MAINTAINERS: Update SIANO drivers
  MAINTAINERS: SI4713: Fix file pattern
  MAINTAINERS: Update it913x patterns
  MAINTAINERS: Update sirf patterns
  MAINTAINERS: Update ssbi patterns
  MAINTAINERS: Update file pattern for ARC uart
  MAINTAINERS: Update USB EHCI platform pattern
  MAINTAINERS: usb: phy: Update patterns
  MAINTAINERS: Update GRE DEMUX patterns

 MAINTAINERS | 68 +++++++++++++++----------------------------------------------
 1 file changed, 16 insertions(+), 52 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

