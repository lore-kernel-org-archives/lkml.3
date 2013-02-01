Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3BAOVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 09:21:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52590 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab3BAOVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 09:21:38 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>, "Quadros, Roger" <rogerq@ti.com>
CC: "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eballetbo@gmail.com" <eballetbo@gmail.com>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "robertcnelson@gmail.com" <robertcnelson@gmail.com>
Subject: RE: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY
 driver
Thread-Topic: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY
 driver
Thread-Index: AQHN/Ur6hep/al+UlEy0NYuQSkHsCphhyDTA//+xUACAAAdUAIAAXITggAM0eHA=
Date: Fri, 1 Feb 2013 14:21:18 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA9FF9C@DBDE01.ent.ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EA95DF0@DBDE01.ent.ti.com>
 <510916B2.7080509@ti.com> <20130130131504.GU15258@arwen.pp.htv.fi>
 <C8443D0743D26F4388EA172BF4E2A7A93EA95E97@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA95E97@DBDE01.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r11ELhPb027741

Hi Felipe, Roger,

On Wed, Jan 30, 2013 at 18:49:17, Mohammed, Afzal wrote:
> On Wed, Jan 30, 2013 at 18:45:04, Balbi, Felipe wrote:
> > On Wed, Jan 30, 2013 at 02:48:50PM +0200, Roger Quadros wrote:

> > > I would appreciate if someone who knows more about beaglebone can help
> > > with verification.

> > Right, Afzal if you have the bone could you help Roger validating ?

> I am not in a position to validate it, in the middle of another task.

Ok, I tested this, usb first instance of beagle bone works as in mainline.

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
