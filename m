Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaGBOBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:01:16 -0400
Received: from w-smtp-out-7.wedos.net ([46.28.106.5]:49867 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753410AbaGBOBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:01:15 -0400
Date: Wed, 2 Jul 2014 15:48:41 +0200
From: Josef Gajdusek <atx@atalax.net>
To: linux-iio@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, jic23@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] staging:iio:hmc5843: Few adjustments and support for
 hmc5983
Message-ID: <20140702134840.GA15493@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series modifies the hmc5843 driver to support the hmc5983 i2c and
spi interfaces.

Josef Gajdusek (5):
  staging:iio:hmc5843: Added regmap support
  staging:iio:hmc5843: Split hmc5843.c to multiple files
  staging:iio:hmc5843: register <-> value arrays now can have different
    lengths
  staging:iio:hmc5843: Add support for i2c hmc5983
  staging:iio:hmc5843: Add support for spi hmc5983

 drivers/staging/iio/magnetometer/Kconfig        |  23 +-
 drivers/staging/iio/magnetometer/Makefile       |   4 +-
 drivers/staging/iio/magnetometer/hmc5843.c      | 652 ------------------------
 drivers/staging/iio/magnetometer/hmc5843.h      |  76 +++
 drivers/staging/iio/magnetometer/hmc5843_core.c | 624 +++++++++++++++++++++++
 drivers/staging/iio/magnetometer/hmc5843_i2c.c  | 107 ++++
 drivers/staging/iio/magnetometer/hmc5843_spi.c  | 105 ++++
 7 files changed, 935 insertions(+), 656 deletions(-)
 delete mode 100644 drivers/staging/iio/magnetometer/hmc5843.c
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843.h
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843_core.c
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843_i2c.c
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843_spi.c

-- 
1.8.5.5

