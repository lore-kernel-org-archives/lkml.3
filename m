Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3IWPV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:21:57 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.112]:33829 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545Ab3IWPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:21:55 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-9.tower-193.messagelabs.com!1379949711!13854659!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 23 Sep 2013 17:21:52 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <linux-edac@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Dave Jiang <dave.jiang@gmail.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Chunhe Lan <Chunhe.Lan@freescale.com>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH 0/3] edac/85xx: New Maintainership for MPC85xx EDAC driver
Date: Mon, 23 Sep 2013 17:23:26 +0200
Message-ID: <1379949809-11083-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 23 Sep 2013 15:21:51.0568 (UTC) FILETIME=[A0E73D00:01CEB870]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As already discussed with Borislav Petkov and Dave Jiang on linux-edac I will
take the maintainership of mpc85xx_edac.[ch]. In the following E-Mails I have
put all patches currently known to me.

If anyone else knows of orphaned patches for this driver, please inform me.

The patch "[RFC PATCH] edac/85xx: Request shared interrupts for PCI" by
Barry Grussling <barry@grussling.com> is not included, as Chunhe Lan's patch
incorporates that fix.

Thanks.
Johannes

Chunhe Lan (1):
  edac/85xx: Add PCIe error interrupt edac support

Johannes Thumshirn (2):
  MAINTAINERS: Add edac-mpc85xx driver to MAINTAINERS
  edac/85xx: Remove mpc85xx_pci_err_remove

 MAINTAINERS                 |    7 +++
 drivers/edac/mpc85xx_edac.c |  120 +++++++++++++++++++++++++++++++------------
 drivers/edac/mpc85xx_edac.h |    7 +++
 3 files changed, 101 insertions(+), 33 deletions(-)

--
1.7.9.5

