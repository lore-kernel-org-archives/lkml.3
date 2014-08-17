Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaHQSjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:39:52 -0400
Received: from mo-online.de ([89.238.66.174]:52755 "EHLO mo-online.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaHQSi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:38:26 -0400
Date: Sun, 17 Aug 2014 20:30:41 +0200
From: Markus Osterhoff <mo@mo-online.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [TYPO 6/9] [typo] Doc/kbuild/kconfig-language.txt: several spellings
Message-ID: <20140817183041.GG4077@mo-online.de>
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

- this file only uses single blanks between sentences
- semicolon instead of comma
- third person singular-s
- i.e. with two dots
- "a feature that are -> is"

Signed-off-by: Markus Osterhoff <linux-kernel@k-raum.org>
---
 Documentation/kbuild/kconfig-language.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 350f733..8267f47 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -35,7 +35,7 @@ config MODVERSIONS
 	  kernel.  ...
 
 Every line starts with a key word and can be followed by multiple
-arguments.  "config" starts a new config entry. The following lines
+arguments. "config" starts a new config entry. The following lines
 define attributes for this config option. Attributes can be the type of
 the config option, input prompt, dependencies, help text and default
 values. A config option can be defined multiple times with the same
@@ -114,7 +114,7 @@ applicable everywhere (see syntax).
 	the illegal configurations all over.
 
 - limiting menu display: "visible if" <expr>
-  This attribute is only applicable to menu blocks, if the condition is
+  This attribute is only applicable to menu blocks; if the condition is
   false, the menu block is not displayed to the user (the symbols
   contained there can still be selected by other symbols, though). It is
   similar to a conditional "prompt" attribute for individual menu
@@ -142,7 +142,7 @@ applicable everywhere (see syntax).
   - "defconfig_list"
     This declares a list of default entries which can be used when
     looking for the default configuration (which is used when the main
-    .config doesn't exists yet.)
+    .config doesn't exist yet.)
 
   - "modules"
     This declares the symbol to be used as the MODULES symbol, which
@@ -288,14 +288,14 @@ This defines a choice group and accepts any of the above attributes as
 options. A choice can only be of type bool or tristate, while a boolean
 choice only allows a single config entry to be selected, a tristate
 choice also allows any number of config entries to be set to 'm'. This
-can be used if multiple drivers for a single hardware exists and only a
+can be used if multiple drivers for a single hardware exist and only a
 single driver can be compiled/loaded into the kernel, but all drivers
 can be compiled as modules.
 A choice accepts another option "optional", which allows to set the
 choice to 'n' and no entry needs to be selected.
 If no [symbol] is associated with a choice, then you can not have multiple
 definitions of that choice. If a [symbol] is associated to the choice,
-then you may define the same choice (ie. with the same entries) in another
+then you may define the same choice (i.e. with the same entries) in another
 place.
 
 comment:
@@ -350,7 +350,7 @@ files.
 
 Adding common features and make the usage configurable
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-It is a common idiom to implement a feature/functionality that are
+It is a common idiom to implement a feature/functionality that is
 relevant for some architectures but not all.
 The recommended way to do so is to use a config variable named HAVE_*
 that is defined in a common Kconfig file and selected by the relevant
-- 
1.8.5.5

