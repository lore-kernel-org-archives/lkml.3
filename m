Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaDFV3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 17:29:19 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:64752 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaDFV3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 17:29:15 -0400
Message-ID: <5341C729.30506@gmail.com>
Date: Sun, 06 Apr 2014 16:29:13 -0500
From: Joel Pelaez Jorge <joelpelaez@gmail.com>
Organization: DarkSoft Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Silvan Jegen <s.jegen@gmail.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: rtl8192e: Remove bad 'extern' declaration
References: <5341C643.4050700@gmail.com>
In-Reply-To: <5341C643.4050700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extern declaration to a static function:
iw_statistics *r8192_get_wireless_stats(struct net_device *dev);

Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
index 6a51a25..6437664 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
@@ -25,7 +25,6 @@ struct iw_handler_def;
 struct iw_statistics;

 extern struct iw_handler_def r8192_wx_handlers_def;
-struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev);
 u16 rtl8192_11n_user_show_rates(struct net_device *dev);

 #endif
-- 
1.9.1


