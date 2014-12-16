Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbaLPJQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:16:05 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.162]:50825 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbaLPJQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:16:03 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2014 04:16:02 EST
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-14.tower-38.messagelabs.com!1418720977!1739500!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 16 Dec 2014 10:09:37 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] MCB changes for 3.19
Date: Tue, 16 Dec 2014 10:09:19 +0100
Message-ID: <1418720960-19504-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here are the mcb changes for 3.19 for you to apply.

As it is only a single patch (and I have no kernel.org account) no pull request,
but a patch email.

Thanks,
	Johannes

Johannes Thumshirn (1):
  mcb: mcb-pci: Only remap the 1st 0x200 bytes of BAR 0

 drivers/mcb/mcb-internal.h |  1 +
 drivers/mcb/mcb-pci.c      | 27 ++++++++++++++++++---------
 2 files changed, 19 insertions(+), 9 deletions(-)

-- 
1.9.1

