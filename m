Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaFBXPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:15:08 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37022 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaFBXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:15:05 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        srinivas.pandruvada@linux.intel.com, linux-input@vger.kernel.org,
        jkosina@suse.cz
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCHv2 0/3] IIO: Add support for compass north usage attribute
Date: Mon,  2 Jun 2014 18:14:47 -0500
Message-Id: <1401750890-31854-1-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches allow the hid-sensor-magn-3d driver to handle
the north usage attribute. It allows the driver to dynamically
create IIO channels depending on which HID reports are found.

Reyad Attiyat (3):
  IIO: Documentation: Add north attribute to ABI docs
  IIO: Add iio_chan modifier for True/Magnetic North HID usages
  IIO: hid-sensor-magn-3d: Add in support for True/Magnetic North HID
    usages

 Documentation/ABI/testing/sysfs-bus-iio       |  76 ++++++++
 drivers/iio/industrialio-core.c               |   4 +
 drivers/iio/magnetometer/hid-sensor-magn-3d.c | 271 +++++++++++++++++---------
 include/linux/iio/types.h                     |   4 +
 4 files changed, 261 insertions(+), 94 deletions(-)

-- 
1.9.3

