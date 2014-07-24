Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300AbaGXISN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:18:13 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:14812 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934120AbaGXISK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:18:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoJAFjA0FNXQzwl/2dsb2JhbABZgw6wOwUBAQEBAQEFAW4BoDmBChd3hGAjgRqIfQHAJYV7iQdJHYQwBZszlEKDSjuBMw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
        Fabian Frederick <fabf@skynet.be>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 00/10 linux-next] drivers/usb: remove unnecessary break after goto/return
Date: Thu, 24 Jul 2014 10:18:48 +0200
Message-Id: <1406189939-6433-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small patchset addressing break redundancy on drivers/usb branch
(suggested by Joe Perches).

Fabian Frederick (10):
  USB: iowarrior: remove unnecessary break after goto
  USB: usblcd: remove unnecessary break after return
  usb: dcw3: remove unnecessary break after return
  usb: gadget: remove unnecessary break after return
  usb: gadget: remove unnecessary break after goto
  xhci: remove unnecessary break after return
  usb: storage: remove unnecessary break after return
  USB: serial: remove unnecessary break after return
  USB: ftdi_sio: remove unnecessary break after return
  USB: microtek: remove unnecessary break after goto

 drivers/usb/dwc3/ep0.c                     | 2 --
 drivers/usb/gadget/function/f_hid.c        | 8 --------
 drivers/usb/gadget/legacy/tcm_usb_gadget.c | 2 --
 drivers/usb/host/xhci-mem.c                | 1 -
 drivers/usb/image/microtek.c               | 1 -
 drivers/usb/misc/iowarrior.c               | 3 ---
 drivers/usb/misc/usblcd.c                  | 1 -
 drivers/usb/serial/ftdi_sio.c              | 1 -
 drivers/usb/serial/iuu_phoenix.c           | 2 --
 drivers/usb/storage/freecom.c              | 1 -
 10 files changed, 22 deletions(-)

-- 
1.8.4.5

