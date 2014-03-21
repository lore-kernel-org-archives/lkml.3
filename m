Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbaCUIiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:38:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47345 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760322AbaCUIiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:38:05 -0400
X-Sasl-enc: 1ESSK9m+nshqileftcgnUniXGNdWyjrCS47Ne/ja2LpC 1395391080
Message-ID: <532BFA61.8070801@fastmail.fm>
Date: Fri, 21 Mar 2014 16:37:53 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131204 Thunderbird/17.0.11
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: gdm72xx: Removed task from TODO list
References: <532BF9B0.2080008@fastmail.fm>
In-Reply-To: <532BF9B0.2080008@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removed task related to replacement of kernel_thread with kthread,
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

