Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3HVLeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:34:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46391 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3HVLeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:34:07 -0400
From: "Smyrnov, Illia" <illia.smyrnov@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "Balbi, Felipe" <balbi@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH v3 0/3] Input: omap-keypad: Convert to threaded IRQ and
 cleanup
Thread-Topic: [PATCH v3 0/3] Input: omap-keypad: Convert to threaded IRQ and
 cleanup
Thread-Index: AQHOiIY5CJyzEo/q6kuk93tnuzXP8JmhQ3jF
Date: Thu, 22 Aug 2013 11:34:04 +0000
Message-ID: <6F887CA5EE8CA64BB614602A7379818F60A26D@DNCE04.ent.ti.com>
References: <1374681293-5320-1-git-send-email-illia.smyrnov@ti.com>
In-Reply-To: <1374681293-5320-1-git-send-email-illia.smyrnov@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.41]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

should I take any additional action regarding these patches?

Best regards,
Illia Smyrnov


________________________________________
From: linux-kernel-owner@vger.kernel.org [linux-kernel-owner@vger.kernel.org] on behalf of Smyrnov, Illia
Sent: Wednesday, July 24, 2013 6:54 PM
To: Dmitry Torokhov
Cc: Balbi, Felipe; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; linux-omap@vger.kernel.org
Subject: [PATCH v3 0/3] Input: omap-keypad: Convert to threaded IRQ and cleanup

Replace unclear hardcoded values with bit field, convert to threaded IRQ and
clear interrupts when open the keypad.

Based on top of v3.11-rc2.

Tested on OMAP4 SDP.

Illia Smyrnov (3):
  Input: omap-keypad: Cleanup - use bitfiled instead of hardcoded
    values
  Input: omap-keypad: Convert to threaded IRQ
  Input: omap-keypad: Clear interrupts on open

 drivers/input/keyboard/omap4-keypad.c |   57 +++++++++++++++++++--------------
 1 files changed, 33 insertions(+), 24 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
