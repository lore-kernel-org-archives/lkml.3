Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbbA0Sm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:42:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:64130 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbbA0Sm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:42:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,476,1418112000"; 
   d="scan'208";a="676894053"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v3 2/3] iio: Documentation: Fix calibheight unit
Date: Tue, 27 Jan 2015 20:41:53 +0200
Message-Id: <1422384114-23392-3-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422384114-23392-1-git-send-email-irina.tirdea@intel.com>
References: <1422384114-23392-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change calibheight unit from centimeters to meters
to follow iio guidelines of using SI units.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index b4ea9c5..588620e 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -347,7 +347,7 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_steps_calibheight
 KernelVersion:	3.19
 Contact:	linux-iio@vger.kernel.org
 Description:
-		Height of the user (in centimeters) used by some pedometers
+		Height of the user (in meters) used by some pedometers
 		to compute the stride length, distance, speed and activity
 		type.
 
-- 
1.9.1

