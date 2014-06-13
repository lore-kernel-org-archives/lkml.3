Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaFMNi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:38:26 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:50504 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaFMNiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:38:14 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: [PATCHv4 0/6] Various small USB fixes
Date: Fri, 13 Jun 2014 15:38:03 +0200
Message-Id: <1402666689-4971-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Nazarewicz (6):
  usb: gadget: f_fs: resurect usb_functionfs_descs_head structure
  tools: ffs-test: fix header values endianess
  usb: gadget: f_fs: add usb_functionfs_descs_head_v2 structure
  tools: ffs-test: convert to new descriptor format
  tools: ffs-test: add compatibility code for old kernels
  usb: gadget: f_mass_storage: Fix a warning while loading
    g_mass_storage

 drivers/usb/gadget/f_mass_storage.c |  54 ++++++++++------
 include/uapi/linux/usb/functionfs.h |  19 +++++-
 tools/usb/ffs-test.c                | 124 +++++++++++++++++++++++++++++++++---
 3 files changed, 166 insertions(+), 31 deletions(-)

-- 
2.0.0.526.g5318336

