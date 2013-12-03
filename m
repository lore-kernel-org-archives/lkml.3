Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3LCTrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:47:14 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:40804 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3LCTrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:47:05 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 0/2] MIPS/staging: Probe octeon-usb driver via device-tree
Date: Tue,  3 Dec 2013 11:46:50 -0800
Message-Id: <1386100012-6077-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Tested against both EdgeRouter LITE (no bootloader supplied device
tree), and ebb5610 (device tree supplied by bootloader).

The patch set is spread across both the MIPS and staging trees, so it
would be great if Ralf could merge at least the MIPS parts, if not
both parts.


David Daney (2):
  MIPS: OCTEON: Supply OCTEON+ USB nodes in internal device trees.
  staging: octeon-usb: Probe via device tree populated platform device.

 .../cavium-octeon/executive/cvmx-helper-board.c    |  27 ++
 arch/mips/cavium-octeon/octeon-platform.c          |  32 +++
 arch/mips/cavium-octeon/octeon_3xxx.dts            |  19 ++
 arch/mips/include/asm/octeon/cvmx-helper-board.h   |   9 +
 drivers/staging/octeon-usb/octeon-hcd.c            | 273 +++++++++------------
 5 files changed, 203 insertions(+), 157 deletions(-)

-- 
1.7.11.7

