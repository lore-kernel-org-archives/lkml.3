Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3LZOhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:37:46 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:48744 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab3LZOho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:37:44 -0500
Message-ID: <52BC3F37.6050103@linaro.org>
Date: Thu, 26 Dec 2013 08:37:43 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sage Weil <sage@inktank.com>
CC: ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: update an e-mail address
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sage, perhaps you could sign off on or ack this, and take it in
through your tree.  Thanks.  -Alex]

I no longer have direct access to my Inktank e-mail.  I still pay
attention to rbd, so update its entry in MAINTAINERS accordingly.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d5e4ff3..d42633c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7016,7 +7016,7 @@ F:	drivers/media/parport/*-qcam*
 RADOS BLOCK DEVICE (RBD)
 M:	Yehuda Sadeh <yehuda@inktank.com>
 M:	Sage Weil <sage@inktank.com>
-M:	Alex Elder <elder@inktank.com>
+M:	Alex Elder <elder@kernel.org>
 M:	ceph-devel@vger.kernel.org
 W:	http://ceph.com/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
-- 
1.7.9.5

