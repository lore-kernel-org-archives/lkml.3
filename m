Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbaFPWaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:30:18 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59365 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbaFPWaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:30:16 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        srinivas.pandruvada@linux.intel.com
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH v3 0/3] IIO: Add support for rotation from north usage attributes
Date: Mon, 16 Jun 2014 17:30:00 -0500
Message-Id: <1402957803-5154-1-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for rotation from north HID usage attributes to
the magnetometer 3d driver.

Changes from v2:
	Use devm_kcalloc for all dynamic allocations
	Cleanup formatting of if statements
	Scan for the usage attributes present then dynamically allocate iio channel and value arrays
	Use proper return errors (-EINVAL) and (-ENOMEM)


Reyad Attiyat (3):
  iio: documentation: Added documentation for rotation from north usage
    attributes
  iio: types: Added support for rotation from north usage attributes
  iio: hid-sensor-magn-3d: Add support for rotation from north usage
    attributes

 Documentation/ABI/testing/sysfs-bus-iio       |  79 +++++-
 drivers/iio/industrialio-core.c               |   4 +
 drivers/iio/magnetometer/hid-sensor-magn-3d.c | 394 +++++++++++++++++---------
 include/linux/iio/types.h                     |   4 +
 4 files changed, 352 insertions(+), 129 deletions(-)

-- 
1.9.3

