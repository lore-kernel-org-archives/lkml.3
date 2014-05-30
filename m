Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbaE3Jic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:38:32 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:38504 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaE3Jib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:38:31 -0400
Message-ID: <538851B0.7090609@gmail.com>
Date: Fri, 30 May 2014 11:38:56 +0200
From: Federico Di Pierro <nierro92@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove an unnecessary blank line in drivers/staging/xillybus/xillybus_of.c
Content-Type: multipart/mixed;
 boundary="------------000505040707020509080808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000505040707020509080808
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi!
This is my latest task of the eudyptula challenge.
Just a very small patch!

--------------000505040707020509080808
Content-Type: text/x-patch;
 name="eudyptula.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="eudyptula.patch"

Signed-off-by: Federico Di Pierro <nierro92@gmail.com>

--- xillybus_of.c	2014-05-30 11:27:18.160063074 +0200
+++ /home/federico/xillybus_of.c	2014-05-30 11:27:10.030063570 +0200
@@ -69,7 +69,6 @@
 				      int direction
 	)
 {
-	
 	dma_addr_t addr = 0;
 	struct xilly_dma *this;
 

--------------000505040707020509080808--
