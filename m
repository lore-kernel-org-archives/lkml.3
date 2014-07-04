Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278AbaGDT55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:57:57 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38036 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbaGDT54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:57:56 -0400
Date: Fri, 4 Jul 2014 21:57:50 +0200
From: Pawel Lebioda <pawel.lebioda89@gmail.com>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julian Andres Klode <jak@jak-linux.org>, ac100@lists.launchpad.net,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: nvec: remove unneccessary 'else' after 'return'
 statement
Message-ID: <20140704195746.GA4346@ThinkPad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes the following warning reported by checkpatch.pl:

WARNING: else is not generally useful after a break or return
#235: FILE: drivers/staging/nvec/nvec.c:235:

Regards
Pawel Lebioda

Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
 drivers/staging/nvec/nvec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 90f1c4d..8a3dd47 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -232,8 +232,7 @@ static size_t nvec_msg_size(struct nvec_msg *msg)
 		return 2;
 	else if (event_length == NVEC_3BYTES)
 		return 3;
-	else
-		return 0;
+	return 0;
 }
 
 /**
