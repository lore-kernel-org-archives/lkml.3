Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaHMFhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:37:18 -0400
Received: from thoros.lunarpages.com ([67.210.120.70]:41404 "EHLO
	thoros.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMFg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:36:56 -0400
From: "Ragnar B. Johannsson" <ragnar@igo.is>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ragnar B. Johannsson" <ragnar@igo.is>
Subject: [PATCH 0/3] staging: vt6656: cleanup
Date: Sun, 10 Aug 2014 22:23:47 +0000
Message-Id: <1407709430-61260-1-git-send-email-ragnar@igo.is>
X-Mailer: git-send-email 1.9.3
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thoros.lunarpages.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [0 0]
X-AntiAbuse: Sender Address Domain - igo.is
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a few small coding style problems as reported by checkpatch.

Ragnar B. Johannsson (3):
  staging: vt6656: remove unnecessary braces
  staging: vt6656: fix incorrect indentation
  staging: vt6656: add blank line after declaration

 drivers/staging/vt6656/rxtx.c    | 3 ++-
 drivers/staging/vt6656/usbpipe.c | 5 ++---
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.9.3

