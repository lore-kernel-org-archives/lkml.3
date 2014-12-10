Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbaLJP6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:58:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:25936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634AbaLJP6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:58:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="496704444"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 0/4] PM fixes for kxcjk-1013
Date: Wed, 10 Dec 2014 18:23:50 +0200
Message-Id: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a small set of power manangement fixes for kxcjk-1013 accel driver,
mostly related to error handling.

Jonathan, you mentioned that you applied the first 2 patches from this series
to the togreg branch, but I cannot find them there or on the testing branch.
I have included them in v2, but they are identical to those in the first version.

Changes since v1:
 - always set power state to off in case of i2c error (patch 3)
 - patches 3 and 4 reviewed by Srinivas

Irina Tirdea (4):
  iio: accel: kxcjk-1013: always power on device in resume
  iio: accel: kxcjk-1013: only set power state if CONFIG_PM is defined
  iio: accel: kxcjk-1013: error handling when set mode fails
  iio: accel: kxcjk-1013: power off device if probe fails

 drivers/iio/accel/kxcjk-1013.c |   38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

-- 
1.7.9.5

