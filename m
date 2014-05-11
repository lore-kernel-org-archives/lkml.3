Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaEKNLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 09:11:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41056 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaEKNLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 09:11:43 -0400
From: Paul Davies C <pauldaviesc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, aaro.koskinen@iki.fi,
        devel@driverdev.osuosl.org, Paul Davies C <pauldaviesc@gmail.com>
Subject: [PATCH v2 0/2] drivers: staging: octeon-usb: Fix coding style
Date: Sun, 11 May 2014 18:41:31 +0530
Message-Id: <1399813893-4910-1-git-send-email-pauldaviesc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399795703-6681-1-git-send-email-pauldaviesc () gmail ! com>
References: <1399795703-6681-1-git-send-email-pauldaviesc () gmail ! com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding style issues in drivers/staging/octeon-usb/octeon-hcd.c.

Paul Davies C (2):
  Add blank line after all declarations in
    staging/octeon-usb/octeon-hcd.c
  Fix lines with more than 80 chars in staging/octeon-usb/octeon-hcd.c

 drivers/staging/octeon-usb/octeon-hcd.c |  108 ++++++++++++++++++++++++-------
 1 file changed, 83 insertions(+), 25 deletions(-)

-- 
1.7.9.5

