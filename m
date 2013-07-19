Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965915Ab3GSF3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:29:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965838Ab3GSF1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Magnus Damm <damm@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [ 66/72] ARM: shmobile: emev2 GIO3 resource fix
Date: Thu, 18 Jul 2013 22:26:23 -0700
Message-Id: <20130719052604.376563117@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Damm <damm@opensource.se>

commit 1eb14ea1e6bcd11d6d0ba937fc39808bb4d3453e upstream.

Fix GIO3 base addresses for EMEV2.

This bug was introduced by 088efd9273b5076a0aead479aa31f1066d182b3e
("mach-shmobile: Emma Mobile EV2 GPIO support V3") which was included in v3.5.

Signed-off-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-shmobile/setup-emev2.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-shmobile/setup-emev2.c
+++ b/arch/arm/mach-shmobile/setup-emev2.c
@@ -287,14 +287,14 @@ static struct gpio_em_config gio3_config
 static struct resource gio3_resources[] = {
 	[0] = {
 		.name	= "GIO_096",
-		.start	= 0xe0050100,
-		.end	= 0xe005012b,
+		.start	= 0xe0050180,
+		.end	= 0xe00501ab,
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
 		.name	= "GIO_096",
-		.start	= 0xe0050140,
-		.end	= 0xe005015f,
+		.start	= 0xe00501c0,
+		.end	= 0xe00501df,
 		.flags	= IORESOURCE_MEM,
 	},
 	[2] = {


