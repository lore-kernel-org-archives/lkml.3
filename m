Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab3GIPsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:48:10 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:50709 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab3GIPsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:48:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v2 0/7] usb: phy: msm: Fixes and cleanups
Date: Tue,  9 Jul 2013 18:47:06 +0300
Message-Id: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Changes since first version.
* Extend commit messages a little bit.

Following patches make initial cleanup of usb phy found in the Qualcomm
chipsets. Changes include:
* Build time error fix.
* Move driver to Managed Device Resource allocation.
* Checkpatch warnings and error fixes
* Removed usage of global regulators variables.

Ivan T. Ivanov (7):
  usb: phy: msm: Move mach depndend code to platform data
  usb: phy: msm: Migrate to Managed Device Resource allocation
  usb: phy: msm: Move regulator usage to managed resource allocation
  usb: phy: msm: Remove unnecessarily check for valid regulators.
  usb: phy: msm: Fix WARNING: quoted string split across lines
  usb: phy: msm: Fix WARNING: Prefer seq_puts to seq_printf
  usb: phy: msm: Lindent the code

 arch/arm/mach-msm/board-msm7x30.c |   35 ++++
 arch/arm/mach-msm/board-qsd8x50.c |   34 ++++
 drivers/usb/phy/phy-msm-usb.c     |  384 ++++++++++++++-----------------------
 include/linux/usb/msm_hsusb.h     |    5 +
 4 files changed, 220 insertions(+), 238 deletions(-)

-- 
1.7.9.5

