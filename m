Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaC0AG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:06:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50037 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbaC0AGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:06:54 -0400
From: Felipe Balbi <balbi@ti.com>
To: Balaji T K <balajitk@ti.com>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 0/5] mmc: host: omap_hsmmc: a few improvements
Date: Wed, 26 Mar 2014 19:04:45 -0500
Message-ID: <1395878690-9650-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series lets us access the newer registers introduced
back in OMAP4 which give us some valid information about
the OMAP HSMMC IP like max block size, support for ADMA,
support for Retention.

Right now, only setting max_blk_size correctly as supporting
ADMA and Retention will take a lot of work.

Tested on OMAP5 uEVM.

Felipe Balbi (5):
  mmc: host: omap_hsmmc: pass host as an argument
  mmc: host: omap_hsmmc: add reg_offset field
  mmc: host: omap_hsmmc: introduce new accessor functions
  mmc: host: omap_hsmmc: switch over to new accessors
  mmc: host: omap_hsmmc: set max_blk_size correctly

 drivers/mmc/host/omap_hsmmc.c | 291 ++++++++++++++++++++++++++----------------
 1 file changed, 182 insertions(+), 109 deletions(-)

-- 
1.9.1.286.g5172cb3

