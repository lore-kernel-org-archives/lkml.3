Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaF1Uef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:34:35 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:32839 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbaF1Ued (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:34:33 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney.cavm@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 0/3] MIPS: OCTEON: Minimal support for D-Link DSR-1000N
Date: Sat, 28 Jun 2014 23:34:07 +0300
Message-Id: <1403987650-6194-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches add minimal support for D-Link DSR-1000N router.
USB and ethernet ports should now work with these patches.
(I guess WLAN (PCI/ath9k) should work too; I was able to scan networks,
but for some reason it did not connect to my AP.)

Aaro Koskinen (3):
  MIPS: OCTEON: cvmx-bootinfo: add D-Link DSR-1000N
  MIPS: OCTEON: add USB clock type for D-Link DSR-1000N
  MIPS: OCTEON: add interface & port definitions for D-Link DSR-1000N

 .../cavium-octeon/executive/cvmx-helper-board.c    | 22 ++++++++++++++++++++++
 arch/mips/include/asm/octeon/cvmx-bootinfo.h       |  2 ++
 2 files changed, 24 insertions(+)

-- 
2.0.0

