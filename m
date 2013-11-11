Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3KKJ21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:28:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53916 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3KKJ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:28:19 -0500
Date: Mon, 11 Nov 2013 10:28:15 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: mm-factor-commit-limit-calculation-fix broken on ARM-nommu
Message-ID: <20131111092815.GJ14892@pengutronix.de>
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

Hello Andrew,

in mm-factor-commit-limit-calculation-fix you move vm_commit_limit to
mm/mmap.c. This file is only compiled with CONFIG_MMU on though. So my
build fails here.

There are some more problems that I didn't look into yet, but if you
want to look into it, efm32_defconfig for ARCH=arm is what I'm seeing
broken.

best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
