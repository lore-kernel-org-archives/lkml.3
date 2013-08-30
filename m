Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3H3M6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:58:18 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62299 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3H3M6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:58:17 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH 0/1] Humusoft MF624 DAQ PCI card driver
Date: Fri, 30 Aug 2013 14:58:01 +0200
Message-Id: <1377867482-22539-1-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds UIO Driver for Humusoft MF624 DAQ PCI card.
Somebody may ask why UIO driver, not a Comedi driver.
The very original idea was to use the MF624 with UIO to teach students
(at Czech Technical University in Prague, Faculty of Electrical Engineering)
how to interact with hardware in C -- comfortably from user-space.
Some computers at FEE, CTU are already equipped with these cards --
however for those students who would want to work at home/with their own
computer there is also an implementation of the virtual MF624 for Qemu.
Unfortunately it is still not in mainline, available from git:
git://rtime.felk.cvut.cz/mf6xx.git


Rostislav Lisovy (1):
  drivers: uio: Add driver for Humusoft MF624 DAQ PCI card

 drivers/uio/Kconfig     |   13 +++
 drivers/uio/Makefile    |    1 +
 drivers/uio/uio_mf624.c |  247 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 261 insertions(+)
 create mode 100644 drivers/uio/uio_mf624.c

-- 
1.7.10.4

