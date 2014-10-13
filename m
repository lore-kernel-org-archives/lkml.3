Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaJMMls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:41:48 -0400
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:42012 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753797AbaJMMlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:41:45 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] staging: comedi: cb_pcimdas: support PCIe-DAS1602/16
Date: Mon, 13 Oct 2014 13:41:19 +0100
Message-Id: <1413204082-14757-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the block comment style and add support for the PCIe-DAS1602/16.
This is the PCI-Express version of the PCIM-DAS1602/16 and is software
compatible with it, apart from a different PCI device ID.

1) staging: comedi: cb_pcimdas: use preferred block comment style
2) staging: comedi: cb_pcimdas: update driver comment
3) staging: comedi: cb_pcimdas: add support for PCIe-DAS1602/16

 drivers/staging/comedi/Kconfig              |  4 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c | 82 ++++++++++++++++-------------
 2 files changed, 46 insertions(+), 40 deletions(-)
