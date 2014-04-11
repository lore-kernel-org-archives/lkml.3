Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423098AbaDKQkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:40:13 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:37017 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759767AbaDKQj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:39:29 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.55.196]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 11 Apr 2014 19:39:06 +0300
Message-ID: <CAK=WgbYgnu38wGr3gGg_k5ULguQHYPitJyoyb-QO0z3CwCrAUw@mail.gmail.com>
Subject: [GIT PULL] remoteproc cleanups for 3.15
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Jingoo Han <jg1.han@samsung.com>, Julia Lawall <Julia.Lawall@lip6.fr>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
tags/remoteproc-3.15-cleanups

for you to fetch changes up to bd88acba5f9809af48f66267bb16024b9e33cf2b:

  remoteproc/ste_modem: staticize local symbols (2014-02-24 11:16:16 +0200)

----------------------------------------------------------------
Several remoteproc cleanup patches coming from Jingoo Han, Julia
Lawall and Uwe Kleine-König.

----------------------------------------------------------------
Jingoo Han (1):
      remoteproc/ste_modem: staticize local symbols

Julia Lawall (1):
      remoteproc/davinci: simplify use of devm_ioremap_resource

Uwe Kleine-König (1):
      remoteproc/davinci: drop needless devm_clk_put

 drivers/remoteproc/da8xx_remoteproc.c | 16 +---------------
 drivers/remoteproc/ste_modem_rproc.c  |  4 ++--
 2 files changed, 3 insertions(+), 17 deletions(-)
