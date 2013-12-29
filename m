Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3L2C3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:29:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55561 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280Ab3L2CK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alistair Popple" <alistair@popple.id.au>,
        "Tejun Heo" <tj@kernel.org>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.222463470@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 085/185] ahci: add support for IBM Akebono platform device
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Popple <alistair@popple.id.au>

commit 2435dcb98cfe13c246aa27df393e22bc24bbcd20 upstream.

The new IBM Akebono board has a PPC476GTR SoC with an AHCI compliant
SATA controller. This patch adds a compatible property for the new SoC
to the AHCI platform driver.

Signed-off-by: Alistair Popple <alistair@popple.id.au>
Signed-off-by: Tejun Heo <tj@kernel.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci_platform.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -204,6 +204,7 @@ static int __devexit ahci_remove(struct
 
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "calxeda,hb-ahci", },
+	{ .compatible = "ibm,476gtr-ahci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);

