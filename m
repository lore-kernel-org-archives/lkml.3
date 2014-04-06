Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaDFSXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 14:23:19 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:33851 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaDFSXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 14:23:17 -0400
Message-ID: <53419B93.8060806@gmail.com>
Date: Sun, 06 Apr 2014 13:23:15 -0500
From: Joel Pelaez Jorge <joelpelaez@gmail.com>
Organization: DarkSoft Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Silvan Jegen <s.jegen@gmail.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8192e: Fix sparse warning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/rtl8192e/rtl8192e/rtl_wx.c:1323:24: warning:
symbol 'r8192_wx_handlers_def' was not declared. Should it be static

Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
---
  drivers/staging/rtl8192e/rtl8192e/rtl_wx.c |    2 ++
  1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c 
b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
index 498995d..5baa699 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -20,6 +20,8 @@
  #include <linux/string.h>
  #include "rtl_core.h"

+extern struct iw_handler_def r8192_wx_handlers_def;
+
  #define RATE_COUNT 12
  static u32 rtl8192_rates[] = {
  	1000000, 2000000, 5500000, 11000000, 6000000, 9000000, 12000000,
-- 
1.7.10.4
