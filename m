Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaJOKA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:00:58 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60763 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaJOKAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:00:50 -0400
From: Zhu Yanjun <zyjzyj2000@gmail.com>
X-Google-Original-From: Zhu Yanjun <Yanjun.Zhu@windriver.com>
To: sandeep.kumar@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yue.Tao@windriver.com,
        guang.yang@windriver.com, joe@perches.com, festevam@gmail.com,
        richardcochran@gmail.com, clarocq@gmail.com,
        yongjun_wei@trendmicro.com.cn, claudiu.manoil@freescale.com, w@1wt.eu,
        roy.xu@huawei.com, sky.wangfeng@huawei.com, zyjzyj2000@gmail.com
Cc: Zhu Yanjun <Yanjun.Zhu@windriver.com>
Subject: [PATCH] gianfar: disable vlan tag insertion by default on 2.6.x
Date: Wed, 15 Oct 2014 18:00:33 +0800
Message-Id: <1413367234-28652-1-git-send-email-Yanjun.Zhu@windriver.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit f43c75d4b6[gianfar: disable TX vlan based on kernel 2.6.x],
gianfar nic disables TX vlan. But gianfar nic enables vlan tag 
insertion by default. This will lead to unusable connections on 
some configurations. Since vlan tag insertion is disabled by default 
and it is not enabled any longer, it is not necessary to disable it again.

Zhu Yanjun (1):
  gianfar: disable vlan tag insertion by default

 drivers/net/gianfar.c | 6 ------
 1 file changed, 6 deletions(-)

-- 
1.9.1

