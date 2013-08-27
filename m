Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3H0Hz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:55:28 -0400
Received: from 219-118-191-131.cust.bit-drive.ne.jp ([219.118.191.131]:47363
	"EHLO mail.omesemicon.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab3H0Hz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:55:27 -0400
From: Nguyen Viet Dung <nv-dung@jinso.co.jp>
To: linux-i2c@vger.kernel.org, wsa@the-dreams.de
Cc: linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com
Subject: [PATCH v3 0/1 resend] ARM: shmobile: r8a7790: add I2C support
Date: Tue, 27 Aug 2013 16:55:21 +0900
Message-Id: <1377590122-9309-1-git-send-email-nv-dung@jinso.co.jp>
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

