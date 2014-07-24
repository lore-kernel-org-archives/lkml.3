Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbaGXLAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:00:34 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:64436 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaGXLAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:00:31 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: peter.griffin@linaro.org, lee.jones@linaro.org
Subject: [PATCH v2 0/3] Add USB HCD support for STi SoCs
Date: Thu, 24 Jul 2014 12:00:13 +0100
Message-Id: <1406199616-10533-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for the USB HCD controller present in STi
SoC's from STMicroelectronics. It has been tested on the stih416-b2020
board.

The original author is no longer with the company and therefore emails
to his address bounce, thus I have not added him to CC.

Changes since v1:
 - Correct s/OCHI/OHCI/ spelling
 - Improve kconfig help message
 - Various formating / spelling nits identified by Lee Jones
 - Make driver depend on OF & remove node checks in code
 - Use devm_ioremap_resource
 - Remove unnecessary header files

Peter Griffin (3):
  usb: host: st-hcd: Add USB HCD support for STi SoCs
  usb: host: st-hcd: Add st-hcd devicetree bindings documentation.
  MAINTAINERS: Add st-hcd to ARCH/STI architecture

 Documentation/devicetree/bindings/usb/st-hcd.txt |  51 +++
 MAINTAINERS                                      |   1 +
 drivers/usb/host/Kconfig                         |  13 +
 drivers/usb/host/Makefile                        |   1 +
 drivers/usb/host/st-hcd.c                        | 471 +++++++++++++++++++++++
 5 files changed, 537 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/st-hcd.txt
 create mode 100644 drivers/usb/host/st-hcd.c

-- 
1.9.1

