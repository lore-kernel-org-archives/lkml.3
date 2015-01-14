Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbbANKTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:19:23 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:54847 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbbANKTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:19:21 -0500
From: Moritz Fischer <moritz.fischer@ettus.com>
To: rjw@rjwysocki.net
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moritz Fischer <moritz.fischer@ettus.com>
Subject: [PATCH] Fix checkpatch warning in drivers/acpi/nvs.c
Date: Wed, 14 Jan 2015 11:18:52 +0100
Message-Id: <1421230733-24149-1-git-send-email-moritz.fischer@ettus.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

attached a simple patch fixing a checkpatch warning about
printk(KERN_INFO vs pr_info.

Moritz Fischer (1):
  acpi: nvs: Fixed checkpatch.pl warning.

 drivers/acpi/nvs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
1.9.3

