Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3HEAUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 20:20:00 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:59188 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3HEAT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 20:19:59 -0400
Date: Sun, 4 Aug 2013 20:19:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata fixes for 3.11-rc4
Message-ID: <20130805001955.GD12029@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

Just an addition of MODULE_DEVICE_TABLE() for a platform driver.
Available in the follwing branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.11-fixes

for you to fetch changes up to 71ab1d58c26eb7c30711caa95c173d5c39ab8855:

  pata_imx: expose module alias for loading from device-tree (2013-07-29 12:13:08 -0400)

Thanks.

----------------------------------------------------------------
Niels de Vos (1):
      pata_imx: expose module alias for loading from device-tree

 drivers/ata/pata_imx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/pata_imx.c b/drivers/ata/pata_imx.c
index 4ec7c04..26386f0 100644
--- a/drivers/ata/pata_imx.c
+++ b/drivers/ata/pata_imx.c
@@ -237,6 +237,7 @@ static const struct of_device_id imx_pata_dt_ids[] = {
 		/* sentinel */
 	}
 };
+MODULE_DEVICE_TABLE(of, imx_pata_dt_ids);
 
 static struct platform_driver pata_imx_driver = {
 	.probe		= pata_imx_probe,

-- 
tejun
