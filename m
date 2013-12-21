Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3LUK2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:28:09 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48620 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3LUK2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:28:07 -0500
Date: Sat, 21 Dec 2013 15:55:50 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        josh@joshtriplett.org
Subject: [PATCH 1/2] drivers: dgap: Include appropriate header file in
 dgap_parse.c
Message-ID: <20131221102550.GA3229@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file in dgap/dgap_parse.h in dgap_parse.c
because functions dgap_parsefile(), dgap_config_get_useintr(),
dgap_config_get_altpin(), dgap_find_config(),
dgap_config_get_number_of_ports(), dgap_create_config_string() and
dgap_get_config_letters() have their prototype declarations in the
header file.

This eliminates the following warnings in dgap_parse.c:
drivers/staging/dgap/dgap_parse.c:125:5: warning: no previous prototype for ‘dgap_parsefile’ [-Wmissing-prototypes]
drivers/staging/dgap/dgap_parse.c:1101:6: warning: no previous prototype for ‘dgap_config_get_useintr’ [-Wmissing-prototypes]
drivers/staging/dgap/dgap_parse.c:1128:6: warning: no previous prototype for ‘dgap_config_get_altpin’ [-Wmissing-prototypes]
drivers/staging/dgap/dgap_parse.c:1157:15: warning: no previous prototype for ‘dgap_find_config’ [-Wmissing-prototypes]
drivers/staging/dgap/dgap_parse.c:1223:6: warning: no previous prototype for ‘dgap_config_get_number_of_ports’ [-Wmissing-prototypes]
drivers/staging/dgap/dgap_parse.c:1252:7: warning: no previous prototype for ‘dgap_create_config_string’ [-Wmissing-prototypes]
drivers/staging/dgap/dgap_parse.c:1311:7: warning: no previous prototype for ‘dgap_get_config_letters’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/staging/dgap/dgap_parse.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/dgap/dgap_parse.c b/drivers/staging/dgap/dgap_parse.c
index ff9d194..36fd93d 100644
--- a/drivers/staging/dgap/dgap_parse.c
+++ b/drivers/staging/dgap/dgap_parse.c
@@ -42,6 +42,7 @@
 #include "dgap_types.h"
 #include "dgap_fep5.h"
 #include "dgap_driver.h"
+#include "dgap_parse.h"
 #include "dgap_conf.h"
 
 
-- 
1.7.9.5

