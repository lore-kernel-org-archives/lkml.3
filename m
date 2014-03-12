Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaCLTDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:03:14 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33889 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaCLTDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:03:11 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 0/9] tty: xuartps: Rebranding + DT documentation
Date: Wed, 12 Mar 2014 12:02:54 -0700
Message-Id: <1394650983-24780-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a fixed and extended v3. I picked up Michal's patches and
incorporated them into the series. Those are the first two patches.
The 'rebranding' patch is correspondingly extended to convert the new
code as well.

The erroneously changed compatibility string has been reverted back to
what it should be.

	Sören

Michal Simek (2):
  tty: xuartps: Fix kernel-doc errors in the driver
  tty: xuartps: Initialize ports according to aliases

Soren Brinkmann (7):
  tty: xuartps: Clean up
  tty: xuartps: Print warning in clock notifier
  tty: xuartps: Refactor read-modify-writes
  tty: xuartps: Don't write IRQ disable register to enable interrupts
  tty: xuartps: Rebrand driver as Cadence UART
  tty: cadence: Document DT binding
  ARM: zynq: DT: Migrate UART to Cadence binding

 .../devicetree/bindings/serial/cdns,uart.txt       |   20 +
 arch/arm/boot/dts/zynq-7000.dtsi                   |    8 +-
 drivers/tty/serial/Kconfig                         |    9 +-
 drivers/tty/serial/xilinx_uartps.c                 | 1129 ++++++++++----------
 include/uapi/linux/serial_core.h                   |    2 +-
 5 files changed, 570 insertions(+), 598 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/cdns,uart.txt

-- 
1.9.0.1.g4196000

