Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3JHCRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:17:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3JHCRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:17:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] driver core bus cleanup to use dev_groups, round 2
Date: Mon,  7 Oct 2013 18:27:34 -0700
Message-Id: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is another series of patches to clean up the different bus code to
not use 'dev_attr' and instead, use 'dev_groups' as dev_attr will be
removed soon.

greg k-h

---
 drivers/ide/ide-sysfs.c           |   35 ++++++++++++++++++++++++++---------
 drivers/ide/ide.c                 |    2 +-
 drivers/input/gameport/gameport.c |   17 ++++++++++-------
 drivers/ipack/ipack.c             |   22 +++++++++++++++-------
 drivers/memstick/core/memstick.c  |   18 +++++++++---------
 drivers/message/i2o/core.h        |    2 +-
 drivers/message/i2o/device.c      |   32 +++++++++++++++++++++-----------
 drivers/message/i2o/driver.c      |    2 +-
 drivers/misc/tifm_core.c          |   10 ++++++----
 drivers/spi/spi.c                 |   10 ++++++----
 drivers/virtio/virtio.c           |   27 +++++++++++++++++++--------
 include/linux/ide.h               |    2 +-
 12 files changed, 116 insertions(+), 63 deletions(-)


