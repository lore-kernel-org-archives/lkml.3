Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab3G2HFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:05:35 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:60867 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab3G2HFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:05:33 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v2 0/6] usb: phy: msm: Fixes and cleanups
Date: Mon, 29 Jul 2013 10:04:18 +0300
Message-Id: <1375081464-14206-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

v2
--
* Fix compilation issue in patch 1
* Separate regulator changes
* Merge devm_ related changes to one commit
* Drop Lindent patch

v1
--
Following patches make initial cleanup of usb phy found in the Qualcomm
chipsets. Changes include:
* Build time error fix.
* Move driver to Managed Device Resource allocation.
* Checkpatch warnings and error fixes
* Removed usage of global regulators variables.

Ivan T. Ivanov (6):
  usb: phy: msm: Move mach depndend code to platform data
  usb: phy: msm: move global regulators variables to driver state
  usb: phy: msm: Migrate to Managed Device Resource allocation
  usb: phy: msm: Remove unnecessarily check for valid regulators.
  usb: phy: msm: Fix WARNING: quoted string split across lines
  usb: phy: msm: Fix WARNING: Prefer seq_puts to seq_printf

 arch/arm/mach-msm/board-msm7x30.c |   35 ++++
 arch/arm/mach-msm/board-qsd8x50.c |   35 ++++
 drivers/usb/phy/phy-msm-usb.c     |  342 +++++++++++++------------------------
 include/linux/usb/msm_hsusb.h     |    6 +
 4 files changed, 198 insertions(+), 220 deletions(-)

-- 
1.7.9.5

