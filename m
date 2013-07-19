Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965905Ab3GSF3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:29:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965835Ab3GSF1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takanari Hayama <taki@igel.co.jp>, Magnus Damm <damm@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [ 65/72] ARM: shmobile: r8a73a4: Fix resources for SCIFB0
Date: Thu, 18 Jul 2013 22:26:22 -0700
Message-Id: <20130719052604.309335959@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takanari Hayama <taki@igel.co.jp>

commit f820b60582f75e73e83b8505d7e48fe59770f558 upstream.

Fix base address and IRQ resources associated with SCIFB0.

This bug was introduced by e481a528901d0cd18b5b5fcbdc55207ea3b6ef68
("ARM: shmobile: r8a73a4 SCIF support V3") which was included in v3.10.

Signed-off-by: Takanari Hayama <taki@igel.co.jp>
Acked-by: Magnus Damm <damm@opensource.se>
[ horms+renesas@verge.net.au: Add information about commit and version
  this bug was added in ]
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-shmobile/setup-r8a73a4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-shmobile/setup-r8a73a4.c
+++ b/arch/arm/mach-shmobile/setup-r8a73a4.c
@@ -62,7 +62,7 @@ enum { SCIFA0, SCIFA1, SCIFB0, SCIFB1, S
 static const struct plat_sci_port scif[] = {
 	SCIFA_DATA(SCIFA0, 0xe6c40000, gic_spi(144)), /* SCIFA0 */
 	SCIFA_DATA(SCIFA1, 0xe6c50000, gic_spi(145)), /* SCIFA1 */
-	SCIFB_DATA(SCIFB0, 0xe6c50000, gic_spi(145)), /* SCIFB0 */
+	SCIFB_DATA(SCIFB0, 0xe6c20000, gic_spi(148)), /* SCIFB0 */
 	SCIFB_DATA(SCIFB1, 0xe6c30000, gic_spi(149)), /* SCIFB1 */
 	SCIFB_DATA(SCIFB2, 0xe6ce0000, gic_spi(150)), /* SCIFB2 */
 	SCIFB_DATA(SCIFB3, 0xe6cf0000, gic_spi(151)), /* SCIFB3 */


