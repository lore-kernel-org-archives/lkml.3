Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbaHGFKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:10:54 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46673 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaHGFKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:10:51 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com, max@vozeler.com,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 1/3] usbip: move usbip userspace code out of staging
Date: Thu,  7 Aug 2014 08:10:27 +0300
Message-Id: <1407388229-31807-3-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
References: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point, USB/IP userspace code is fully functional
and can be moved out of staging.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 {drivers/staging/usbip/userspace => tools/usb/usbip}/.gitignore           | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/AUTHORS              | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/COPYING              | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/INSTALL              | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/Makefile.am          | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/README               | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/autogen.sh           | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/cleanup.sh           | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/configure.ac         | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/doc/usbip.8          | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/doc/usbipd.8         | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/Makefile.am   | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/list.h        | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/names.c       | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/names.h       | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/sysfs_utils.c | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/sysfs_utils.h | 0
 .../staging/usbip/userspace => tools/usb/usbip}/libsrc/usbip_common.c     | 0
 .../staging/usbip/userspace => tools/usb/usbip}/libsrc/usbip_common.h     | 0
 .../usbip/userspace => tools/usb/usbip}/libsrc/usbip_host_driver.c        | 0
 .../usbip/userspace => tools/usb/usbip}/libsrc/usbip_host_driver.h        | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/vhci_driver.c | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/vhci_driver.h | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/Makefile.am      | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip.c          | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip.h          | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_attach.c   | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_bind.c     | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_detach.c   | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_list.c     | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_network.c  | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_network.h  | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_port.c     | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_unbind.c   | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbipd.c         | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/utils.c          | 0
 {drivers/staging/usbip/userspace => tools/usb/usbip}/src/utils.h          | 0
 37 files changed, 0 insertions(+), 0 deletions(-)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/.gitignore (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/AUTHORS (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/COPYING (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/INSTALL (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/Makefile.am (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/README (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/autogen.sh (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/cleanup.sh (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/configure.ac (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/doc/usbip.8 (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/doc/usbipd.8 (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/Makefile.am (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/list.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/names.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/names.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/sysfs_utils.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/sysfs_utils.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/usbip_common.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/usbip_common.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/usbip_host_driver.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/usbip_host_driver.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/vhci_driver.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/vhci_driver.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/Makefile.am (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_attach.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_bind.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_detach.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_list.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_network.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_network.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_port.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_unbind.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbipd.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/utils.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/utils.h (100%)

diff --git a/drivers/staging/usbip/userspace/.gitignore b/tools/usb/usbip/.gitignore
similarity index 100%
rename from drivers/staging/usbip/userspace/.gitignore
rename to tools/usb/usbip/.gitignore
diff --git a/drivers/staging/usbip/userspace/AUTHORS b/tools/usb/usbip/AUTHORS
similarity index 100%
rename from drivers/staging/usbip/userspace/AUTHORS
rename to tools/usb/usbip/AUTHORS
diff --git a/drivers/staging/usbip/userspace/COPYING b/tools/usb/usbip/COPYING
similarity index 100%
rename from drivers/staging/usbip/userspace/COPYING
rename to tools/usb/usbip/COPYING
diff --git a/drivers/staging/usbip/userspace/INSTALL b/tools/usb/usbip/INSTALL
similarity index 100%
rename from drivers/staging/usbip/userspace/INSTALL
rename to tools/usb/usbip/INSTALL
diff --git a/drivers/staging/usbip/userspace/Makefile.am b/tools/usb/usbip/Makefile.am
similarity index 100%
rename from drivers/staging/usbip/userspace/Makefile.am
rename to tools/usb/usbip/Makefile.am
diff --git a/drivers/staging/usbip/userspace/README b/tools/usb/usbip/README
similarity index 100%
rename from drivers/staging/usbip/userspace/README
rename to tools/usb/usbip/README
diff --git a/drivers/staging/usbip/userspace/autogen.sh b/tools/usb/usbip/autogen.sh
similarity index 100%
rename from drivers/staging/usbip/userspace/autogen.sh
rename to tools/usb/usbip/autogen.sh
diff --git a/drivers/staging/usbip/userspace/cleanup.sh b/tools/usb/usbip/cleanup.sh
similarity index 100%
rename from drivers/staging/usbip/userspace/cleanup.sh
rename to tools/usb/usbip/cleanup.sh
diff --git a/drivers/staging/usbip/userspace/configure.ac b/tools/usb/usbip/configure.ac
similarity index 100%
rename from drivers/staging/usbip/userspace/configure.ac
rename to tools/usb/usbip/configure.ac
diff --git a/drivers/staging/usbip/userspace/doc/usbip.8 b/tools/usb/usbip/doc/usbip.8
similarity index 100%
rename from drivers/staging/usbip/userspace/doc/usbip.8
rename to tools/usb/usbip/doc/usbip.8
diff --git a/drivers/staging/usbip/userspace/doc/usbipd.8 b/tools/usb/usbip/doc/usbipd.8
similarity index 100%
rename from drivers/staging/usbip/userspace/doc/usbipd.8
rename to tools/usb/usbip/doc/usbipd.8
diff --git a/drivers/staging/usbip/userspace/libsrc/Makefile.am b/tools/usb/usbip/libsrc/Makefile.am
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/Makefile.am
rename to tools/usb/usbip/libsrc/Makefile.am
diff --git a/drivers/staging/usbip/userspace/libsrc/list.h b/tools/usb/usbip/libsrc/list.h
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/list.h
rename to tools/usb/usbip/libsrc/list.h
diff --git a/drivers/staging/usbip/userspace/libsrc/names.c b/tools/usb/usbip/libsrc/names.c
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/names.c
rename to tools/usb/usbip/libsrc/names.c
diff --git a/drivers/staging/usbip/userspace/libsrc/names.h b/tools/usb/usbip/libsrc/names.h
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/names.h
rename to tools/usb/usbip/libsrc/names.h
diff --git a/drivers/staging/usbip/userspace/libsrc/sysfs_utils.c b/tools/usb/usbip/libsrc/sysfs_utils.c
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
rename to tools/usb/usbip/libsrc/sysfs_utils.c
diff --git a/drivers/staging/usbip/userspace/libsrc/sysfs_utils.h b/tools/usb/usbip/libsrc/sysfs_utils.h
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/sysfs_utils.h
rename to tools/usb/usbip/libsrc/sysfs_utils.h
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/tools/usb/usbip/libsrc/usbip_common.c
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/usbip_common.c
rename to tools/usb/usbip/libsrc/usbip_common.c
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/tools/usb/usbip/libsrc/usbip_common.h
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/usbip_common.h
rename to tools/usb/usbip/libsrc/usbip_common.h
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/tools/usb/usbip/libsrc/usbip_host_driver.c
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
rename to tools/usb/usbip/libsrc/usbip_host_driver.c
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h b/tools/usb/usbip/libsrc/usbip_host_driver.h
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
rename to tools/usb/usbip/libsrc/usbip_host_driver.h
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/tools/usb/usbip/libsrc/vhci_driver.c
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/vhci_driver.c
rename to tools/usb/usbip/libsrc/vhci_driver.c
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/tools/usb/usbip/libsrc/vhci_driver.h
similarity index 100%
rename from drivers/staging/usbip/userspace/libsrc/vhci_driver.h
rename to tools/usb/usbip/libsrc/vhci_driver.h
diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/tools/usb/usbip/src/Makefile.am
similarity index 100%
rename from drivers/staging/usbip/userspace/src/Makefile.am
rename to tools/usb/usbip/src/Makefile.am
diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/tools/usb/usbip/src/usbip.c
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbip.c
rename to tools/usb/usbip/src/usbip.c
diff --git a/drivers/staging/usbip/userspace/src/usbip.h b/tools/usb/usbip/src/usbip.h
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbip.h
rename to tools/usb/usbip/src/usbip.h
diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/tools/usb/usbip/src/usbip_attach.c
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbip_attach.c
rename to tools/usb/usbip/src/usbip_attach.c
diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/tools/usb/usbip/src/usbip_bind.c
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbip_bind.c
rename to tools/usb/usbip/src/usbip_bind.c
diff --git a/drivers/staging/usbip/userspace/src/usbip_detach.c b/tools/usb/usbip/src/usbip_detach.c
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbip_detach.c
rename to tools/usb/usbip/src/usbip_detach.c
diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/tools/usb/usbip/src/usbip_list.c
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbip_list.c
rename to tools/usb/usbip/src/usbip_list.c
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/tools/usb/usbip/src/usbip_network.c
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbip_network.c
rename to tools/usb/usbip/src/usbip_network.c
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/tools/usb/usbip/src/usbip_network.h
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbip_network.h
rename to tools/usb/usbip/src/usbip_network.h
diff --git a/drivers/staging/usbip/userspace/src/usbip_port.c b/tools/usb/usbip/src/usbip_port.c
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbip_port.c
rename to tools/usb/usbip/src/usbip_port.c
diff --git a/drivers/staging/usbip/userspace/src/usbip_unbind.c b/tools/usb/usbip/src/usbip_unbind.c
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbip_unbind.c
rename to tools/usb/usbip/src/usbip_unbind.c
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/tools/usb/usbip/src/usbipd.c
similarity index 100%
rename from drivers/staging/usbip/userspace/src/usbipd.c
rename to tools/usb/usbip/src/usbipd.c
diff --git a/drivers/staging/usbip/userspace/src/utils.c b/tools/usb/usbip/src/utils.c
similarity index 100%
rename from drivers/staging/usbip/userspace/src/utils.c
rename to tools/usb/usbip/src/utils.c
diff --git a/drivers/staging/usbip/userspace/src/utils.h b/tools/usb/usbip/src/utils.h
similarity index 100%
rename from drivers/staging/usbip/userspace/src/utils.h
rename to tools/usb/usbip/src/utils.h
-- 
1.8.1.2

