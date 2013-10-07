Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3JGG4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:56:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3JGG4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:56:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] driver core bus cleanup to use dev_groups
Date: Sun,  6 Oct 2013 23:55:39 -0700
Message-Id: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a series to start cleaning up the different bus code to not use
'dev_attr' and instead, use 'dev_groups' as dev_attr will be removed
soon.

greg k-h

---
 drivers/bcma/main.c                        |   23 ++++++---
 drivers/hsi/hsi.c                          |   10 ++-
 drivers/mmc/core/bus.c                     |   12 ++--
 drivers/mmc/core/sdio_bus.c                |   21 ++++----
 drivers/net/phy/mdio_bus.c                 |   10 ++-
 drivers/pci/pci-driver.c                   |    2 
 drivers/pci/pci-sysfs.c                    |   73 ++++++++++++++++++-----------
 drivers/pci/pci.h                          |    2 
 drivers/pcmcia/ds.c                        |   65 +++++++++++++++----------
 drivers/pnp/base.h                         |    2 
 drivers/pnp/driver.c                       |    2 
 drivers/pnp/interface.c                    |   43 ++++++++++-------
 drivers/rapidio/rio-driver.c               |    2 
 drivers/rapidio/rio-sysfs.c                |   38 +++++++++------
 drivers/rapidio/rio.h                      |    2 
 drivers/ssb/main.c                         |   25 +++++----
 drivers/uwb/umc-bus.c                      |   13 +++--
 drivers/xen/xenbus/xenbus_probe.c          |   24 +++++++--
 drivers/xen/xenbus/xenbus_probe.h          |    2 
 drivers/xen/xenbus/xenbus_probe_backend.c  |    2 
 drivers/xen/xenbus/xenbus_probe_frontend.c |    2 
 21 files changed, 231 insertions(+), 144 deletions(-)


