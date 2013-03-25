Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3CYCgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 22:36:54 -0400
Received: from intranet.asianux.com ([58.214.24.6]:59006 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3CYCgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 22:36:53 -0400
X-Spam-Score: -100.8
Message-ID: <514FB826.9020302@asianux.com>
Date: Mon, 25 Mar 2013 10:36:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "nico@linaro.org" <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] include/linux/platform_data: beautify code, 'inline' is better
 in front of 'void'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  better to let 'inline' in front of 'void'

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/platform_data/usb-ohci-s3c2410.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/platform_data/usb-ohci-s3c2410.h b/include/linux/platform_data/usb-ohci-s3c2410.h
index 7fa1fbe..cc7554a 100644
--- a/include/linux/platform_data/usb-ohci-s3c2410.h
+++ b/include/linux/platform_data/usb-ohci-s3c2410.h
@@ -31,7 +31,7 @@ struct s3c2410_hcd_info {
 	void		(*report_oc)(struct s3c2410_hcd_info *, int ports);
 };
 
-static void inline s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)
+static inline void s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)
 {
 	if (info->report_oc != NULL) {
 		(info->report_oc)(info, ports);
-- 
1.7.7.6
