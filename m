Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaHQSjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:39:54 -0400
Received: from mo-online.de ([89.238.66.174]:52754 "EHLO mo-online.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaHQSi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:38:26 -0400
Date: Sun, 17 Aug 2014 20:30:46 +0200
From: Markus Osterhoff <mo@mo-online.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [TYPO 7/9] [typo] Doc/kbuild/kconfig-language.txt: sentence structure
Message-ID: <20140817183046.GH4077@mo-online.de>
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

the original sentence uses improper grammar

Signed-off-by: Markus Osterhoff <linux-kernel@k-raum.org>
---
 Documentation/kbuild/kconfig-language.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 8267f47..c0bb716 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -378,9 +378,9 @@ config X86
 Note: we use the existing config option and avoid creating a new
 config variable to select HAVE_GENERIC_IOMAP.
 
-Note: the use of the internal config variable HAVE_GENERIC_IOMAP, it is
-introduced to overcome the limitation of select which will force a
-config option to 'y' no matter the dependencies.
+Note: the internal config variable HAVE_GENERIC_IOMAP is introduced to
+overcome the limitation of select which will force a config option to
+'y' no matter the dependencies.
 The dependencies are moved to the symbol GENERIC_IOMAP and we avoid the
 situation where select forces a symbol equals to 'y'.
 
-- 
1.8.5.5

