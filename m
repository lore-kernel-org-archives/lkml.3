Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030627AbaLLQcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:32:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:59678 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934882AbaLLQcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:32:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="428257574"
Date: Sat, 13 Dec 2014 00:28:52 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Daniel Baluta <daniel.baluta@intel.com>
Cc: kbuild-all@01.org, Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH iio] iio: imu: kmx61: kmx61_set_wake_up_odr() can be static
Message-ID: <20141212162852.GA40238@snb.sh.intel.com>
References: <201412130004.58sFmPKu%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412130004.58sFmPKu%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/iio/imu/kmx61.c:422:5: sparse: symbol 'kmx61_set_wake_up_odr' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 kmx61.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index bda9c40..9b32f01 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -419,7 +419,7 @@ static int kmx61_get_mode(struct kmx61_data *data, u8 *mode, u8 device)
 	return 0;
 }
 
-int kmx61_set_wake_up_odr(struct kmx61_data *data, int val, int val2)
+static int kmx61_set_wake_up_odr(struct kmx61_data *data, int val, int val2)
 {
 	int ret, odr_bits;
 
