Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab3JURKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:10:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38473 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751078Ab3JURKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:10:18 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: alex.bluesman.smirnov@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] mac802154: correct a typo in ieee802154_alloc_device() prototype
Date: Mon, 21 Oct 2013 19:09:58 +0200
Message-Id: <1382375398-17428-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has no other impact than a cosmetic one.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 include/net/mac802154.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index d0d11df..807d6b7 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -133,7 +133,7 @@ struct ieee802154_ops {
 
 /* Basic interface to register ieee802154 device */
 struct ieee802154_dev *
-ieee802154_alloc_device(size_t priv_data_lex, struct ieee802154_ops *ops);
+ieee802154_alloc_device(size_t priv_data_len, struct ieee802154_ops *ops);
 void ieee802154_free_device(struct ieee802154_dev *dev);
 int ieee802154_register_device(struct ieee802154_dev *dev);
 void ieee802154_unregister_device(struct ieee802154_dev *dev);
-- 
1.8.3.2

