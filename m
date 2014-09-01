Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaIAWs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 18:48:27 -0400
Received: from ppsw-40.csi.cam.ac.uk ([131.111.8.140]:45518 "EHLO
	ppsw-40.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaIAWs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 18:48:26 -0400
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2014 18:48:25 EDT
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Mon, 1 Sep 2014 15:31:55 -0700
From: David Wood <devel@dtwood.uk>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexander Gordeev <agordeev@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Antonio Ospite <ao2@ao2.it>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        Ivan Vecera <ivecera@redhat.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] ethernet: nvidia: Remove extra parens
Message-ID: <20140901223152.GA3066@dtw-laptop.attlocal.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary double parenthesis around if statement.

Signed-off-by: David Wood <devel@dtwood.uk>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 925b296..f39cae6 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1481,7 +1481,7 @@ static int phy_init(struct net_device *dev)
 	}
 
 	/* phy vendor specific configuration */
-	if ((np->phy_oui == PHY_OUI_CICADA)) {
+	if (np->phy_oui == PHY_OUI_CICADA) {
 		if (init_cicada(dev, np, phyinterface)) {
 			netdev_info(dev, "%s: phy init failed\n",
 				    pci_name(np->pci_dev));
-- 
2.0.3
