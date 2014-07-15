Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbaGOJu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:50:29 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51780 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbaGOJu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:50:26 -0400
Date: Tue, 15 Jul 2014 18:49:09 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8 RESEND] staging: dgap: fix a typo in dgap_gettok()
Message-ID: <20140715094909.GA19248@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "boar" should be "board".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
RESEND : Adds Mark to TO list and CC list for checking send this email
properly to him.

 drivers/staging/dgap/dgap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 470ae7b..17514c8 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -7105,7 +7105,7 @@ static int dgap_gettok(char **in, struct cnode *p)
 	char *w;
 	struct toklist *t;
 
-	if (strstr(dgap_cword, "boar")) {
+	if (strstr(dgap_cword, "board")) {
 		w = dgap_getword(in);
 		snprintf(dgap_cword, MAXCWORD, "%s", w);
 		for (t = dgap_tlist; t->token != 0; t++) {
-- 
1.7.1

