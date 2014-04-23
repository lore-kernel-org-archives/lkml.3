Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaDWApG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 20:45:06 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34127 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbaDWApE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 20:45:04 -0400
X-Sasl-enc: jLSse0tJiEcCUPb0/OMcYgtIVx12EPRK158z6QV/tntD 1398213903
Message-ID: <53570CF0.70607@fastmail.fm>
Date: Wed, 23 Apr 2014 08:44:32 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] staging: gdm72xx: Removed completed task from TODO
 list
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm>
In-Reply-To: <53570BAA.3080709@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removed line related to replacement of kernel_thread with kthread, as issue 
was fixed on ff5e4a1d2702 ('Staging: gdm72xx: gdm_usb: fix deprecated function 
kernel_thread')

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/TODO | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/gdm72xx/TODO b/drivers/staging/gdm72xx/TODO
index 5ab27fb..62d0cd6 100644
--- a/drivers/staging/gdm72xx/TODO
+++ b/drivers/staging/gdm72xx/TODO
@@ -1,3 +1,2 @@
 TODO:
-- Replace kernel_thread with kthread in gdm_usb.c
 - Clean up coding style to meet kernel standard.
-- 
1.7.12.1

