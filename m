Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaDVJoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:44:24 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:55109 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531AbaDVJoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:44:15 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v3 0/3] usb: chipidea: msm: Clean and fix glue layer driver
Date: Tue, 22 Apr 2014 12:43:14 +0300
Message-Id: <1398159797-26917-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

This series intend to fix driver, which was broken for a while.
It is used to create peripheral role device, which in coordination
with phy-usb-msm driver could provide USB2.0 gadget support for
Qualcomm targets.

Changes since version 2.

 - Rename devicetree description file to ci-hdrc-qcom.txt to be in-line
   with Freescale and Zevio naming scheme
 - Use better name for usb-phy phandle.
 - Make of_device_id structure const

[1] https://lkml.org/lkml/2014/2/18/209

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

