Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaHLNtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 09:49:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48444 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaHLNtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 09:49:51 -0400
From: "Hernandez, Carlos" <ceh@ti.com>
To: Punit Agrawal <punit.agrawal@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
CC: "orjan.eide@arm.com" <orjan.eide@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: RE: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
Thread-Topic: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
Thread-Index: AQHPs0En1NVHoxr1PUetR/0IWwXY3JvNAaPQ
Date: Tue, 12 Aug 2014 13:49:16 +0000
Message-ID: <32B5D12402BE454796026F6AC58AA86E32F2EFD6@DLEE08.ent.ti.com>
References: <1405692594-19352-1-git-send-email-punit.agrawal@arm.com>
 <1405692594-19352-2-git-send-email-punit.agrawal@arm.com>
In-Reply-To: <1405692594-19352-2-git-send-email-punit.agrawal@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7CDnvXU013975

Acked-By: Carlos Hernandez <ceh@ti.com>

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Punit Agrawal
Sent: Friday, July 18, 2014 10:10 AM
To: linux-pm@vger.kernel.org; linux-samsung-soc@vger.kernel.org
Cc: orjan.eide@arm.com; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; MyungJoo Ham; Kyungmin Park
Subject: [PATCH 1/2] PM / devfreq: Export helper functions for drivers

From: Ã˜rjan Eide <orjan.eide@arm.com>

These functions are indended for use by drivers and should be available also when the driver is built as a module.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Ã˜rjan Eide <orjan.eide@arm.com>
---
 drivers/devfreq/devfreq.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c index 9f90369..30b538d8 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1119,6 +1119,7 @@ struct dev_pm_opp *devfreq_recommended_opp(struct device *dev,
 
 	return opp;
 }
+EXPORT_SYMBOL(devfreq_recommended_opp);
 
 /**
  * devfreq_register_opp_notifier() - Helper function to get devfreq notified @@ -1142,6 +1143,7 @@ int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
 
 	return ret;
 }
+EXPORT_SYMBOL(devfreq_register_opp_notifier);
 
 /**
  * devfreq_unregister_opp_notifier() - Helper function to stop getting devfreq @@ -1168,6 +1170,7 @@ int devfreq_unregister_opp_notifier(struct device *dev, struct devfreq *devfreq)
 
 	return ret;
 }
+EXPORT_SYMBOL(devfreq_unregister_opp_notifier);
 
 static void devm_devfreq_opp_release(struct device *dev, void *res)  {
--
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
