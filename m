Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3IJMu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:50:28 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:33622 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3IJMuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:25 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 38/38] iio: magn-core: st: Provide support for the LSM303DLH
Date: Tue, 10 Sep 2013 13:49:39 +0100
Message-Id: <1378817379-8238-39-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch adding the LSM303DLH to the list of already supported
Magnetometer Sensors.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/magnetometer/st_magn.h      | 1 +
 drivers/iio/magnetometer/st_magn_core.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/magnetometer/st_magn.h b/drivers/iio/magnetometer/st_magn.h
index f185720..19b53e3 100644
--- a/drivers/iio/magnetometer/st_magn.h
+++ b/drivers/iio/magnetometer/st_magn.h
@@ -15,6 +15,7 @@
 #include <linux/iio/common/st_sensors.h>
 
 #define LSM303DLHC_MAGN_DEV_NAME	"lsm303dlhc_magn"
+#define LSM303DLH_MAGN_DEV_NAME		"lsm303dlh_magn"
 #define LSM303DLM_MAGN_DEV_NAME		"lsm303dlm_magn"
 #define LIS3MDL_MAGN_DEV_NAME		"lis3mdl_magn"
 
diff --git a/drivers/iio/magnetometer/st_magn_core.c b/drivers/iio/magnetometer/st_magn_core.c
index 12e7e79..b2e2917 100644
--- a/drivers/iio/magnetometer/st_magn_core.c
+++ b/drivers/iio/magnetometer/st_magn_core.c
@@ -151,7 +151,8 @@ static const struct st_sensors st_magn_sensors[] = {
 		.wai = ST_MAGN_1_WAI_EXP,
 		.sensors_supported = {
 			[0] = LSM303DLHC_MAGN_DEV_NAME,
-			[1] = LSM303DLM_MAGN_DEV_NAME,
+			[1] = LSM303DLH_MAGN_DEV_NAME,
+			[0] = LSM303DLM_MAGN_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_magn_16bit_channels,
 		.odr = {
-- 
1.8.1.2

