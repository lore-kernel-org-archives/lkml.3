Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab3LaBgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 20:36:49 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34799 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3LaBgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 20:36:48 -0500
From: Rostislav Lisovy <lisovy@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: pisa@cmp.felk.cvut.cz, Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH] comedi: Humusoft MF634 and MF624 DAQ cards driver
Date: Tue, 31 Dec 2013 02:36:35 +0100
Message-Id: <1388453796-17088-1-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Comedi driver for Humusoft MF634 (PCIe) and MF624 (PCI)
data acquisition cards. The legacy card Humusoft MF614 is not supported.
More info about the cards may be found at http://humusoft.cz/produkty/datacq/
The driver was tested with both cards. Everything seems to work properly.
Just the basic functionality of the card (DIO, ADC, DAC) is supported by
this driver. I hope I will be able to add some more functionality soon.

Rostislav Lisovy (1):
  comedi: Humusoft MF634 and MF624 DAQ cards driver

 drivers/staging/comedi/Kconfig          |   6 +
 drivers/staging/comedi/drivers/Makefile |   1 +
 drivers/staging/comedi/drivers/mf6x4.c  | 368 ++++++++++++++++++++++++++++++++
 3 files changed, 375 insertions(+)
 create mode 100644 drivers/staging/comedi/drivers/mf6x4.c

-- 
1.8.3.2

