Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaIDN72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:59:28 -0400
Received: from [61.3.105.134] ([61.3.105.134]:52028 "EHLO
	admin1-Lenovo-IdeaPad-Y510P" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750742AbaIDN71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:59:27 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2014 09:59:26 EDT
From: linux.delve@gmail.com
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com, anarey@gmail.com,
        rmfrfs@gmail.com, gdonald@gmail.com, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitra Ramaiah <linux.delve@gmail.com>
Subject: [PATCH] Staging: rtl8192u: fix brace style coding issue in r819xU_firmware.c
Date: Thu,  4 Sep 2014 19:20:59 +0530
Message-Id: <1409838660-3532-1-git-send-email-linux.delve@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chaitra Ramaiah <linux.delve@gmail.com>

*** BLURB HERE ***

root (1):
  Staging: rtl8192u: fix brace style coding issue in r819xU_firmware.c 
       This is a patch to the file r819xU_firmware.c that fixes a brace
    warning found by checkpatch.pl tool

 drivers/staging/rtl8192u/r819xU_firmware.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
1.7.9.5

