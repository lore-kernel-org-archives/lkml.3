Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab3FSASE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:18:04 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:43533
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933187Ab3FSASD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:18:03 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jun 2013 20:18:02 EDT
Message-Id: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se>
From: Anders Hammarquist <iko@iko.pp.se>
Date: Wed, 19 Jun 2013 02:05:07 +0200
Subject: [PATCH 0/2] *** SUBJECT HERE ***
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Wed, 19 Jun 2013 02:12:25 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB cable to read out data from the Abbott FreeStyle Precision
meters, known as the Abbott stip port cable, uses the TI 3410 chip,
just as the already added stereo port cable. They are essestially
the same cable, just with different connectors at the end.

This patch set adds the product id to the driver, and makes the
product type more explicit. Arguably, the ABBOTT_PRODUCT_ID
define could be removed, but I left it on the off chance that
someone other that the TI 3410 driver uses it.

/Anders

Anders Hammarquist (2):
  Add product id for Abbott strip port cable for Precision meter    
    which uses the TI 3410 chip.
  Be explicit about the Abbott product ids being product ids.

 drivers/usb/serial/ti_usb_3410_5052.c |    3 ++-
 drivers/usb/serial/ti_usb_3410_5052.h |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
1.7.10.4

