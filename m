Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaHEBsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:48:03 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:46877 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaHEBsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:48:00 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH v2 0/8] staging: iio: accel: Multiple coding style fixes
Date: Mon,  4 Aug 2014 22:46:55 -0300
Message-Id: <1407203223-9700-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1.204.gae8bc8d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix almost all warnings reported by
checkpatch.pl.

Changes from v1:
- Updated commit messages to better reflect changes.

Murilo Opsfelder Araujo (8):
  staging: iio: accel: adis16203_core.c: Add blank lines between
    declarations and code
  staging: iio: accel: adis16201_core.c: Add blank line between
    declarations and code
  staging: iio: accel: adis16204_core.c: Add blank line between
    declarations and code
  staging: iio: accel: adis16209_core.c: Add blank line between
    declarations and code
  staging: iio: accel: adis16240_core.c: Add blank line between
    declarations and code
  staging: iio: accel: lis3l02dq_core.c: Add blank lines between
    declarations and code
  staging: iio: accel: lis3l02dq_ring.c: Add blank line between
    declarations and code
  staging: iio: accel: sca3000_core.c: Add blank line between
    declarations and code

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
