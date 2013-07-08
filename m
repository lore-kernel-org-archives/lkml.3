Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3GHGES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 02:04:18 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57531 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3GHGER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 02:04:17 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: sfr@canb.auug.org.au, gregkh@linuxfoundation.org,
        David.Woodhouse@intel.com, artem.bityutskiy@linux.intel.com,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 0/3] cris: cleanup Kconfig files
Date: Mon,  8 Jul 2013 08:04:08 +0200
Message-Id: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches removes kernel configuration parameters for the
CRIS architecture, which are used nowhere in the kernel source
code and makefiles.

Michael Opdenacker (3):
  cris: cleanup arch-v10/drivers/Kconfig
  cris: cleanup arch-v32/drivers/Kconfig
  cris: cleanup Kconfig

 arch/cris/Kconfig                  |   9 --
 arch/cris/arch-v10/drivers/Kconfig |  79 ---------------
 arch/cris/arch-v32/drivers/Kconfig | 197 -------------------------------------
 3 files changed, 285 deletions(-)

-- 
1.8.1.2

