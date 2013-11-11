Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3KKSfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:35:04 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52924 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3KKSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:34:54 -0500
Date: Mon, 11 Nov 2013 19:34:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform change for v3.13
Message-ID: <20131111183451.GA16155@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   # HEAD: a6d30e0fffb32ab9e48fa7fc8f463805d5b0bddb x86/geode: Fix incorrect placement of __initdata tag

A single __initdata fix.

 Thanks,

	Ingo

------------------>
Bartlomiej Zolnierkiewicz (1):
      x86/geode: Fix incorrect placement of __initdata tag


 arch/x86/platform/geode/alix.c    | 2 +-
 arch/x86/platform/geode/geos.c    | 2 +-
 arch/x86/platform/geode/net5501.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/geode/alix.c b/arch/x86/platform/geode/alix.c
index 90e23e7..76b6632 100644
--- a/arch/x86/platform/geode/alix.c
+++ b/arch/x86/platform/geode/alix.c
@@ -98,7 +98,7 @@ static struct platform_device alix_leds_dev = {
 	.dev.platform_data = &alix_leds_data,
 };
 
-static struct __initdata platform_device *alix_devs[] = {
+static struct platform_device *alix_devs[] __initdata = {
 	&alix_buttons_dev,
 	&alix_leds_dev,
 };
diff --git a/arch/x86/platform/geode/geos.c b/arch/x86/platform/geode/geos.c
index c2e6d53..aa733fb 100644
--- a/arch/x86/platform/geode/geos.c
+++ b/arch/x86/platform/geode/geos.c
@@ -87,7 +87,7 @@ static struct platform_device geos_leds_dev = {
 	.dev.platform_data = &geos_leds_data,
 };
 
-static struct __initdata platform_device *geos_devs[] = {
+static struct platform_device *geos_devs[] __initdata = {
 	&geos_buttons_dev,
 	&geos_leds_dev,
 };
diff --git a/arch/x86/platform/geode/net5501.c b/arch/x86/platform/geode/net5501.c
index 646e3b5..927e38c 100644
--- a/arch/x86/platform/geode/net5501.c
+++ b/arch/x86/platform/geode/net5501.c
@@ -78,7 +78,7 @@ static struct platform_device net5501_leds_dev = {
 	.dev.platform_data = &net5501_leds_data,
 };
 
-static struct __initdata platform_device *net5501_devs[] = {
+static struct platform_device *net5501_devs[] __initdata = {
 	&net5501_buttons_dev,
 	&net5501_leds_dev,
 };
