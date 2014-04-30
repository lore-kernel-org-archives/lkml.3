Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbaD3ICB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:02:01 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35629 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaD3IB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:01:56 -0400
From: Toby Smith <toby@tismith.id.au>
To: linus.walleij@linaro.org, gnurou@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Toby Smith <toby@tismith.id.au>
Subject: [PATCH 0/2] gpio: pca953x: allow shared interrupts
Date: Wed, 30 Apr 2014 18:01:39 +1000
Message-Id: <cover.1398844809.git.toby@tismith.id.au>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches allow the pca953x family of chips to use a 
shared interrupt.

Toby Smith (2):
  gpio: pca953x: return IRQ_NONE when appropriate
  gpio: pca953x: request a shared interrupt

 drivers/gpio/gpio-pca953x.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
1.8.3.2

