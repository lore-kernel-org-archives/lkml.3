Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaIDPLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:11:20 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48268 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbaIDPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:11:18 -0400
From: Chaitra Ramaiah <linux.delve@gmail.com>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com, anarey@gmail.com,
        rmfrfs@gmail.com, gdonald@gmail.com, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitra Ramaiah <linux.delve@gmail.com>
Subject: [PATCH] Staging: rtl8192u: fix brace style coding issue in r819xU_firmware.c
Date: Thu,  4 Sep 2014 20:41:02 +0530
Message-Id: <1409843463-3702-1-git-send-email-linux.delve@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    This is a patch to the file r819xU_firmware.c that fixes a brace
    warning found by checkpatch.pl tool

 drivers/staging/rtl8192u/r819xU_firmware.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
1.7.9.5

