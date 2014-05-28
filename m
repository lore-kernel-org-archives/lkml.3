Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaE1OKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:10:55 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33479 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaE1OKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:10:53 -0400
Date: Wed, 28 May 2014 19:40:47 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org, kbuild@01.org,
        julia.lawall@lip6.fr
Subject: [PATCH] coccinelle/null: solve parse error
Message-ID: <20140528141047.GA4059@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves the parse-error by adding @@ . This is necessary since
Coccinelle version 1.0.0-rc20. Also, the comment is added to use a
recent version of Coccinelle.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 scripts/coccinelle/null/badzero.cocci | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/coccinelle/null/badzero.cocci b/scripts/coccinelle/null/badzero.cocci
index d79baf7..5551da2 100644
--- a/scripts/coccinelle/null/badzero.cocci
+++ b/scripts/coccinelle/null/badzero.cocci
@@ -10,7 +10,7 @@
 // Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
 // Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
-// Comments:
+// Comments: Requires Coccinelle version 1.0.0-rc20 or later
 // Options:
 
 virtual patch
@@ -19,6 +19,7 @@ virtual org
 virtual report
 
 @initialize:ocaml@
+@@
 let negtable = Hashtbl.create 101
 
 @depends on patch@
-- 
1.9.1

