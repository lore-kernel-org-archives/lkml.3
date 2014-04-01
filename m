Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaDAQzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:55:10 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:19232 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaDAQzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:55:08 -0400
Message-ID: <40a25a421bbb355467f096b542f3354d@mwinf5d45.me-wanadoo.net>
From: Thomas Vegas <thomas_75@safe-mail.net>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Date: Tue, 1 Apr 2014 18:26:57 +0200
Subject: [PATCH v4 0/3] Various cleanups in drivers/staging/serqt_usb2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various cleanups in drivers/staging/serqt_usb2.

Thomas Vegas (3):
  staging: serqt_usb2: Remove useless variable
  staging: serqt_usb2: Add blank line after declaration
  staging: serqt_usb2: Clean up initializations of variables

 drivers/staging/serqt_usb2/serqt_usb2.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

-- 
1.7.2.5

