Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaIPVOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:14:11 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:64608 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaIPVOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:14:09 -0400
From: Peter Ujfalusi <peter.ujfalusi@gmail.com>
To: dvhart@infradead.org, mjg59@srcf.ucam.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        peter.ujfalusi@gmail.com
Subject: [PATCH 0/2] intel-rst: Small cleanups
Date: Wed, 17 Sep 2014 00:13:54 +0300
Message-Id: <1410902036-10282-1-git-send-email-peter.ujfalusi@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While trying to figure out why the intel-rst driver was not probing on my new
laptop (which turned out to be a differnet issue) I looked at the intel-rst
driver for clues and while reading the code I thought that these small changes
might be a good thing to send upstream.

Regards,
Peter
---
Peter Ujfalusi (2):
  intel-rst: Use ACPI_FAILURE() macro instead !ACPI_SUCCESS() for error
    checking
  intel-rst: Clean up ACPI add function

 drivers/platform/x86/intel-rst.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

-- 
2.1.0

