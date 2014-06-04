Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaFDN7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:59:09 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:59482 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaFDN62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:58:28 -0400
From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: haver@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH 0/4] GenWQE: patches to improve RAS features
Date: Wed,  4 Jun 2014 10:57:49 -0300
Message-Id: <1401890273-13067-1-git-send-email-klebers@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060413-9564-0000-0000-000000FD1C62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a patch series for the IBM GenWQE driver to improve/implement RAS
features and increase the driver version number.


Kleber Sacilotto de Souza (4):
  GenWQE: Add sysfs interface for bitstream reload
  GenWQE: Add support for EEH error recovery
  GenWQE: Improve hardware error recovery
  GenWQE: Increase driver version number

 Documentation/ABI/testing/sysfs-driver-genwqe |    9 +
 drivers/misc/genwqe/Kconfig                   |    6 +
 drivers/misc/genwqe/card_base.c               |  214 +++++++++++++++++++++++--
 drivers/misc/genwqe/card_base.h               |    2 +
 drivers/misc/genwqe/card_ddcb.c               |   24 +++-
 drivers/misc/genwqe/card_debugfs.c            |    7 +
 drivers/misc/genwqe/card_dev.c                |    5 +
 drivers/misc/genwqe/card_sysfs.c              |   25 +++
 drivers/misc/genwqe/card_utils.c              |   10 ++
 drivers/misc/genwqe/genwqe_driver.h           |    2 +-
 include/uapi/linux/genwqe/genwqe_card.h       |    1 +
 11 files changed, 286 insertions(+), 19 deletions(-)

