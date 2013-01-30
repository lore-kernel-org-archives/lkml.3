Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3A3NNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:13:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44063 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab3A3NNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:13:02 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Quadros, Roger" <rogerq@ti.com>
CC: "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Balbi, Felipe" <balbi@ti.com>,
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
Thread-Index: AQHN/Ur6hep/al+UlEy0NYuQSkHsCphhyDTA//+xUACAAGIIgA==
Date: Wed, 30 Jan 2013 13:12:44 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA95E60@DBDE01.ent.ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EA95DF0@DBDE01.ent.ti.com>
 <510916B2.7080509@ti.com>
In-Reply-To: <510916B2.7080509@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0UDD7OK015033

Hi Roger,

On Wed, Jan 30, 2013 at 18:18:50, Quadros, Roger wrote:
> On 01/30/2013 02:08 PM, Mohammed, Afzal wrote:

> > Please try to ensure that beagle bone USB0 works with this.

> I do not have beaglebone with me and don't seem to find beaglebone
> board support in mainline.

Ok. Fyi, beagle bone is supported in mainline - it is dt boot.

Regards
Afzal

> I would appreciate if someone who knows more about beaglebone can help
> with verification.
> 
> I could find that Robert C Nelson (now in cc) is maintaining out of tree
> patches for the beaglebone. Maybe he could help with verification?

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
