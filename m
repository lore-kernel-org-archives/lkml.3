Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab3BMKXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:23:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39139 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3BMKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:23:29 -0500
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: kernel@pengutronix.de, artem.bityutskiy@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [RFC PATCH 0/5] UBIFS: improve xattr and add support for security.* XATTR
Date: Wed, 13 Feb 2013 11:23:13 +0100
Message-Id: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patch series is based on Subodh Nijsure's patch [1] from May 2012. I've
splitted up the patch into smaller changes and fixed a locking problem. This
series is tested on mx28-evk with NAND. However, With lockdep enabled a
possible circular locking dependency is detected, as reported in [2]. Otherwise
the system is stable.

Please review and comment, regards,
Marc

[1] http://lists.infradead.org/pipermail/linux-mtd/2012-May/041503.html
[2] http://www.spinics.net/lists/kernel/msg1480694.html

