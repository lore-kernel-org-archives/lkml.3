Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbbATMaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:30:20 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48931 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbbATMaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:30:16 -0500
From: Olivier Sobrie <olivier@sobrie.be>
To: Jan Dumon <j.dumon@option.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Olivier Sobrie <olivier@sobrie.be>
Subject: [PATCH 01/11] hso: remove useless header file timer.h
Date: Tue, 20 Jan 2015 13:29:28 +0100
Message-Id: <1421756978-4093-2-git-send-email-olivier@sobrie.be>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1421756978-4093-1-git-send-email-olivier@sobrie.be>
References: <1421756978-4093-1-git-send-email-olivier@sobrie.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No timer related function is used in this driver.

Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
---
 drivers/net/usb/hso.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index babda7d..cb0bcc1 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -58,7 +58,6 @@
 #include <linux/module.h>
 #include <linux/ethtool.h>
 #include <linux/usb.h>
-#include <linux/timer.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
-- 
2.2.0

