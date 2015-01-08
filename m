Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbbAHR6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:58:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:3517 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432AbbAHR6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:58:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,724,1413270000"; 
   d="scan'208";a="666582589"
Date: Fri, 9 Jan 2015 01:57:37 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: kbuild-all@01.org, Anders Berg <anders.berg@avagotech.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH wsa] i2c: axxia: axxia_i2c_quirks can be static
Message-ID: <20150108175737.GA33686@lkp-sb04>
References: <201501090118.jHaamxHl%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501090118.jHaamxHl%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/i2c/busses/i2c-axxia.c:452:27: sparse: symbol 'axxia_i2c_quirks' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 i2c-axxia.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-axxia.c b/drivers/i2c/busses/i2c-axxia.c
index 2d35476..488c5d3 100644
--- a/drivers/i2c/busses/i2c-axxia.c
+++ b/drivers/i2c/busses/i2c-axxia.c
@@ -449,7 +449,7 @@ static const struct i2c_algorithm axxia_i2c_algo = {
 	.functionality = axxia_i2c_func,
 };
 
-struct i2c_adapter_quirks axxia_i2c_quirks = {
+static struct i2c_adapter_quirks axxia_i2c_quirks = {
 	.max_read_len = 255,
 	.max_write_len = 255,
 };
