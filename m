Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbbAYTMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:12:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbbAYSJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        Lokesh Vutla <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 76/98] ARM: omap5/dra7xx: Fix frequency typos
Date: Sun, 25 Jan 2015 10:07:34 -0800
Message-Id: <20150125180716.166320703@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

commit 572b24e6d85d98cdc552f07e9fb9870d9460d81b upstream.

The switch statement of the possible list of SYSCLK1 frequencies is
missing a 0 in 4 out of the 7 frequencies.

Fixes: fa6d79d27614 ("ARM: OMAP: Add initialisation for the real-time counter")
Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/timer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -513,11 +513,11 @@ static void __init realtime_counter_init
 	rate = clk_get_rate(sys_clk);
 	/* Numerator/denumerator values refer TRM Realtime Counter section */
 	switch (rate) {
-	case 1200000:
+	case 12000000:
 		num = 64;
 		den = 125;
 		break;
-	case 1300000:
+	case 13000000:
 		num = 768;
 		den = 1625;
 		break;
@@ -529,11 +529,11 @@ static void __init realtime_counter_init
 		num = 192;
 		den = 625;
 		break;
-	case 2600000:
+	case 26000000:
 		num = 384;
 		den = 1625;
 		break;
-	case 2700000:
+	case 27000000:
 		num = 256;
 		den = 1125;
 		break;


