Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaLWM3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:29:35 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:36336 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaLWM3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:29:34 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>
Subject: [PATCH 0/3] MIPS: OCTEON: flash: syncronize bootbus access
Date: Tue, 23 Dec 2014 15:26:58 +0300
Message-ID: <1419337623-16101-1-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use semaphore to protect access to bootbus.  
- Use device tree to probe for flash chips.

David Daney (3):
  MIPS: OCTEON: Add semaphore to serialize bootbus accesses.
  MIPS: OCTEON: Protect accesses to bootbus flash with
    octeon_bootbus_sem.
  MIPS: OCTEON: Use device tree to probe for flash chips.

 arch/mips/Kconfig                     |  1 +
 arch/mips/cavium-octeon/flash_setup.c | 84 ++++++++++++++++++++++++++++++++---
 arch/mips/cavium-octeon/setup.c       |  3 ++
 arch/mips/include/asm/octeon/octeon.h |  2 +
 4 files changed, 84 insertions(+), 6 deletions(-)

-- 
2.1.3

