Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaAOW7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:59:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:64518 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbaAOW7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:59:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,665,1384329600"; 
   d="scan'208";a="465793958"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/5] mei: add support for txe hw
Date: Thu, 16 Jan 2014 00:58:31 +0200
Message-Id: <1389826716-16956-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Trusted Execution Environment (TXE) hardware.


Tomas Winkler (5):
  mei: txe: add hw-txe-regs.h header file
  mei: txe: add hw-txe.h header file
  mei: txe: add hw-txe.c
  mei: txe: add pci-txe.c
  mei: txe: add Kbuild for TXE device

 drivers/misc/mei/Kconfig       |    9 +
 drivers/misc/mei/Makefile      |    6 +-
 drivers/misc/mei/hw-txe-regs.h |  294 +++++++++++
 drivers/misc/mei/hw-txe.c      | 1106 ++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/hw-txe.h      |   71 +++
 drivers/misc/mei/pci-txe.c     |  293 +++++++++++
 6 files changed, 1778 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/mei/hw-txe-regs.h
 create mode 100644 drivers/misc/mei/hw-txe.c
 create mode 100644 drivers/misc/mei/hw-txe.h
 create mode 100644 drivers/misc/mei/pci-txe.c

-- 
1.8.4.2

