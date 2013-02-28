Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3B1Qa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:30:57 -0500
Received: from mx2.promwad.com ([91.149.128.90]:39387 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab3B1Qay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:30:54 -0500
From: Kurachkin Michail <Michail.Kurachkin@promwad.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        "Viktar Palstsiuk" <Viktar.Palstsiuk@promwad.com>,
        Gorokh Dmitriy <Dmitriy.Gorokh@promwad.com>
Subject: [PATCH] staging: si3226x: TDM: add issues to TODO file
Thread-Topic: [PATCH] staging: si3226x: TDM: add issues to TODO file
Thread-Index: AQHOFdD5ie9iNhJ1Mk+hbImUJi/PTg==
Date: Thu, 28 Feb 2013 16:30:52 +0000
Message-ID: <F7F628C32E67B04DAECC5CA53521253E6AD1BA22@sv-exmb01-lo1.promwad.corp>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.10.99]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michail Kurachkin <michail.kurachkin@promwad.com>
---
 drivers/staging/si3226x/TODO |   20 +++++++++++++++++---
 drivers/staging/tdm/TODO     |   19 +++++++++++++++++++
 2 files changed, 36 insertions(+), 3 deletions(-)
 create mode 100644 drivers/staging/tdm/TODO

diff --git a/drivers/staging/si3226x/TODO b/drivers/staging/si3226x/TODO
index b2cb27e..e4c334a 100644
--- a/drivers/staging/si3226x/TODO
+++ b/drivers/staging/si3226x/TODO
@@ -1,8 +1,22 @@
+Mainteiners:
+Michail Kurachkin <Michail.Kurachkin@promwad.com> <stelhs@yandex.ru>
+Ivan Kuten <ivan.kuten@promwad.com>
+Promwad company <info@promwad.com>
+
+Reviwers:
+Oliver Neukum <oneukum@suse.de>
+Ryan Mallon <rmallon@gmail.com>
+Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+
+Needed to be done to get the code out of the staging tree:
 1) mutex_lock(&slic_chr_dev_lock);
 This locking is very heavy handed and should be reworked

-2) SLIC driver works unstable when compiled as module, loaded, then unloaded and finally reloaded again.
-
-3) Current version of Si3226x SLIC driver is limited. It implements only base functionality such as Answer, Hangup, receive DTMF, send DTMF, send Caller ID.
+2) SLIC driver works unstable when compiled as module,
+loaded, then unloaded and finally reloaded again.

+3) ensure stability of current driver, define several test scenarios

+4) Current version of Si3226x SLIC driver is limited. It implements
+only base functionality such as Answer, Hangup, receive DTMF,
+send DTMF, send Caller ID.
diff --git a/drivers/staging/tdm/TODO b/drivers/staging/tdm/TODO
new file mode 100644
index 0000000..585a617
--- /dev/null
+++ b/drivers/staging/tdm/TODO
@@ -0,0 +1,19 @@
+Mainteiners:
+Michail Kurachkin <Michail.Kurachkin@promwad.com> <stelhs@yandex.ru>
+Ivan Kuten <ivan.kuten@promwad.com>
+Promwad company <info@promwad.com>
+
+Reviwers:
+Oliver Neukum <oneukum@suse.de>
+Ryan Mallon <rmallon@gmail.com>
+Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+
+Needed to be done to get the code out of the staging tree:
+1) Marvell Kirkwood TDM driver works unstable when compiled as module,
+loaded, then unloaded and finally reloaded again.
+
+2) Add Documentation/tdm-bus.txt
+
+3) ensure stability of current driver, define several test scenarios
+
+4) look into Freescale TDM https://patchwork.kernel.org/patch/1249881/ , adopt Freescale bits into current TDM framework
--
1.7.5.4
