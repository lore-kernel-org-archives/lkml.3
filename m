Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaK1AXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 19:23:35 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:54955 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaK1AXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 19:23:32 -0500
From: Stefan Agner <stefan@agner.ch>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 0/4] serial: fsl_lpuart: fix various DMA related issues
Date: Fri, 28 Nov 2014 01:23:21 +0100
Message-Id: <1417134205-4400-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 and 3 are actual fixes, whereas 2 and 4 don't lead to issues
in standard cases but are still worthwhile fixes.

Stefan Agner (4):
  serial: fsl_lpuart: delete timer on shutdown
  serial: fsl_lpuart: move DMA channel request to probe
  serial: fsl_lpuart: avoid new transfer while DMA is running
  serial: fsl_lpuart: update RX timer on successful DMA transfer

 drivers/tty/serial/fsl_lpuart.c | 110 +++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 58 deletions(-)

-- 
2.1.3

