Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3HVCaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:30:21 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:39760 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3HVCaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:30:18 -0400
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: gregkh@linuxfoundation.org, oliver@neukum.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Enrico Mioso <mrkiko.rs@gmail.com>
Subject: [PATCH RESEND net-next V2 0/3] huawei_cdc_ncm introduction
Date: Thu, 22 Aug 2013 04:30:38 +0200
Message-Id: <1377138641-2765-1-git-send-email-mrkiko.rs@gmail.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <mrkiko.rs@gmail.com>
References: <mrkiko.rs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These patches are all related to the new huawei_cdc_ncm driver, supporting 
devices that use the NCM protocol as a transport layer for other protocols. 
this is the case of the Huawei E3131 3G modem.
Thanks should go to bjorn and others who helped me with patience.

Enrico Mioso (3):
  net: cdc_ncm: Export cdc_ncm_{tx,rx}_fixup functions for re-use
  net: huawei_cdc_ncm: Introduce the
  net: cdc_ncm: remove non-standard NCM device IDs

 drivers/net/usb/Kconfig     |   11 +++++++++++
 drivers/net/usb/Makefile    |    1 +
 drivers/net/usb/cdc_ncm.c   |   17 ++++-------------
 include/linux/usb/cdc_ncm.h |    3 +++
 4 files changed, 19 insertions(+), 13 deletions(-)

-- 
This version includes mainly cosmetic fixes related to patches.
1.7.10.4

