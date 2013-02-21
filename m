Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3BUTft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:35:49 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:48824
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab3BUTfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:35:48 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/4] Drivers: scsi: storvsc 
Date: Thu, 21 Feb 2013 12:04:20 -0800
Message-Id: <1361477060-17505-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set (two of the patches are being resent) fixes and enhances
the functionality of the Hyper-V storage driver

K. Y. Srinivasan (3):
  Drivers: scsi: storvsc: Initialize the sglist
  Drivers: scsi: storvsc: Restructure error handling code on command
    completion
  Drivers: scsi: storvsc: Handle dynamic resizing of the device

Olaf Hering (1):
  scsi: storvsc: avoid usage of WRITE_SAME

 drivers/scsi/storvsc_drv.c |  137 ++++++++++++++++++++++++++++++-------------
 1 files changed, 95 insertions(+), 42 deletions(-)

-- 
1.7.4.1

