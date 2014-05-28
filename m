Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaE1VGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:06:25 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36378 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaE1VGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:06:23 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        srinivas.pandruvada@linux.intel.com, linux-input@vger.kernel.org,
        jkosina@suse.cz
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH 0/3] IIO: hid-sensor-magn-3d: Add support for compass north usage attribute
Date: Wed, 28 May 2014 16:06:12 -0500
Message-Id: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update hid-sensor-magn-3d to dynamically create IIO channels
Update IIO to include modifiers for true/magnetic north and
tilt compensation compass usages

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>


Reyad Attiyat (3):
  IIO: Added iio magn_north ABI documentation
  IIO: Add iio_chan modifier for True/Magnetic North HID usages
  IO: hid-sensor-magn-3d: Add in support for True/Magnetic North HID
    usages

 Documentation/ABI/testing/sysfs-bus-iio       |  76 +++++++
 drivers/iio/industrialio-core.c               |   4 +
 drivers/iio/magnetometer/hid-sensor-magn-3d.c | 278 +++++++++++++++++---------
 include/linux/iio/types.h                     |   4 +
 4 files changed, 267 insertions(+), 95 deletions(-)

-- 
1.9.3

