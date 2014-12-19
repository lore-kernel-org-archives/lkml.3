Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaLSNqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:46:51 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:33258 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaLSNqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:46:49 -0500
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Dec 2014 08:46:49 EST
From: Alexander Holler <holler@ahsoftware.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Holler <holler@ahsoftware.de>
Subject: [RFC PATCH] CodingStyle: remove what nowadays might be considered polemic
Date: Fri, 19 Dec 2014 14:36:28 +0100
Message-Id: <1418996188-2908-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In times where things like checkpatch do exist and are mandated to be used,
it would be easy to warn if too many levels of indentation are used (e.g.
by counting leading tabs).

The paragraph before already says that more than 3 levels of indentation
are bad, so the (removed) sentence nowadays only smells like an additional
excuse or polemic (because you still could use an unholy number of e.g.
7 indentations, even within the limit of 80 chars).

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 Documentation/CodingStyle | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 618a33c..8e96b14 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -31,10 +31,6 @@ the code move too far to the right, and makes it hard to read on a
 more than 3 levels of indentation, you're screwed anyway, and should fix
 your program.
 
-In short, 8-char indents make things easier to read, and have the added
-benefit of warning you when you're nesting your functions too deep.
-Heed that warning.
-
 The preferred way to ease multiple indentation levels in a switch statement is
 to align the "switch" and its subordinate "case" labels in the same column
 instead of "double-indenting" the "case" labels.  E.g.:
-- 
1.8.3.1

