Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaDTDh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 23:37:29 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41826 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbaDTDhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 23:37:23 -0400
X-Sasl-enc: 9PlqO/C7Y2PpF+JjTKv1Ny8QSjDBswbAgkp3wpK0DYap 1397965041
Message-ID: <535340D6.9080604@fastmail.fm>
Date: Sun, 20 Apr 2014 11:36:54 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] staging: gdm72xx: Minor cleanup
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm>
In-Reply-To: <53534051.2020504@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removed line related to replacement of kernel_thread with kthread,
as issue was fixed on ff5e4a1d2702582614996f6f6d005e9b5caadeb8.

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

