Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3BBUqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 15:46:30 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:51703 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3BBUp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 15:45:58 -0500
From: Paul Sbarra <sbarra.paul@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Sbarra <sbarra.paul@gmail.com>
Subject: [PATCH 2/3] hid: Split accel, brake for Logitech Driving Force wheel
Date: Sat,  2 Feb 2013 14:45:24 -0600
Message-Id: <1359837925-6383-2-git-send-email-sbarra.paul@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359837925-6383-1-git-send-email-sbarra.paul@gmail.com>
References: <1359837925-6383-1-git-send-email-sbarra.paul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conflicts:
	drivers/hid/hid-lg.c

Signed-off-by: Paul Sbarra <sbarra.paul@gmail.com>
---
 drivers/hid/hid-lg.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 9312a62..4bc0e1b 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -79,7 +79,6 @@ static __u8 df_rdesc_fixed[] = {
 0x09, 0x01,         /*          Usage (?: 1),                   */
 0x81, 0x02,         /*          Input (Variable),               */
 0x05, 0x01,         /*          Usage Page (Desktop),           */
-0x09, 0x31,         /*          Usage (Y),                      */
 0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
 0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
 0x95, 0x01,         /*          Report Count (1),               */
@@ -99,11 +98,14 @@ static __u8 df_rdesc_fixed[] = {
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
1.8.1.1

