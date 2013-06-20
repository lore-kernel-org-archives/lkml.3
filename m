Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965371Ab3FTLMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:12:13 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:40522 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965271Ab3FTLMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:12:12 -0400
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Coccinelle: Update section of MAINTAINERS
Date: Thu, 20 Jun 2013 13:10:55 +0200
Message-Id: <1371726656-24928-1-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Documentation/coccinelle.txt in the COCCINELLE section.

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 73b1b3a..2d94051 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2103,6 +2103,7 @@ L:	cocci@systeme.lip6.fr (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc
 W:	http://coccinelle.lip6.fr/
 S:	Supported
+F:	Documentation/coccinelle.txt
 F:	scripts/coccinelle/
 F:	scripts/coccicheck
 
-- 
1.7.9.5

