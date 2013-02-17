Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab3BQRx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 12:53:27 -0500
Received: from mail-gh0-f173.google.com ([209.85.160.173]:61480 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3BQRxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 12:53:25 -0500
From: Paul Sbarra <sbarra.paul@gmail.com>
To: jkosina@suse.cz, simon@mungewell.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Sbarra <sbarra.paul@gmail.com>
Subject: [PATCH 2/2] hid: Split accel, brake for Logitech Driving Force wheel
Date: Sun, 17 Feb 2013 11:53:14 -0600
Message-Id: <1361123594-2813-2-git-send-email-sbarra.paul@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361123594-2813-1-git-send-email-sbarra.paul@gmail.com>
References: <1361123594-2813-1-git-send-email-sbarra.paul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Paul Sbarra <sbarra.paul@gmail.com>
---
 drivers/hid/hid-lg.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 6daa192..6bb7f05 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -81,7 +81,6 @@ static __u8 df_rdesc_fixed[] = {
 0x09, 0x01,         /*          Usage (?: 1),                   */
 0x81, 0x02,         /*          Input (Variable),               */
 0x05, 0x01,         /*          Usage Page (Desktop),           */
-0x09, 0x31,         /*          Usage (Y),                      */
 0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
 0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
 0x95, 0x01,         /*          Report Count (1),               */
@@ -101,11 +100,14 @@ static __u8 df_rdesc_fixed[] = {
 0x25, 0x01,         /*          Logical Maximum (1),            */
 0x45, 0x01,         /*          Physical Maximum (1),           */
 0x81, 0x02,         /*          Input (Variable),               */
-0x95, 0x02,         /*          Report Count (2),               */
+0x05, 0x01,         /*          Usage Page (Desktop),           */
+0x95, 0x01,         /*          Report Count (1),               */
 0x75, 0x08,         /*          Report Size (8),                */
 0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
 0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
-0x09, 0x02,         /*          Usage (?: 2),                   */
+0x09, 0x31,         /*          Usage (Y),                      */
+0x81, 0x02,         /*          Input (Variable),               */
+0x09, 0x35,         /*          Usage (Rz),                     */
 0x81, 0x02,         /*          Input (Variable),               */
 0xC0,               /*      End Collection,                     */
 0xA1, 0x02,         /*      Collection (Logical),               */
-- 
1.8.1.2

