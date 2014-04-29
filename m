Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaD2CKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:10:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56949 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbaD2CKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:10:12 -0400
X-Sasl-enc: /DPRYQT1jGAF83UUB4254oWk8014NQ1hHuqpVv89/+uW 1398737411
Message-ID: <535F09E1.2020800@fastmail.fm>
Date: Tue, 29 Apr 2014 10:09:37 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/10] staging: gdm72xx: Modified struct allocation to match
 coding standards
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda> <53577E96.10106@fastmail.fm> <20140423090557.GU26890@mwanda> <20140423090904.GV26890@mwanda> <535F0866.2060207@fastmail.fm>
In-Reply-To: <535F0866.2060207@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modified struct allocation to match coding standards

---
 drivers/staging/gdm72xx/gdm_qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 50d43ad..519db48 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -56,7 +56,7 @@ static void *alloc_qos_entry(void)
 	}
 	spin_unlock_irqrestore(&qos_free_list.lock, flags);
 
-	entry = kmalloc(sizeof(struct qos_entry_s), GFP_ATOMIC);
+	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
 	return entry;
 }
 
-- 
1.8.4

