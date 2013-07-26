Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700Ab3GZVhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:37:43 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64179 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760692Ab3GZVhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:37:15 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: [PATCH] mfd: input: arm: dts: doc: ti_am335x: typo fix (coordiante -> coordinate)
Date: Fri, 26 Jul 2013 22:37:09 +0100
Message-Id: <1374874630-25457-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Small typo fix. Received ack from mfd already.
Awaiting acks from all the rest.

As Lee from mfd stated, we can remove these during staging now.
or we'll have to leave typos as is later on.

Zubair Lutfullah (1):
  mfd: input: arm: dts: doc: ti_am335x: typo fixes (coordiante ->
    coordinate)

 .../bindings/input/touchscreen/ti-tsc-adc.txt      |    4 ++--
 arch/arm/boot/dts/am335x-evm.dts                   |    2 +-
 drivers/input/touchscreen/ti_am335x_tsc.c          |    2 +-
 drivers/mfd/ti_am335x_tscadc.c                     |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.7.9.5

