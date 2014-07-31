Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaGaWgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:36:00 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:38727 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaGaWf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:35:59 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH 0/8] staging: iio: accel: multiple coding style fixes
Date: Thu, 31 Jul 2014 19:34:50 -0300
Message-Id: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix (almost) all warnings reported by
checkpatch.pl.

Murilo Opsfelder Araujo (8):
  staging: iio: accel: adis16203_core.c: fix coding style
  staging: iio: accel: adis16201_core.c: fix coding style
  staging: iio: accel: adis16204_core.c: fix coding style
  staging: iio: accel: adis16209_core.c: fix coding style
  staging: iio: accel: adis16240_core.c: fix coding style
  staging: iio: accel: lis3l02dq_core.c: fix coding style
  staging: iio: accel: lis3l02dq_ring.c: fix coding style
  staging: iio: accel: sca3000_core.c: fix coding style

 drivers/staging/iio/accel/adis16201_core.c |    5 +++--
 drivers/staging/iio/accel/adis16203_core.c |    2 ++
 drivers/staging/iio/accel/adis16204_core.c |    1 +
 drivers/staging/iio/accel/adis16209_core.c |    1 +
 drivers/staging/iio/accel/adis16240_core.c |    1 +
 drivers/staging/iio/accel/lis3l02dq_core.c |    4 ++++
 drivers/staging/iio/accel/lis3l02dq_ring.c |    1 +
 drivers/staging/iio/accel/sca3000_core.c   |    4 +++-
 8 files changed, 16 insertions(+), 3 deletions(-)

--
1.7.10.4
