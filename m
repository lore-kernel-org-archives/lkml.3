Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaCaS01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:26:27 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:39078 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaCaS00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:26:26 -0400
Message-ID: <25a5637da5a833ba768cdb994f0a2030@mwinf5d64.me-wanadoo.net>
From: Thomas Vegas <thomas_75@safe-mail.net>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Date: Mon, 31 Mar 2014 19:57:43 +0200
Subject: [PATCH v3 0/2] Fix coding style for drivers/staging/serqt_usb2.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style in drivers/staging/serqt_usb2.

Thomas Vegas (2):
  staging: serqt_usb2: Add blank lines after declarations.
  staging: serqt_usb2: Clean up initializations of variables.

 drivers/staging/serqt_usb2/serqt_usb2.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

-- 
1.8.3.2

