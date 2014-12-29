Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaL2Pn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 10:43:29 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52711 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaL2Pn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 10:43:28 -0500
Date: Mon, 29 Dec 2014 16:43:24 +0100
From: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: [PATCH] x86: Fix mkcapflags.sh bash-ism again
Message-ID: <20141229154324.GA27533@dhcppc1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chocked while compiling linux with dash shell instead of bash shell.
See:
http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_09_05

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
---

Forgot that one. More to come.

--- a/arch/x86/kernel/cpu/mkcapflags.sh
+++ b/arch/x86/kernel/cpu/mkcapflags.sh
@@ -6,7 +6,7 @@
 IN=$1
 OUT=$2
 
-function dump_array()
+dump_array()
 {
 	ARRAY=$1
 	SIZE=$2
