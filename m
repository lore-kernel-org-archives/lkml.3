Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3FFVkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:40:14 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36275 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3FFVkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:40:11 -0400
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        Brice Goglin <Brice.Goglin@inria.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Coccinelle: Update the Coccinelle section of MAINTAINERS
Date: Thu,  6 Jun 2013 23:39:53 +0200
Message-Id: <1370554793-9152-2-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370554793-9152-1-git-send-email-nicolas.palix@imag.fr>
References: <1370554793-9152-1-git-send-email-nicolas.palix@imag.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Michal Marek and the misc branch of the kbuild tree
in the Coccinelle section of MAINTAINERS.

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b..73b1b3a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2098,7 +2098,9 @@ COCCINELLE/Semantic Patches (SmPL)
 M:	Julia Lawall <Julia.Lawall@lip6.fr>
 M:	Gilles Muller <Gilles.Muller@lip6.fr>
 M:	Nicolas Palix <nicolas.palix@imag.fr>
+M:	Michal Marek <mmarek@suse.cz>
 L:	cocci@systeme.lip6.fr (moderated for non-subscribers)
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc
 W:	http://coccinelle.lip6.fr/
 S:	Supported
 F:	scripts/coccinelle/
-- 
1.8.1.2

