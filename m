Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3FSRxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:53:31 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:37352 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab3FSRx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:53:29 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 0/2] Extend multi_v7_defconfig
Date: Wed, 19 Jun 2013 10:53:02 -0700
Message-Id: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I don't know how much a defconfig is supposed to provide, hence as RFC.
This patches are needed for booting Zynq into a minimum ramfs based
system with a serial console.

	Thanks,
	Sören

Soren Brinkmann (2):
  arm: multi_v7_defconfig: Enable Zynq UART driver
  arm: multi_v7_defconfig: Enable initrd/initramfs support

 arch/arm/configs/multi_v7_defconfig | 3 +++
 1 file changed, 3 insertions(+)

-- 
1.8.3.1

