Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaBWXgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:36:18 -0500
Received: from www.prifuk.cz ([31.31.77.241]:41509 "EHLO prifuk.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaBWXgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:36:17 -0500
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        anssi.hannula@gmail.com, elias.vds@gmail.com, jkosina@suse.cz,
        simon@mungewell.org
Subject: [PATCH v2 4/4] hid-lg4ff: Add support for ramp effect
Date: Mon, 24 Feb 2014 00:36:15 +0100
Message-ID: <1470885.ADmv6FOjmm@geidi-prime>
User-Agent: KMail/4.12.2 (Linux/3.13.5-1-ARCHMOD; KDE/4.12.2; x86_64; ; )
In-Reply-To: <1516865.M993BQAYe4@geidi-prime>
References: <1516865.M993BQAYe4@geidi-prime>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid-lg4ff: Add support for ramp effect

Tested-by: Elias Vanderstuyft <elias.vds@gmail.com>
Signed-off-by: Michal Malý <madcatxster@prifuk.cz>
---
 drivers/hid/hid-lg4ff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index d7d8d83..e5c90bb 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -71,6 +71,7 @@ struct lg4ff_device_entry {
 
 static const signed short lg4ff_wheel_effects[] = {
 	FF_CONSTANT,
+	FF_RAMP,
 	FF_PERIODIC,
 	FF_SQUARE,
 	FF_TRIANGLE,
-- 
1.9.0


