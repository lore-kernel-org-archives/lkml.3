Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaC2SIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:08:45 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:42197 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaC2SIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:08:44 -0400
Message-ID: <53370C28.4020604@gmail.com>
Date: Sat, 29 Mar 2014 18:08:40 +0000
From: paulmcquad <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, jake.champlin.27@gmail.com
Subject: [PATCH] Staging: panel: Unnecessary space
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 411c46d97c06fba1e45312342fa1618eef8429cd Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Sat, 29 Mar 2014 18:01:19 +0000
Subject: [PATCH] Staging: panel: Unnecessary space

Removed space after function pointer name

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/panel/panel.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index ec4b1fd..35e00f0 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -171,8 +171,8 @@ struct logical_input {
 
     union {
         struct {    /* valid when type == INPUT_TYPE_STD */
-            void (*press_fct) (int);
-            void (*release_fct) (int);
+            void (*press_fct)(int);
+            void (*release_fct)(int);
             int press_data;
             int release_data;
         } std;
@@ -417,9 +417,9 @@ static char lcd_must_clear;
 static char lcd_left_shift;
 static char init_in_progress;
 
-static void (*lcd_write_cmd) (int);
-static void (*lcd_write_data) (int);
-static void (*lcd_clear_fast) (void);
+static void (*lcd_write_cmd)(int);
+static void (*lcd_write_data)(int);
+static void (*lcd_clear_fast)(void);
 
 static DEFINE_SPINLOCK(pprt_lock);
 static struct timer_list scan_timer;
@@ -2017,9 +2017,9 @@ static struct logical_input *panel_bind_key(const char *name, const char *press,
  * be bound.
  */
 static struct logical_input *panel_bind_callback(char *name,
-                         void (*press_fct) (int),
+                         void (*press_fct)(int),
                          int press_data,
-                         void (*release_fct) (int),
+                         void (*release_fct)(int),
                          int release_data)
 {
     struct logical_input *callback;
-- 
1.8.3.2

