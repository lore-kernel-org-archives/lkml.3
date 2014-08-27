Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965321AbaH0VG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:06:57 -0400
Received: from mail-we0-f201.google.com ([74.125.82.201]:50139 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859AbaH0VGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:06:55 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Baldyga <r.baldyga@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Small USB fixes/improvements
Date: Wed, 27 Aug 2014 22:58:44 +0200
Message-Id: <1409173129-19603-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently I've slept over 3.17 merge window, so I guess this is
for 3.18.  Rebased on top of balbi/usb.git next.

Michal Nazarewicz (4):
  usb: gadget: f_fs: add usb_functionfs_descs_head_v2 structure
  tools: ffs-test: convert to new descriptor format
  tools: ffs-test: add compatibility code for old kernels
  usb: gadget: f_mass_storage: simplify start_transfer slightly

Yang Wei (1):
  USB:gadget: Fix a warning while loading g_mass_storage

 drivers/usb/gadget/function/f_mass_storage.c |  33 +++----
 include/uapi/linux/usb/functionfs.h          |  12 ++-
 tools/usb/ffs-test.c                         | 126 ++++++++++++++++++++++++---
 3 files changed, 144 insertions(+), 27 deletions(-)

-- 
2.1.0.rc2.206.gedb03e5

