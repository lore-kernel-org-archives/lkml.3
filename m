Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaCJPrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:47:15 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:47840 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbaCJPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:47:12 -0400
Date: Mon, 10 Mar 2014 11:47:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>
Subject: [GIT PULL] libata fixes for v3.14-rc5
Message-ID: <20140310154709.GE25290@htj.dyndns.org>
References: <20140308152854.GB25021@htj.dyndns.org>
 <CA+55aFzgg4hicXQ-cwHZdDrGRPSoeUVeMzPRAmoEYrujLjt1_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzgg4hicXQ-cwHZdDrGRPSoeUVeMzPRAmoEYrujLjt1_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Yeah, that makes sense.  I merged the two entries into
"Crucial_CT???M500SSD*".

The following changes since commit b28a613e9138e4b3a64649bd60b13436f4b4b49b:

  libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001) (2014-03-07 13:47:34 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.14-fixes

for you to fetch changes up to 83493d7e782d2630f1a55def14a79f0e7c4faac3:

  libata: use wider match for blacklisting Crucial M500 (2014-03-10 11:17:55 -0400)

Thanks.

----------------------------------------------------------------
Tejun Heo (1):
      libata: use wider match for blacklisting Crucial M500

 drivers/ata/libata-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 65d3f1b..8cb2522 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4225,8 +4225,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* devices that don't properly handle queued TRIM commands */
 	{ "Micron_M500*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M500SSD1",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M500SSD3",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT???M500SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 
 	/*
 	 * Some WD SATA-I drives spin up and down erratically when the link
