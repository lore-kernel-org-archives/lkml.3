Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaJSNKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 09:10:49 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40064 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaJSNKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 09:10:47 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Greg Donald <gdonald@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Artem Fetishev <wwctrsrx@gmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Remove checkpatch.pl errors from drivers/staging/ft1000
Date: Sun, 19 Oct 2014 20:59:43 +0800
Message-Id: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches remove following code style errors from drivers/staging/ft1000:

ERROR: do not initialise statics to 0 or NULL
ERROR: spaces required around that '=' (ctx:VxV)
ERROR: spaces required around that '<' (ctx:VxV)
ERROR: spaces required around that '==' (ctx:VxV)
ERROR: space required after that ',' (ctx:VxV)
ERROR: else should follow close brace '}'
ERROR: space prohibited after that open parenthesis '('
ERROR: space prohibited before that close parenthesis ')'
ERROR: space prohibited after that '&' (ctx:WxW)
ERROR: "(foo*)" should be "(foo *)"
ERROR: "foo * bar" should be "foo *bar"

Chen Weixiang (7):
  staging: ft1000: do not initialise statics to 0 or NULL
  staging: ft1000: spaces required around that '=', '<' and '=='
  staging: ft1000: space required after that ','
  staging: ft1000: else should follow close brace '}'
  staging: ft1000: space prohibited after '(' and '&', before ')'
  staging: ft1000: "(foo*)" should be "(foo *)"
  staging: ft1000: "foo * bar" should be "foo *bar"

 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 55 +++++++++++-------------
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 50 ++++++++++-----------
 2 files changed, 50 insertions(+), 55 deletions(-)

-- 
2.1.1

