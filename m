Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3CALDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:03:47 -0500
Received: from mx2.promwad.com ([91.149.128.90]:9115 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab3CALDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:03:46 -0500
From: Michail Kurachkin <michail.kurachkin@promwad.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>,
        Oliver Neukum <oneukum@suse.de>, Ryan Mallon <rmallon@gmail.com>
CC: Michail Kurachkin <michail.kurachkin@promwad.com>
Subject: [PATCH v2 10/11] staging: add issuses in TODO
Date: Fri, 1 Mar 2013 14:03:37 +0300
Message-ID: <30da8426b86a45cff8556daa72dc82457044c006.1362133319.git.michail.kurachkin@promwad.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1362133319.git.michail.kurachkin@promwad.com>
References: <cover.1362133319.git.michail.kurachkin@promwad.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michail Kurachkin <michail.kurachkin@promwad.com>
---
 drivers/staging/si3226x/TODO |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/si3226x/TODO b/drivers/staging/si3226x/TODO
index b2cb27e..8d81465 100644
--- a/drivers/staging/si3226x/TODO
+++ b/drivers/staging/si3226x/TODO
@@ -1,8 +1,19 @@
+Needed to be done to get the code out of the staging tree:
 1) mutex_lock(&slic_chr_dev_lock);
 This locking is very heavy handed and should be reworked
 
-2) SLIC driver works unstable when compiled as module, loaded, then unloaded and finally reloaded again.
+2) SLIC driver works unstable when compiled as module,
+loaded, then unloaded and finally reloaded again.
 
-3) Current version of Si3226x SLIC driver is limited. It implements only base functionality such as Answer, Hangup, receive DTMF, send DTMF, send Caller ID.
+3) ensure stability of current driver, define several test scenarios
 
+4) Current version of Si3226x SLIC driver is limited. It implements
+only base functionality such as Answer, Hangup, receive DTMF,
+send DTMF, send Caller ID.
+
+
+Mainteiners:
+Michail Kurachkin <Michail.Kurachkin@promwad.com> <stelhs@yandex.ru>
+Ivan Kuten <ivan.kuten@promwad.com>
+Promwad company <info@promwad.com>
 
-- 
1.7.5.4

