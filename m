Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbbAHWnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:43:52 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56598 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbbAHWnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:43:33 -0500
From: Moritz Fischer <moritz.fischer@ettus.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moritz Fischer <moritz.fischer@ettus.com>
Subject: [PATCH v2 0/3] NI Ettus Research USRP E3x0 Button driver
Date: Thu,  8 Jan 2015 23:43:08 +0100
Message-Id: <1420756991-16506-1-git-send-email-moritz.fischer@ettus.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds NI Ettus Research USRP E3x0 power button support and
corresponding devicetree bindings and MAINTAINER entries.

It was developed and tested on our NI Ettus Research USRP E310 embedded
SDR on top of 3.19-rc3.

Moritz Fischer (3):
  input: misc: Support NI Ettus Research USRP E3x0 Button
  doc: dt: Add documentation for e3x0-button bindings.
  Update MAINTAINERS file with e3x0-button info.

 .../devicetree/bindings/input/e3x0-button.txt      |  25 ++++
 MAINTAINERS                                        |   8 ++
 drivers/input/misc/Kconfig                         |  10 ++
 drivers/input/misc/Makefile                        |   1 +
 drivers/input/misc/e3x0-button.c                   | 132 +++++++++++++++++++++
 5 files changed, 176 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/e3x0-button.txt
 create mode 100644 drivers/input/misc/e3x0-button.c

-- 
1.9.3

