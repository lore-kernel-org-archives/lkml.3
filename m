Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaJBRoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:44:13 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:52041
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbaJBRoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:44:12 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Rostislav Lisovy <lisovy@gmail.com>
CC: Chen Gang <gang.chen.5i5j@gmail.com>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "luca.ellero@brickedbrain.com" <luca.ellero@brickedbrain.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: RE: [PATCH] drivers/staging/comedi/Kconfig: Let COMEDI_II_PCI20KC
 depend on HAS_IOMEM
Thread-Topic: [PATCH] drivers/staging/comedi/Kconfig: Let COMEDI_II_PCI20KC
 depend on HAS_IOMEM
Thread-Index: AQHP3k4gow5hFBlhm02F4sKBzxlCjZwdB36AgAB9KYD//420gA==
Date: Thu, 2 Oct 2014 17:44:11 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FCE77F@P3PWEX4MB008.ex4.secureserver.net>
References: <542D640E.6010200@gmail.com>
	 <DC148C5AA1CEBA4E87973D432B1C2D8825FCE627@P3PWEX4MB008.ex4.secureserver.net>
 <1412270771.20184.1.camel@lolumad>
In-Reply-To: <1412270771.20184.1.camel@lolumad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s92HiHIE007590

On Thursday, October 02, 2014 10:26 AM, Rostislav Lisovy wrote:
>
> Since "egrep -irn "ioremap" drivers/staging/comedi/drivers | wc -l"
> shows "39" does it mean that this should be added to all the other
> drivers as well?


The others are actually pci_ioremap_bar() and those drivers depend on PCI.
I don't _think_ these drivers require the depends on HAS_IOMEM.

The ii_pci20kc driver is goofy in that it's actually an ISA board that uses
memory mapped I/O.

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
