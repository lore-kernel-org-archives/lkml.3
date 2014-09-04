Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaIDOKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:10:13 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42093 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaIDOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:10:12 -0400
From: Chaitra Ramaiah <linux.delve@gmail.com>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com, anarey@gmail.com,
        rmfrfs@gmail.com, gdonald@gmail.com, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitra Ramaiah <linux.delve@gmail.com>
Subject: [PATCH] Staging: rtl8192u: fix brace style coding issue in r819xU_firmware.c
Date: Thu,  4 Sep 2014 19:39:11 +0530
Message-Id: <1409839752-4205-1-git-send-email-linux.delve@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** BLURB HERE ***

root (1):
  Staging: rtl8192u: fix brace style coding issue in r819xU_firmware.c 
       This is a patch to the file r819xU_firmware.c that fixes a brace
    warning found by checkpatch.pl tool

 drivers/staging/rtl8192u/r819xU_firmware.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
1.7.9.5

