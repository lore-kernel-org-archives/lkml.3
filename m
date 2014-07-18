Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbaGRJea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:34:30 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56573 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761175AbaGRJby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:31:54 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/9] usb: musb: several bugfixes for the musb driver
Date: Fri, 18 Jul 2014 11:31:21 +0200
Message-Id: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first three patches do some source code cleanup in the files that
are modified in the subsequent patches.

Patch 4 carries the proper fix reported in commit:
        7adb5c876e9c ("usb: musb: Fix panic upon musb_am335x module removal")

Patch 6 makes the USBOTG_ID pin override via the USB_MODE register
        really work.

Patch 5 makes the error message upon driver probe failure visible
        without having to recompile the driver with DEBUG enabled.

Patch 7 makes sure the parameters for the usb_gen_phy are properly set
        up before registering it.

Patch 8 makes it possible to use the driver with HW that requires
        external regulators or clocks.

Patch 9 reinstates module unloading support for the musb_am335x driver
        which was disabled due to a false failure analysis

