Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab3E3TYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:24:24 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33404 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3E3TYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:24:18 -0400
MIME-Version: 1.0
Date: Thu, 30 May 2013 13:24:15 -0600
X-Google-Sender-Auth: 30NMZP9JqAGSCLN2_HWeLvPuP7Q
Message-ID: <CAN3tLtJruJKYOmyg_XQqRW+fXQegXfxpBLg4HL1dx9e2jvjmqA@mail.gmail.com>
Subject: [PATCH] Documentation: cover CONFIG_BINFMT_SCRIPT in init.txt
From: Kris Rusocki <kszysiu@braxis.org>
To: linux-doc@vger.kernel.org, andi@lisas.de
Cc: rob@landley.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kris Rusocki <kszysiu@braxis.org>

Now that binfmt_script is configurable, explain yet another possible
cause of boot failure (a script w/CONFIG_BINFMT_SCRIPT != y).

Signed-off-by: Kris Rusocki <kszysiu@braxis.org>
---
 Documentation/init.txt |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/init.txt b/Documentation/init.txt
index 535ad5e..8c6af4f 100644
--- a/Documentation/init.txt
+++ b/Documentation/init.txt
@@ -29,8 +29,9 @@
 E) make sure the binary's architecture matches your hardware.
    E.g. i386 vs. x86_64 mismatch, or trying to load x86 on ARM hardware.
    In case you tried loading a non-binary file here (shell script?),
-   you should make sure that the script specifies an interpreter in its shebang
-   header line (#!/...) that is fully working (including its library
+   you should make sure that your kernel supports script execution
+   (CONFIG_BINFMT_SCRIPT=y) and the script specifies an interpreter in its
+   shebang header line (#!/...) that is fully working (including its library
    dependencies). And before tackling scripts, better first test a simple
    non-script binary such as /bin/sh and confirm its successful execution.
    To find out more, add code to init/main.c to display kernel_execve()s
