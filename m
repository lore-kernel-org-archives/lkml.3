Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab3DWTSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:18:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40967 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab3DWTSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:18:43 -0400
Date: Tue, 23 Apr 2013 21:18:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        kernel@pengutronix.de
Subject: init-mainc-convert-to-pr_foo.patch is IMHO broken
Message-ID: <20130423191839.GK15233@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

init-mainc-convert-to-pr_foo.patch breaks the initcall_debug kernel
parameter. Before the patch I could add

	initcall_debug ignore_loglevel

to the kernel command line and got some additional output about
initcalls. Now that init/main.c uses pr_debug instead of
printk(KERN_DEBUG ...) the interesting statements are not compiled in
any more.

Best regards
Uwe

PS: sorry for not doing a proper reply but I didn't find something suitable
to reply to.


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
