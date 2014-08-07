Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaHGAXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 20:23:06 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:39346 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaHGAXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 20:23:03 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH v3 0/2] staging: iio: accel: Multiple coding style fixes
Date: Wed,  6 Aug 2014 21:22:07 -0300
Message-Id: <1407370929-26949-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1.204.gae8bc8d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix almost all warnings reported by
checkpatch.pl.

v2 -> v3 changes:
- Folded blank line patches into a single patch.
- Fit code in 80-chars limit and still be human-readable.

Murilo Opsfelder Araujo (2):
  staging: iio: accel: Add blank lines between declarations and code
  staging: iio: accel: sca3000_core.c: Adjust code to fit 80-chars limit

 drivers/staging/iio/accel/adis16201_core.c | 5 +++--
 drivers/staging/iio/accel/adis16203_core.c | 2 ++
 drivers/staging/iio/accel/adis16204_core.c | 1 +
 drivers/staging/iio/accel/adis16209_core.c | 1 +
 drivers/staging/iio/accel/adis16240_core.c | 1 +
 drivers/staging/iio/accel/lis3l02dq_core.c | 4 ++++
 drivers/staging/iio/accel/lis3l02dq_ring.c | 1 +
 drivers/staging/iio/accel/sca3000_core.c   | 4 +++-
 8 files changed, 16 insertions(+), 3 deletions(-)

--
2.1.0.rc1.204.gae8bc8d
