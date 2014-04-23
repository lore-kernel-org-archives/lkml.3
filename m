Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaDWM3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:29:08 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56630 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbaDWM3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:29:02 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v4 0/3] usb: chipidea: msm: Clean and fix glue layer driver
Date: Wed, 23 Apr 2014 15:28:01 +0300
Message-Id: <1398256084-6815-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

This series intend to fix driver, which was broken for a while.
It is used to create peripheral role device, which in coordination
with phy-usb-msm driver could provide USB2.0 gadget support for
Qualcomm targets.

Changes since version 3.

 - Fix typo in devicetree description file.

Previews version can be found here:

https://lkml.org/lkml/2014/4/22/195

Ivan T. Ivanov (3):
  usb: chipidea: msm: Add device tree binding information
  usb: chipidea: msm: Add device tree support
  usb: chipidea: msm: Initialize offset of the capability registers

 .../devicetree/bindings/usb/ci-hdrc-qcom.txt       | 17 +++++++++++++++
 drivers/usb/chipidea/ci_hdrc_msm.c                 | 24 +++++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-qcom.txt

--
1.8.3.2

