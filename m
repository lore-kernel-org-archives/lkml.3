Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab3CTMK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:10:29 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33475 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3CTMK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:10:27 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: santosh.shilimkar@ti.com, khilman@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: GPIO - Fix checkpatch errors 
Date: Wed, 20 Mar 2013 13:15:54 +0100
Message-Id: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fix almost all checkpatch errors in drivers/gpio/

 drivers/gpio/gpio-mvebu.c      |   26 +++++++++++++-------------
 drivers/gpio/gpio-omap.c       |    2 +-
 drivers/gpio/gpio-pca953x.c    |    3 +--
 drivers/gpio/gpio-pxa.c        |    4 ++--
 drivers/gpio/gpio-sch.c        |   74 +++++++++++++++++++++++++++++++++++---------------------------------------
 drivers/gpio/gpio-stp-xway.c   |    2 +-
 drivers/gpio/gpio-tc3589x.c    |    8 ++++----
 drivers/gpio/gpio-timberdale.c |    3 +--
 drivers/gpio/gpio-tps65910.c   |    2 +-
 drivers/gpio/gpiolib-of.c      |    2 +-
 10 files changed, 60 insertions(+), 66 deletions(-)

Regards,
Laurent Navet.

