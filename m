Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3GYI22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:28:28 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:45590 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3GYI2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:28:24 -0400
From: Frank Haverkamp <haver@vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
Subject: [RFC] [PATCH] Generic WorkQueue Engine (GenWQE) device driver
Date: Thu, 25 Jul 2013 10:28:16 +0200
Message-Id: <1374740897-20304-1-git-send-email-haver@vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072508-8372-0000-0000-000006AB9DEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GenWQE device is a PCIe card used to acclerate different tasks.
Since it is configurable it can be adjusted to different purposes.
Our initial task for the card is to do zlib style compression/decompression
RFC1950, RFC1951, and RFC1952 with help of hardware.

I kindly ask for your feedback on the code, such that I can do any
change which helps me to get it integrated smoothly.

---
Frank Haverkamp (1):
  Generic WorkQueue Engine (GenWQE) device driver

 drivers/misc/Kconfig                |    1 +
 drivers/misc/Makefile               |    1 +
 drivers/misc/genwqe/Kconfig         |   23 +
 drivers/misc/genwqe/Makefile        |    8 +
 drivers/misc/genwqe/card_base.c     | 1317 ++++++++++++++++++++++++++++
 drivers/misc/genwqe/card_base.h     |  515 +++++++++++
 drivers/misc/genwqe/card_ddcb.c     | 1380 ++++++++++++++++++++++++++++++
 drivers/misc/genwqe/card_ddcb.h     |  159 ++++
 drivers/misc/genwqe/card_dev.c      | 1614 +++++++++++++++++++++++++++++++++++
 drivers/misc/genwqe/card_sysfs.c    |  645 ++++++++++++++
 drivers/misc/genwqe/card_utils.c    | 1032 ++++++++++++++++++++++
 drivers/misc/genwqe/genwqe_driver.h |   83 ++
 include/linux/genwqe/genwqe_card.h  |  710 +++++++++++++++
 13 files changed, 7488 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/genwqe/Kconfig
 create mode 100644 drivers/misc/genwqe/Makefile
 create mode 100644 drivers/misc/genwqe/card_base.c
 create mode 100644 drivers/misc/genwqe/card_base.h
 create mode 100644 drivers/misc/genwqe/card_ddcb.c
 create mode 100644 drivers/misc/genwqe/card_ddcb.h
 create mode 100644 drivers/misc/genwqe/card_dev.c
 create mode 100644 drivers/misc/genwqe/card_sysfs.c
 create mode 100644 drivers/misc/genwqe/card_utils.c
 create mode 100644 drivers/misc/genwqe/genwqe_driver.h
 create mode 100644 include/linux/genwqe/genwqe_card.h

