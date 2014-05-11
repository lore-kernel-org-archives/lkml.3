Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbaEKIIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 04:08:37 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:64152 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601AbaEKIIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 04:08:34 -0400
From: Paul Davies C <pauldaviesc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, aaro.koskinen@iki.fi,
        devel@driverdev.osuosl.org, Paul Davies C <pauldaviesc@gmail.com>
Subject: [PATCH 0/3] Fix coding style of staging/octeon-usb/octeon-hcd.c
Date: Sun, 11 May 2014 13:38:20 +0530
Message-Id: <1399795703-6681-1-git-send-email-pauldaviesc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some coding styles issues with staging/octeon-usb/octeon-hcd.c.

Paul Davies C (3):
  Add blank line after all declarations in
    staging/octeon-usb/octeon-hcd.c
  Enclose complex macro with paranthese in
    staging/octeon-usb/octeon-hcd.c
  Fix lines with more than 80 chars in staging/octeon-usb/octeon-hcd.c

 drivers/staging/octeon-usb/octeon-hcd.c |  110 +++++++++++++++++++++++--------
 1 file changed, 84 insertions(+), 26 deletions(-)

-- 
1.7.9.5

