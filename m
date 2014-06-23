Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaFWHvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:51:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60106 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaFWHvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:51:53 -0400
X-AuditID: cbfee61b-f79f86d00000144c-ab-53a7dc964115
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 00/11] usb: dwc2/gadget: fix series
Date: Mon, 23 Jun 2014 09:51:19 +0200
Message-id: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e+xoO60O8uDDe5/lrWY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CV0bNyE0vBb46KrmsuDYxz2LsYOTkkBEwkHiz8wgphi0lc
	uLeerYuRi0NIYDqjxIz57YwQTjuTxNKTHYwgVWwCOhJbvk8As0UEBCTWv7jEDlLELHCCUaLj
	/wU2kISwgLHE+eOrWUBsFgFViWUbFoHFeQVcJe6+nccMsU5O4uSxyawTGLkXMDKsYhRNLUgu
	KE5KzzXSK07MLS7NS9dLzs/dxAgOl2fSOxhXNVgcYhTgYFTi4dVwWx4sxJpYVlyZe4hRgoNZ
	SYS3sQEoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgXH2
	dN9tU+3CS3h7XdhuVF76ZHR4ntE9bda7v4K/Ts67nNyZt2+CbsK+Ce2HlmcmL1Xf2Tj92+rV
	yqF1M/4oqtx7eWjTTH2DAv0FAT69m3v1NbZfVT6lqfauyvWOrjkz66KXf8TP71OcJCoaxe4b
	rn74lEnBpan/k6/Z/pri/PLW+rJvPZZvPqxQYinOSDTUYi4qTgQANoKgiRMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains fixes for dwc2 gadget driver. It touches PHY,
FIFO configuration, initialization sequence and adds many other small fixes.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Andrzej Pietrasiewicz (1):
  usb: dwc2/gadget: Fix comment text

Kamil Debski (3):
  usb: dwc2/gadget: fix phy disable sequence
  usb: dwc2/gadget: fix phy initialization sequence
  usb: dwc2/gadget: move phy bus legth initialization

Marek Szyprowski (5):
  usb: dwc2/gadget: hide some not really needed debug messages
  usb: dwc2/gadget: ensure that all fifos have correct memory buffers
  usb: dwc2/gadget: break infinite loop in endpoint disable code
  usb: dwc2/gadget: do not call disconnect method in pullup
  usb: dwc2/gadget: delay enabling irq once hardware is configured
    properly

Robert Baldyga (2):
  usb: dwc2/gadget: assign TX FIFO dynamically
  usb: dwc2/gadget: disable clock when it's not needed

 drivers/usb/dwc2/core.h   |   2 +
 drivers/usb/dwc2/gadget.c | 150 ++++++++++++++++++++++++++++------------------
 2 files changed, 93 insertions(+), 59 deletions(-)

-- 
1.9.1

