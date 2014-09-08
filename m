Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaIHTC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:02:58 -0400
Received: from scspc499.cs.uwaterloo.ca ([129.97.171.80]:52064 "EHLO
	scspc499.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaIHTC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:02:57 -0400
Date: Mon, 8 Sep 2014 15:02:49 -0400
From: Adrian Nicoara <anicoara@uwaterloo.ca>
To: shigekatsu.tateno@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, tklauser@distanz.ch
Subject: Re: [PATCH v2 4/4] staging: ozwpan: use kmalloc_array over kmalloc
 with multiply
Message-ID: <20140908190249.GA17737@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup checkpatch.pl warnings.

Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>
---

Somehow I missed the comment Tobias made on the line indentation. I fixed the
patch, and added here as a reply - the previous patch should be ignored.

 drivers/staging/ozwpan/ozhcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index ba2168f..e880452 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1315,8 +1315,8 @@ static int oz_build_endpoints_for_config(struct usb_hcd *hcd,
 	if (num_iface) {
 		struct oz_interface *iface;

-		iface = kmalloc(num_iface*sizeof(struct oz_interface),
-				mem_flags | __GFP_ZERO);
+		iface = kmalloc_array(num_iface, sizeof(struct oz_interface),
+					mem_flags | __GFP_ZERO);
 		if (!iface)
 			return -ENOMEM;
 		spin_lock_bh(&ozhcd->hcd_lock);
--
2.0.1

