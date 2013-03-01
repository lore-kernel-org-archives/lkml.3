Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3CALCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:02:38 -0500
Received: from mx2.promwad.com ([91.149.128.90]:9097 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab3CALCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:02:36 -0500
From: Michail Kurachkin <michail.kurachkin@promwad.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>,
        Oliver Neukum <oneukum@suse.de>, Ryan Mallon <rmallon@gmail.com>
CC: Michail Kurachkin <michail.kurachkin@promwad.com>
Subject: [PATCH v2 09/11] staging: fixed e-mail address
Date: Fri, 1 Mar 2013 14:02:23 +0300
Message-ID: <64c774c0ef7743a487a690f599c896e8bf1310b5.1362133319.git.michail.kurachkin@promwad.com>
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
 drivers/staging/tdm/kirkwood_tdm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tdm/kirkwood_tdm.c b/drivers/staging/tdm/kirkwood_tdm.c
index 57c8925..4d254bc 100644
--- a/drivers/staging/tdm/kirkwood_tdm.c
+++ b/drivers/staging/tdm/kirkwood_tdm.c
@@ -991,7 +991,7 @@ static void __exit kirkwood_exit_tdm(void)
 
 module_init(kirkwood_init_tdm);
 module_exit(kirkwood_exit_tdm);
-MODULE_AUTHOR("Michail Kurochkin <stelhs@yandex.ru>");
+MODULE_AUTHOR("Michail Kurochkin <michail.kurachkin@promwad.com>");
 MODULE_DESCRIPTION("TDM controller driver for Marvel kirkwood arch.");
 MODULE_LICENSE("GPL");
 
-- 
1.7.5.4

