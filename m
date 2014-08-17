Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaHQSi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:38:29 -0400
Received: from mo-online.de ([89.238.66.174]:52746 "EHLO mo-online.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaHQSiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:38:24 -0400
Date: Sun, 17 Aug 2014 20:30:02 +0200
From: Markus Osterhoff <mo@mo-online.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [TYPO 1/9] [typo] spelling, punctuation in main README file
Message-ID: <20140817183001.GB4077@mo-online.de>
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

- the option [...] allow -> allows you to specify
- no double-space behind etc. since it's not the
  end of a sentence, but of an acronym

Signed-off-by: Markus Osterhoff <linux-kernel@k-raum.org>
---
 README | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/README b/README
index a24ec89..8ccbd54 100644
--- a/README
+++ b/README
@@ -133,7 +133,7 @@ BUILD directory for the kernel:
 
    When compiling the kernel, all output files will per default be
    stored together with the kernel source code.
-   Using the option "make O=output/dir" allow you to specify an alternate
+   Using the option "make O=output/dir" allows you to specify an alternate
    place for the output files (including .config).
    Example:
 
@@ -320,7 +320,7 @@ COMPILING the kernel:
    reboot, and enjoy!
 
    If you ever need to change the default root device, video mode,
-   ramdisk size, etc.  in the kernel image, use the 'rdev' program (or
+   ramdisk size, etc. in the kernel image, use the 'rdev' program (or
    alternatively the LILO boot options when appropriate).  No need to
    recompile the kernel to change these parameters. 
 
-- 
1.8.5.5

