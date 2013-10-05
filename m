Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3JEQLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 12:11:33 -0400
Received: from libra.uberspace.de ([95.143.172.171]:45288 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752914Ab3JEQLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:11:32 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 5/5] drivers: usb: core: hcd: if-else-braces fixed
Date: Sat,  5 Oct 2013 18:02:10 +0200
Message-Id: <9de4b521119cf8aba8b4dc916e521333d31dd290.1380986962.git.mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
In-Reply-To: <cover.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put else keyword on same line as closing brace from if statement, added
{ } braces as the styleguide says.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/hcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 5d13d6c..bbd182a 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -879,9 +879,9 @@ static ssize_t authorized_default_store(struct device *dev,
 	if (result == 1) {
 		usb_hcd->authorized_default = val ? 1 : 0;
 		result = size;
-	}
-	else
+	} else {
 		result = -EINVAL;
+	}
 	return result;
 }
 static DEVICE_ATTR_RW(authorized_default);
-- 
1.8.4

