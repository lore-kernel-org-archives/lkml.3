Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbbAHJAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:00:14 -0500
Received: from mout.gmx.net ([212.227.15.18]:50844 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971AbbAHJAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:00:10 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] clk support for Alphascale asm9260
Date: Thu,  8 Jan 2015 09:59:26 +0100
Message-Id: <1420707567-22760-1-git-send-email-linux@rempel-privat.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417187120-23659-1-git-send-email-linux@rempel-privat.de>
References: <1417187120-23659-1-git-send-email-linux@rempel-privat.de>
X-Provags-ID: V03:K0:6HYausj6MyOZQefifVcCMHHv/Sq7U/JCTjFS3eEStLf6IwLunOx
 zosltT13GyKR0tGU+2YoOdiFjGIWXinEyJ7gLgwx5T/cWJ/omT2rHsLQaSF9v8/TvPuRpf+
 BRCx+/9Sq6p9FnIjx2KRHW1dxIoeTSGrgXuq6ZCIPSdq29QD1TZ67rL++sDelFOslC7KM6I
 uGzZfmoQdh3/EPuZI+XMA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
this patch provides clk support for Alphascale asm9260 SoC.
As was suggested by one of ARM maintainers, I explicitly ask you to
merge this patch :D

Oleksij Rempel (1):
  ARM: clk: add clk-asm9260 driver

 drivers/clk/Makefile                           |   1 +
 drivers/clk/clk-asm9260.c                      | 359 +++++++++++++++++++++++++
 include/dt-bindings/clock/alphascale,asm9260.h |  97 +++++++
 3 files changed, 457 insertions(+)
 create mode 100644 drivers/clk/clk-asm9260.c
 create mode 100644 include/dt-bindings/clock/alphascale,asm9260.h

-- 
1.9.1

