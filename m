Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbbAHSIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:08:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:39444 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbbAHSIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:08:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="438119388"
Date: Fri, 9 Jan 2015 02:07:53 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: kbuild-all@01.org, Lars Poeschel <poeschel@lemonage.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH wsa] i2c: viperboard: vprbrd_quirks can be static
Message-ID: <20150108180753.GA9361@lkp-sb04>
References: <201501090239.gPJgrJIE%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501090239.gPJgrJIE%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/i2c/busses/i2c-viperboard.c:357:27: sparse: symbol 'vprbrd_quirks' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 i2c-viperboard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-viperboard.c b/drivers/i2c/busses/i2c-viperboard.c
index f880f08..47e88ad 100644
--- a/drivers/i2c/busses/i2c-viperboard.c
+++ b/drivers/i2c/busses/i2c-viperboard.c
@@ -354,7 +354,7 @@ static const struct i2c_algorithm vprbrd_algorithm = {
 	.functionality	= vprbrd_i2c_func,
 };
 
-struct i2c_adapter_quirks vprbrd_quirks = {
+static struct i2c_adapter_quirks vprbrd_quirks = {
 	.max_read_len = 2048,
 	.max_write_len = 2048,
 };
