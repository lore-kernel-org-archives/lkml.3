Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaLWNVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:21:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:12998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbaLWNVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:21:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,632,1413270000"; 
   d="scan'208";a="652169836"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, knaack.h@gmx.de
Cc: lars@metafoo.de, pmeerw@pmeerw.net, daniel.baluta@intel.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.pandruvada@linux.intel.com
Subject: [PATCH 00/10] iio: KMX61 fixes
Date: Tue, 23 Dec 2014 15:22:23 +0200
Message-Id: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of cleanups after Hartmut's review:

	* http://marc.info/?l=linux-iio&m=141859700810393&w=2
	* http://marc.info/?l=linux-iio&m=141859774010580&w=2
	* http://marc.info/?l=linux-iio&m=141859828910703&w=2
	* http://marc.info/?l=linux-kernel&m=141868557909385&w=2

Daniel Baluta (10):
  iio: imu: kmx61: Save odr_bits for later use
  iio: imu: kmx61: Don't ignore kmx61_set_power_state errors
  iio: imu: kmx61: Enhance error handling
  iio: imu: kmx61: Fixup parameters alignment
  iio: imu: kmx61: Drop unused device parameter
  iio: imu: kmx61: Use false instead of 0 for ev_enable_state
  iio: imu: kmx61: Fix device initialization when setting trigger state
  iio: imu: kmx61: Remove unnecessary REG_INS1 read
  iio: imu: kmx61: Drop odr_bits from kmx61_samp_freq_table
  iio: imu: kmx61: Use correct base when reading data

 drivers/iio/imu/kmx61.c | 216 ++++++++++++++++++++++--------------------------
 1 file changed, 101 insertions(+), 115 deletions(-)

-- 
1.9.1

