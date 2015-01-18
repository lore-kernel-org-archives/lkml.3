Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbbARHeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 02:34:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbARHeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 02:34:36 -0500
Date: Sun, 18 Jan 2015 16:33:24 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Riley Andrews <riandrews@android.com>
Subject: [PATCH] MAINTAINERS: add Android driver entries
Message-ID: <20150118073324.GA12187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put down me, Arve, and Riley as maintainers for the android drivers.

Cc: Arve Hjønnevåg <arve@android.com>
Cc: Riley Andrews <riandrews@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


diff --git a/MAINTAINERS b/MAINTAINERS
index 3589d67437f8..95fd5c66ba09 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -708,6 +708,16 @@ X:	drivers/iio/*/adjd*
 F:	drivers/staging/iio/*/ad*
 F:	staging/iio/trigger/iio-trig-bfin-timer.c
 
+ANDROID DRIVERS
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+M:	Arve Hjønnevåg <arve@android.com>
+M:	Riley Andrews <riandrews@android.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/gregkh/staging.git
+L:	devel@driverdev.osuosl.org
+S:	Supported
+F:	drivers/android/
+F:	drivers/staging/android/
+
 AOA (Apple Onboard Audio) ALSA DRIVER
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linuxppc-dev@lists.ozlabs.org
