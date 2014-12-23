Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaLWMjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:39:17 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60590 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaLWMjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:39:15 -0500
Date: Tue, 23 Dec 2014 13:39:12 +0100
From: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: [PATCH] x86/kernel/cpu/mkcapflags.sh bash-ism
Message-ID: <20141223123912.GA1386@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chocked while compiling linux with dash shell instead of bash shell.
See http://pubs.opengroup.org/onlinepubs/9699919799/utilities/test.html

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
---
--- a/arch/x86/kernel/cpu/mkcapflags.sh
+++ b/arch/x86/kernel/cpu/mkcapflags.sh
@@ -28,7 +28,7 @@
 		# If the /* comment */ starts with a quote string, grab that.
 		VALUE="$(echo "$i" | sed -n 's@.*/\* *\("[^"]*"\).*\*/@\1@p')"
 		[ -z "$VALUE" ] && VALUE="\"$NAME\""
-		[ "$VALUE" == '""' ] && continue
+		[ "$VALUE" = '""' ] && continue
 
 		# Name is uppercase, VALUE is all lowercase
 		VALUE="$(echo "$VALUE" | tr A-Z a-z)"
