Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3A3MJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:09:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47373 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab3A3MJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:09:08 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Quadros, Roger" <rogerq@ti.com>, "tony@atomide.com" <tony@atomide.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
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
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY
 driver
Thread-Topic: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY
 driver
Thread-Index: AQHN/Ur6hep/al+UlEy0NYuQSkHsCphhyDTA
Date: Wed, 30 Jan 2013 12:08:47 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA95DF0@DBDE01.ent.ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0UC9ETW014702

Hi Roger,

On Mon, Jan 28, 2013 at 17:00:01, Quadros, Roger wrote:

> NOTE: Tested on 4460ES-B1 Panda and BeagleBoard C4 only. Other boards are only
> build tested.

Please try to ensure that beagle bone USB0 works with this.

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
