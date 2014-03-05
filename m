Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbaCEOYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:24:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40732 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaCEOYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ankur Raina <Ankur.Raina@kpitcummins.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 008/131] mfd: Update DA9055 i2c device id name
Date: Wed,  5 Mar 2014 14:22:12 +0000
Message-Id: <1394029455-23128-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankur Raina <Ankur.Raina@kpitcummins.com>

commit 1d057b853962a84a2c41a0a0a7fc15a631ac96e8 upstream.

DA9055 is a combination of pmic and codec. This patch updates the DA9055 i2c
device id name to match the standard naming convention followed for such chips.

Signed-off-by: Ankur Raina <Ankur.Raina@kpitcummins.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/da9055-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9055-i2c.c b/drivers/mfd/da9055-i2c.c
index 607387f..13af7e5 100644
--- a/drivers/mfd/da9055-i2c.c
+++ b/drivers/mfd/da9055-i2c.c
@@ -54,7 +54,7 @@ static int da9055_i2c_remove(struct i2c_client *i2c)
 }
 
 static struct i2c_device_id da9055_i2c_id[] = {
-	{"da9055-pmic", 0},
+	{"da9055", 0},
 	{ }
 };
 
-- 
1.9.0

