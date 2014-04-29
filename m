Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaD2CYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:24:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45600 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbaD2CYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:24:16 -0400
X-Sasl-enc: G8I7SrB5cdVqqmHraJtKPmqCEnMVg4laOL6imwWndNJI 1398738255
Message-ID: <535F0D2D.9020103@fastmail.fm>
Date: Tue, 29 Apr 2014 10:23:41 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/10] staging: gdm72xx: Removed task from TODO list
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda> <53577E96.10106@fastmail.fm> <20140423090557.GU26890@mwanda> <20140423090904.GV26890@mwanda> <535F0866.2060207@fastmail.fm>
In-Reply-To: <535F0866.2060207@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removed line related to replacement of kernel_thread with kthread,
as issue was fixed on ff5e4a1d2702 ('Staging: gdm72xx: gdm_usb:
fix deprecated function kernel_thread')

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
1.8.4

