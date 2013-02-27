Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738Ab3B0QbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:31:07 -0500
Received: from mx2.promwad.com ([91.149.128.90]:41439 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3B0QbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:31:05 -0500
From: Michail Kurachkin <michail.kurachkin@promwad.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>
CC: Michail Kurachkin <michail.kurachkin@promwad.com>
Subject: [PATCH 9/9] fixed e-mail address
Date: Wed, 27 Feb 2013 19:30:55 +0300
Message-ID: <1361982655-5693-1-git-send-email-michail.kurachkin@promwad.com>
X-Mailer: git-send-email 1.7.5.4
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

