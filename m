Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3CALEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:04:40 -0500
Received: from mx2.promwad.com ([91.149.128.90]:9131 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3CALEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:04:39 -0500
From: Michail Kurachkin <michail.kurachkin@promwad.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>,
        Oliver Neukum <oneukum@suse.de>, Ryan Mallon <rmallon@gmail.com>
CC: Michail Kurachkin <michail.kurachkin@promwad.com>
Subject: [PATCH v2 11/11] staging: add issuses in TODO
Date: Fri, 1 Mar 2013 14:04:25 +0300
Message-ID: <c31d3320e1de8522670fcef7c758ad6ac1e3f4ef.1362133319.git.michail.kurachkin@promwad.com>
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
 drivers/staging/tdm/TODO |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/tdm/TODO

diff --git a/drivers/staging/tdm/TODO b/drivers/staging/tdm/TODO
new file mode 100644
index 0000000..9e5fe80
--- /dev/null
+++ b/drivers/staging/tdm/TODO
@@ -0,0 +1,16 @@
+Needed to be done to get the code out of the staging tree:
+1) Marvell Kirkwood TDM driver works unstable when compiled as module,
+loaded, then unloaded and finally reloaded again.
+
+2) Add Documentation/tdm-bus.txt
+
+3) ensure stability of current driver, define several test scenarios
+
+4) look into Freescale TDM https://patchwork.kernel.org/patch/1249881/ , adopt Freescale bits into current TDM framework
+
+
+Mainteiners:
+Michail Kurachkin <Michail.Kurachkin@promwad.com> <stelhs@yandex.ru>
+Ivan Kuten <ivan.kuten@promwad.com>
+Promwad company <info@promwad.com>
+
-- 
1.7.5.4

