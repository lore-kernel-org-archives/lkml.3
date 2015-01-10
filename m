Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbbAJAJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:09:07 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:36854 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJAJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:09:06 -0500
From: Stefan Agner <stefan@agner.ch>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 0/2] serial: fsl_lpuart: fix DMA issues for 3.19
Date: Sat, 10 Jan 2015 01:08:57 +0100
Message-Id: <1420848539-4519-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch 1 and 3 of the first version of this patchset.

Changes since v1:
- Reproduced on v3.19-rc3 and rebased ontop of that
- Make sure that RDMAS is cleared on startup

Stefan Agner (2):
  serial: fsl_lpuart: delete timer on shutdown
  serial: fsl_lpuart: avoid new transfer while DMA is running

 drivers/tty/serial/fsl_lpuart.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

-- 
2.2.1

