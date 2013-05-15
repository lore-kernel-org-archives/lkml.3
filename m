Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab3EOMya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:54:30 -0400
Received: from mailrelay02.solcon.nl ([212.45.32.108]:39040 "EHLO
	mailrelay02.solcon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3EOMy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:54:29 -0400
Message-ID: <5193857D.4060809@solcon.nl>
Date: Wed, 15 May 2013 14:54:21 +0200
From: Albert Pool <albertpool@solcon.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: larry.finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] rtlwifi: rtl8192cu: Add new USB ID
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the USB ID of the On Networks N300MA, clone of Netgear WNA3100M.

Signed-off-by: Albert Pool<albertpool@solcon.nl>
Reported-by: Ana Rey<Anazul77@hotmail.com>
---
  drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    1 +
  1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 23d640a..0b593de 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -349,6 +349,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
  	{RTL_USB_DEVICE(0x07aa, 0x0056, rtl92cu_hal_cfg)}, /*ATKK-Gemtek*/
  	{RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/
  	{RTL_USB_DEVICE(0x0846, 0x9021, rtl92cu_hal_cfg)}, /*Netgear-Sercomm*/
+	{RTL_USB_DEVICE(0x0846, 0xf001, rtl92cu_hal_cfg)}, /*Netgear-On Networks*/
  	{RTL_USB_DEVICE(0x0b05, 0x17ab, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
  	{RTL_USB_DEVICE(0x0bda, 0x8186, rtl92cu_hal_cfg)}, /*Realtek 92CE-VAU*/
  	{RTL_USB_DEVICE(0x0df6, 0x0061, rtl92cu_hal_cfg)}, /*Sitecom-Edimax*/
-- 
1.7.9.5

