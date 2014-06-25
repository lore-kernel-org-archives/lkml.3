Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbaFYQW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:22:58 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:59370 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbaFYQW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:22:56 -0400
From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: haver@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH 0/4] GenWQE: patches to improve RAS features (v2)
Date: Wed, 25 Jun 2014 13:22:03 -0300
Message-Id: <1403713327-27976-1-git-send-email-klebers@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062516-1798-0000-0000-000002FA4AA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sending a v2 of this patch series, removing the patch that bumps the
driver version number, and including a trivial one that removes an unnecessary
include.

Kleber Sacilotto de Souza (4):
  GenWQE: Add sysfs interface for bitstream reload
  GenWQE: Add support for EEH error recovery
  GenWQE: Improve hardware error recovery
  GenWQE: Remove unecessary include

 Documentation/ABI/testing/sysfs-driver-genwqe |    9 +
 drivers/misc/genwqe/Kconfig                   |    6 +
 drivers/misc/genwqe/card_base.c               |  215 +++++++++++++++++++++++--
 drivers/misc/genwqe/card_base.h               |    2 +
 drivers/misc/genwqe/card_ddcb.c               |   24 +++-
 drivers/misc/genwqe/card_debugfs.c            |    7 +
 drivers/misc/genwqe/card_dev.c                |    5 +
 drivers/misc/genwqe/card_sysfs.c              |   25 +++
 drivers/misc/genwqe/card_utils.c              |   10 ++
 include/uapi/linux/genwqe/genwqe_card.h       |    1 +
 10 files changed, 285 insertions(+), 19 deletions(-)

