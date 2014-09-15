Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbaIOUeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:34:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbaIOTg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 020/114] regulator: arizona-ldo1: remove bypass functionality
Date: Mon, 15 Sep 2014 12:25:20 -0700
Message-Id: <20140915192642.057191438@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>

commit 5b919f3ebb533cbe400664837e24f66a0836b907 upstream.

WM5110/8280 devices do not support bypass mode for LDO1 so remove
the bypass callbacks registered with regulator core.

Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/arizona-ldo1.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -141,8 +141,6 @@ static struct regulator_ops arizona_ldo1
 	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
-	.get_bypass = regulator_get_bypass_regmap,
-	.set_bypass = regulator_set_bypass_regmap,
 };
 
 static const struct regulator_desc arizona_ldo1 = {


