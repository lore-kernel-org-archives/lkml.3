Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaFPO67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:58:59 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:48550 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467AbaFPO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:58:57 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 10:58:57 EDT
X-RRZE-Submit-IP: 131.188.42.190
From: Stephan Gabert <stephan.gabert@fau.de>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: nicolas.pfeiffer@fau.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Stephan Gabert <stephan.gabert@fau.de>
Subject: [PATCH 0/5] staging/wlags49_h2: fixed up wl_cs.c
Date: Mon, 16 Jun 2014 16:50:48 +0200
Message-Id: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The appended patches fix up wl_cs.c from the wireless device driver wlags49
of Agere Systems Inc.

Most modifications resulted from checkpatch.pl.

Stephan Gabert (5):
  staging/wlags49_h2: checkpatch: including <linux/*.h> instead of
    <asm/*.h>
  staging/wlags49_h2: checkpatch: added spaces around equal sign
  staging/wlags49_h2: correct check of the return value of
    register_netdev()
  staging/wlags49_h2: convert printk calls to netdev_* calls
  staging/wlags49_h2: checkpatch: line over 80 characters

 drivers/staging/wlags49_h2/wl_cs.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

-- 
1.9.1

