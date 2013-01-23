Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3AWN7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:59:14 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48786 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab3AWN7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:59:12 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Koen Kooi <koen@dominion.thruhere.net>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "eballetbo@gmail.com" <eballetbo@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "linux-omap@vger.kernel.org List" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v1 0/6] USB: Add support for multiple PHYs of same type
Thread-Topic: [PATCH v1 0/6] USB: Add support for multiple PHYs of same type
Thread-Index: AQHN+IcwvzF5Bpzvl0aL3abwJ4uoyphVIJQAgAABCoCAAAjQgIAADPUAgAG5MuA=
Date: Wed, 23 Jan 2013 13:58:47 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA922F5@DBDE01.ent.ti.com>
References: <1358848694-20145-1-git-send-email-kishon@ti.com>
 <2D906ABA-71F2-4843-9DBE-F82527A1240A@dominion.thruhere.net>
 <50FEB3FD.3050001@ti.com> <50FEBB61.9000707@ti.com>
 <B9531499-0746-44DA-BDBB-999D4CA31E63@dominion.thruhere.net>
In-Reply-To: <B9531499-0746-44DA-BDBB-999D4CA31E63@dominion.thruhere.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0NDxDi1004086

Hi Koen,

On Tue, Jan 22, 2013 at 22:32:56, Koen Kooi wrote:
 
> Actually it uses nop-phy as a phy, which is missing from arch/arm/boot/dts/am33xx.dtsi, so mainline is already broken. But adding the nop-phy to the DT is easy enough to patch in locally.

USB first instance of am335x works in mainline as of now.

Regards
Afzal
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
