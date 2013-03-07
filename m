Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab3CGCX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:23:28 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45594 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab3CGCX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:23:26 -0500
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, joe@perches.com
Cc: shangw@linux.vnet.ibm.com, linuxram@us.ibm.com,
        Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH 0/2] Some cleanup in driver core
Date: Thu,  7 Mar 2013 10:22:44 +0800
Message-Id: <1362622966-20003-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030702-5816-0000-0000-000006F88D07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches do some cleanup in the driver core.

They are tested on:
Hardware:       Lenovo T420
Kernel Version: 3.8
Result:
  * /sys/devices/pci0000:00/ directory is correct
  * /sys/devices/pci0000:00/0000:00:19.0/ contains the sysfs files for a pci
    device

Wei Yang (2):
  driver core: remove device_add_attrs() in drivers/base/bus.c
  driver-core: remove the duplicate assignment of kobj->parent in
    device_add

 drivers/base/bus.c     |   21 +--------------------
 drivers/base/core.c    |    6 ++----
 include/linux/device.h |    2 ++
 3 files changed, 5 insertions(+), 24 deletions(-)

-- 
1.7.5.4

