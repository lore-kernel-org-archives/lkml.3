Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaHUJWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:22:09 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65134 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaHUJWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:22:07 -0400
From: Zhu Yanjun <zyjzyj2000@gmail.com>
X-Google-Original-From: Zhu Yanjun <Yanjun.Zhu@windriver.com>
To: linux-kernel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        zyjzyj2000@gmail.com
Cc: Zhu Yanjun <Yanjun.Zhu@windriver.com>
Subject: [PATCH 0/1] net:fec: buffer descriptor member variable order in IMX6 
Date: Thu, 21 Aug 2014 17:21:54 +0800
Message-Id: <1408612915-8657-1-git-send-email-Yanjun.Zhu@windriver.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Reference Manual, freescale IMX6 is little endian 
mode. Therefore the member variables in buffer 
descriptor should be length, status and so on.

Zhu Yanjun (1):
  net:fec: buffer descriptor member variable order in IMX6

 drivers/net/ethernet/freescale/fec.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.9.1

