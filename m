Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaHQSib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:38:31 -0400
Received: from mo-online.de ([89.238.66.174]:52756 "EHLO mo-online.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaHQSi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:38:26 -0400
Date: Sun, 17 Aug 2014 20:30:27 +0200
From: Markus Osterhoff <mo@mo-online.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [TYPO 3/9] [typo] REPORTING-BUGS
Message-ID: <20140817183027.GD4077@mo-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: linux-2.6.39.3
X-Mutt-Manual: http://www.mutt.org/doc/manual/manual.html
X-PGP-Key: http://mo-online.de/~osti/public.key
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- missing word added
- second blank behind sentence added, as in rest of document

Signed-off-by: Markus Osterhoff <linux-kernel@k-raum.org>
---
 REPORTING-BUGS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index 0cb8cdf..ebac809 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -9,7 +9,7 @@ Please see https://www.kernel.org/ for a list of supported kernels.  Any
 kernel marked with [EOL] is "end of life" and will not have any fixes
 backported to it.
 
-If you've found a bug on a kernel version isn't listed on kernel.org,
+If you've found a bug on a kernel version that isn't listed on kernel.org,
 contact your Linux distribution or embedded vendor for support.
 Alternatively, you can attempt to run one of the supported stable or -rc
 kernels, and see if you can reproduce the bug on that.  It's preferable
@@ -88,7 +88,7 @@ step-by-step instructions for how a user can trigger the bug.
 If the failure includes an "OOPS:", take a picture of the screen, capture
 a netconsole trace, or type the message from your screen into the bug
 report.  Please read "Documentation/oops-tracing.txt" before posting your
-bug report. This explains what you should do with the "Oops" information
+bug report.  This explains what you should do with the "Oops" information
 to make it useful to the recipient.
 
 This is a suggested format for a bug report sent via email or bugzilla.
-- 
1.8.5.5

