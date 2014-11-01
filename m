Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbaKACrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 22:47:45 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54780 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaKACro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 22:47:44 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
        Daniel Dodge <danieldodgese@gmail.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] Remove checkpatch.pl errors from drivers/staging/ft1000
Date: Sat,  1 Nov 2014 10:47:21 +0800
Message-Id: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the version 2 of the patch series. The following code style error is
removed from the patch because it was already merged into Greg K-H staging.tree:

ERROR: do not initialise statics to 0 or NULL

This patch series are removing following code style errors from
drivers/staging/ft1000:

ERROR: spaces required around that '=' (ctx:VxV)
ERROR: spaces required around that '<' (ctx:VxV)
ERROR: spaces required around that '==' (ctx:VxV)
ERROR: space prohibited after that open parenthesis '('
ERROR: space prohibited before that close parenthesis ')'
ERROR: space prohibited after that '&' (ctx:WxW)
ERROR: "(foo*)" should be "(foo *)"
ERROR: "foo * bar" should be "foo *bar"
ERROR: else should follow close brace '}'
ERROR: space required after that ',' (ctx:VxV)

Chen Weixiang (6):
  staging: ft1000: spaces required around that '=', '<' and '=='
  staging: ft1000: space prohibited after '(', '&' and before ')'
  staging: ft1000: "(foo*)" should be "(foo *)"
  staging: ft1000: "foo * bar" should be "foo *bar"
  staging: ft1000: else should follow close brace '}'
  staging: ft1000: space required after that ','

 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 55 +++++++++++-------------
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 54 ++++++++++++-----------
 2 files changed, 54 insertions(+), 55 deletions(-)

-- 
2.1.2

