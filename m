Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbaIIHko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:40:44 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56881 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbaIIHkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:40:41 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-leds@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Bryan Wu <cooloney@gmail.com>
Subject: make ledtrig-gpio useable with GPIO drivers requiring threaded irqs
Date: Tue,  9 Sep 2014 09:40:31 +0200
Message-Id: <1410248433-24005-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches make it possible to use the ledtrig-gpio driver with
GPIO drivers that require threaded IRQs (like the PCA953x I2C driver).
It has been tested with a PCA9554 chip on an i.MX28 module.
