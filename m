Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbaEaUeD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 16:34:03 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42251 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaEaUeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 16:34:01 -0400
Message-ID: <538A3CB7.2030007@gmail.com>
Date: Sat, 31 May 2014 23:33:59 +0300
From: Tair Rzayev <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wlan-ng: cfg80211.c: Fix sparse warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include necessary header files to avoid "should be static" sparse warning

Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
---
 drivers/staging/wlan-ng/cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index f76f95c..01be471 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -1,4 +1,6 @@
 /* cfg80211 Interface for prism2_usb module */
+#include "hfa384x.h"
+#include "prism2mgmt.h"
 
 
 /* Prism2 channel/frequency/bitrate declarations */
-- 
1.9.1

