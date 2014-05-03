Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881AbaECFG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 01:06:58 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:46812 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaECFG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 01:06:57 -0400
Message-ID: <53647962.6070006@gmail.com>
Date: Sat, 03 May 2014 13:06:42 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>, a.zummo@towertech.it,
        sangjung.woo@samsung.com
CC: rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] drivers/rtc/rtc-puv3.c: fix 2 typo issues.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 2 typo issues for commit "1fbc4c4 drivers/rtc/rtc-puv3.c: use
dev_dbg() instead of pr_debug()".

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/rtc/rtc-puv3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
