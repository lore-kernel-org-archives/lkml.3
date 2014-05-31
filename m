Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaEaUaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 16:30:19 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:59109 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaEaUaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 16:30:17 -0400
Message-ID: <538A3BD7.7000607@gmail.com>
Date: Sat, 31 May 2014 23:30:15 +0300
From: Tair Rzayev <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: solo6x10: solo6x10-jpeg.h: Fix sparse warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make jpeg_dqt[][] static

Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
---
 drivers/staging/media/solo6x10/solo6x10-jpeg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-jpeg.h b/drivers/staging/media/solo6x10/solo6x10-jpeg.h
index c5218ce..9e41185 100644
--- a/drivers/staging/media/solo6x10/solo6x10-jpeg.h
+++ b/drivers/staging/media/solo6x10/solo6x10-jpeg.h
@@ -110,7 +110,7 @@ static const unsigned char jpeg_header[] = {
 /* This is the byte marker for the start of the DQT */
 #define DQT_START	17
 #define DQT_LEN		138
-const unsigned char jpeg_dqt[4][DQT_LEN] = {
+static const unsigned char jpeg_dqt[4][DQT_LEN] = {
 	{
 		0xff, 0xdb, 0x00, 0x43, 0x00,
 		0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07,
-- 
1.9.1
