Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaIMKsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 06:48:05 -0400
Received: from blu004-omc1s18.hotmail.com ([65.55.116.29]:60866 "EHLO
	BLU004-OMC1S18.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbaIMKsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 06:48:03 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Sep 2014 06:48:03 EDT
X-TMN: [1trCVBGPEUgKuRXWvoZZspIpzgluZYZd]
X-Originating-Email: [ashoekstra@hotmail.com]
Message-ID: <BLU436-SMTP235F3B35BD0E0D957564A34C0CA0@phx.gbl>
Date: Sat, 13 Sep 2014 12:42:43 +0200
From: Aede Symen <ashoekstra@hotmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH] staging: wlan-ng: fix coding style issues
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Sep 2014 10:42:54.0390 (UTC) FILETIME=[7969CD60:01CFCF3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limited a long line to 80 columns.

Signed-off-by: Aede Symen Hoekstra <ashoekstra@hotmail.com>
---
  drivers/staging/wlan-ng/prism2fw.c |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c 
b/drivers/staging/wlan-ng/prism2fw.c
index 6c38f79..8bd7c65 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -238,7 +238,8 @@ static int prism2_fwtry(struct usb_device *udev, 
wlandevice_t *wlandev)
  *	0	- success
  *	~0	- failure
  ----------------------------------------------------------------*/
-static int prism2_fwapply(const struct ihex_binrec *rfptr, wlandevice_t 
*wlandev)
+static int prism2_fwapply(const struct ihex_binrec *rfptr,
+	     wlandevice_t *wlandev)
  {
  	signed int result = 0;
  	struct p80211msg_dot11req_mibget getmsg;
-- 
1.7.9.5
