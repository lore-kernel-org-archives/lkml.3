Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaLWKwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:52:09 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:40476 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890AbaLWKwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:52:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Dec 2014 12:51:55 +0200
From: Olli Lehtinen <olli.lehtinen@iki.fi>
To: gregkh@linuxfoundation.org, jkc@redhat.com
Cc: sparmaintainer@unisys.com, linux-kernel@vger.kernel.org
Message-ID: <d63fd4753ad47af98d2b26198dcf8db7@kapsi.fi>
User-Agent: RoundCube Webmail/0.9.4
X-SA-Exim-Connect-IP: 217.30.184.182
X-SA-Exim-Mail-From: olli.lehtinen@iki.fi
Subject: [PATCH] staging: unisys: Removed a prohibited space in a function
 parameter
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:26:47 +0000)
X-SA-Exim-Scanned: Yes (on mail.kapsi.fi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the checkpatch.pl error:
ERROR: space prohibited before that ',' (ctx:WxW)" in virthba.c.

Signed-off-by: Olli Lehtinen <olli.lehtinen@iki.fi>
---
  drivers/staging/unisys/virthba/virthba.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/unisys/virthba/virthba.c 
b/drivers/staging/unisys/virthba/virthba.c
index d7a629b..82fcb3b 100644
--- a/drivers/staging/unisys/virthba/virthba.c
+++ b/drivers/staging/unisys/virthba/virthba.c
@@ -1438,7 +1438,7 @@ static ssize_t enable_ints_write(struct file 
*file,
  		return -EFAULT;
  	}

-	i = kstrtoint(buf, 10 , &new_value);
+	i = kstrtoint(buf, 10, &new_value);

  	if (i != 0) {
  		LOGERR("Failed to scan value for enable_ints, buf<<%.*s>>",
-- 
1.7.10.4

