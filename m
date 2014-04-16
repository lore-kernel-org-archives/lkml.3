Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161824AbaDPQFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:05:42 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:60165 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922AbaDPQFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:05:37 -0400
Message-ID: <1397664335.28548.14.camel@x220>
Subject: [PATCH] [TRIVIAL] modpost: Fix comment typo "Modules.symvers"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 16 Apr 2014 18:05:35 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2014 16:05:36.0208 (UTC) FILETIME=[B3FE4500:01CF598D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 066355673930..ea7f9530afa2 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -316,7 +316,7 @@ static struct symbol *sym_add_exported(const char *name, struct module *mod,
 			     s->module->name,
 			     is_vmlinux(s->module->name) ?"":".ko");
 		} else {
-			/* In case Modules.symvers was out of date */
+			/* In case Module.symvers was out of date */
 			s->module = mod;
 		}
 	}
-- 
1.9.0

