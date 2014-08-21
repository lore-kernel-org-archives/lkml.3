Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaHUQCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:02:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36178 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbaHUQCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:02:50 -0400
From: Nishanth Menon <nm@ti.com>
To: Dmitry Torokhov <dtor@mail.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 0/2] Input: palmas: add support for palmas power button
Date: Thu, 21 Aug 2014 11:02:13 -0500
Message-ID: <1408636935-29515-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408392810-16011-1-git-send-email-nm@ti.com>
References: <1408392810-16011-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many Palmas PMIC variants have support for power button feature. This
feature depends on certain One Time Program (OTP) and board pull
configurations (POWERHOLD signal). However, on many platforms such
as DRA72-evm, OMAP5-uevm, this may be used to generate input events
similar to twl4030-pwrbutton.c

Series is based on v3.17-rc1

V2 of the series incorporating comments from http://marc.info/?l=linux-input&m=140839287431882&w=2

Nishanth Menon (2):
  doc: dt/bindings: input: introduce palmas power button description
  Input: misc: introduce palmas-pwrbutton

 .../bindings/input/ti,palmas-pwrbutton.txt         |   36 ++
 drivers/input/misc/Kconfig                         |   10 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/palmas-pwrbutton.c              |  356 ++++++++++++++++++++
 4 files changed, 403 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/ti,palmas-pwrbutton.txt
 create mode 100644 drivers/input/misc/palmas-pwrbutton.c

-- 
1.7.9.5

