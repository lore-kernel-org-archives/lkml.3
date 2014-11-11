Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaKKTbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:31:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:43369 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbaKKTbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:31:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,362,1413270000"; 
   d="scan'208";a="635246166"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, IIO <linux-iio@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>, Lee Jones <lee.jones@linaro.org>
Cc: Carlo Caione <carlo@caione.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 3/3] iio/axp288_adc: remove THIS_MODULE owner
Date: Tue, 11 Nov 2014 11:30:10 -0800
Message-Id: <1415734210-5657-4-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415734210-5657-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1415734210-5657-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is no longer needed in that platform driver_register will do it.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/iio/adc/axp288_adc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
index 4a6cf43..08bcfb0 100644
--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -249,7 +249,6 @@ static struct platform_driver axp288_adc_driver = {
 	.id_table = axp288_adc_id_table,
 	.driver = {
 		.name = "axp288_adc",
-		.owner = THIS_MODULE,
 	},
 };
 
-- 
1.9.1

