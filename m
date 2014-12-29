Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaL2OaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:30:08 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:1394 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbaL2OaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:30:04 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswNAEhkoVRXQ5FV/2dsb2JhbABcgwa1UAUBAQEBAQEFAXeXNoENFwEBAQEBfYRpI4EaiGcBtCiPP4YDiXQdhBMFlwiRUCKBRQGCKT2CdAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        openipmi-developer@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 00/11 linux-next] drivers: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:29:34 +0100
Message-Id: <1419863387-24233-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset removes unnecessary version.h includes detected by
versioncheck in drivers branch.

Fabian Frederick (11):
  rsxx: remove unnecessary version.h inclusion
  skd: remove unnecessary version.h inclusion
  ipmi: remove unnecessary version.h inclusion
  input: remove unnecessary version.h inclusion
  [media] tw68: remove unnecessary version.h inclusion
  [media] s5p-g2d: remove unnecessary version.h inclusion
  [media] s5p-mfc: remove unnecessary version.h inclusion
  [media] vivid: remove unnecessary version.h inclusion
  [media] uvcvideo: remove unnecessary version.h inclusion
  GenWQE: remove unnecessary version.h inclusion
  s390/hmcdrv: remove unnecessary version.h inclusion

 drivers/block/rsxx/rsxx_priv.h               | 1 -
 drivers/block/skd_main.c                     | 1 -
 drivers/char/ipmi/ipmi_ssif.c                | 1 -
 drivers/input/touchscreen/elants_i2c.c       | 2 --
 drivers/media/pci/tw68/tw68.h                | 1 -
 drivers/media/platform/s5p-g2d/g2d.c         | 1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 1 -
 drivers/media/platform/vivid/vivid-tpg.h     | 1 -
 drivers/media/usb/uvc/uvc_v4l2.c             | 1 -
 drivers/misc/genwqe/card_base.h              | 1 -
 drivers/misc/genwqe/card_sysfs.c             | 1 -
 drivers/s390/char/hmcdrv_mod.c               | 1 -
 13 files changed, 14 deletions(-)

-- 
2.1.0

