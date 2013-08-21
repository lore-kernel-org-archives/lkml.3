Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3HUKDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:03:40 -0400
Received: from 219-118-191-131.cust.bit-drive.ne.jp ([219.118.191.131]:38718
	"EHLO mail.omesemicon.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051Ab3HUKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:03:39 -0400
From: Nguyen Viet Dung <nv-dung@jinso.co.jp>
To: linux-i2c@vger.kernel.org, wsa@the-dreams.de
Cc: linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com
Subject: [PATCH v3 0/1] ARM: shmobile: r8a7790: add I2C support
Date: Wed, 21 Aug 2013 19:03:37 +0900
Message-Id: <1377079418-9260-1-git-send-email-nv-dung@jinso.co.jp>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram
CC Morimoto

Please consider the following patch for the r8a7790 Soc.
This patch modify I2C driver of rcar-H1 to usable on both rcar-H1 and rcar-H2.
It was developed base on the renesas-devel-20130722 branch and
have tested on the Lager board.

V3: Using the ID tables to resolve the difference between H1 and H2.

Thanks,
Nguyen viet Dung

Nguyen Viet Dung (1):
  i2c: rcar: modify I2C driver

 drivers/i2c/busses/i2c-rcar.c |   37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

-- 
1.7.9.5

