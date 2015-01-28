Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbbA2FM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:12:59 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:42989 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbbA2FMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:12:55 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <lars@metafoo.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH_V3 0/3] usb: ohci: jz4740: Add DT support and a fix
Date: Wed, 28 Jan 2015 13:26:02 +0000
Message-ID: <1422451565-29096-1-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a few simple patches for the jz4740.

First adds a simple DT binding.
Seconds adds DT support.
Third is a minor fix in clock enabling.

Patches are based on 3.19-rc6. Quite disjoint and stay within jz4740 
so should apply easily on other trees.

If you would like to have them rebased to a different tree, please tell.

Thank-you

V3 changes
DT corrections. Added ACKS for 2 and 3.

V2 changes
Removed an interrupt parent binding. Forgot a binding
Unprepared clock when disabling

ZubairLK

Paul Burton (3):
  dt: usb: jz4740: Add DT binding document for OHCI
  usb: ohci: jz4740: add DT support
  usb: ohci: jz4740: prepare the clock before enabling it

 .../bindings/usb/ingenic,jz4740-ohci.txt           | 26 ++++++++++++++++++++++
 drivers/usb/host/ohci-jz4740.c                     | 15 ++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/ingenic,jz4740-ohci.txt

-- 
1.9.1

