Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab3FZQd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:33:26 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64354 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FZQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:33:24 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] minor improvements for ACPI dock and acpiphp drivers
Date: Thu, 27 Jun 2013 00:30:52 +0800
Message-Id: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

This is an following up patchset of "[PATCH 0/3] ACPI / dock / PCI: Fix
problems with dock and PCI hotplug" with minor code cleanups and
refinements. It applies to
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next

Due to hardware resource limitation, I have only done compilation and
boot tests.

Jiang Liu (9):
  ACPI, DOCK: avoid initializing acpi_dock_notifier_list multiple times
  ACPI, DOCK: kill redundant spin lock in dock station object
  ACPI, DOCK: mark initialization functions with __init
  ACPI, DOCK: simplify implementation of dock_create_acpi_device()
  ACPI: introduce three helper functions
  ACPI: change acpi_[bay|dock]_match() in scan.c as global functions
  ACPI: simplify dock driver with new interfaces
  ACPI: simpilify scan.c with new interfaces
  ACPI: simplify acpiphp driver with new interfaces

 drivers/acpi/dock.c                | 152 ++++---------------------------
 drivers/acpi/scan.c                | 182 ++++++++++++-------------------------
 drivers/acpi/utils.c               |  72 +++++++++++++++
 drivers/pci/hotplug/acpiphp_glue.c |  30 ++----
 include/acpi/acpi_bus.h            |   8 ++
 5 files changed, 168 insertions(+), 276 deletions(-)

-- 
1.8.1.2

