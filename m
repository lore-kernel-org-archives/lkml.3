Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3HEH1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:27:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56875 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab3HEH1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:27:08 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Bryan Wu <cooloney@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: leds-lp5523: Broken commit
 db6eaf8388a413a5ee1b4547ce78506b9c6456b0
Thread-Topic: leds-lp5523: Broken commit
 db6eaf8388a413a5ee1b4547ce78506b9c6456b0
Thread-Index: AQHOkaizuAGAF+drGEK22yPqYVleuZmGNR2g
Date: Mon, 5 Aug 2013 07:26:46 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E85CC4@DQHE06.ent.ti.com>
References: <201308041146.03970@pali>
In-Reply-To: <201308041146.03970@pali>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r757RGD0009660

> Hello,
> 
> git commit "leds-lp5523: use generic firmware interface"
> db6eaf8388a413a5ee1b4547ce78506b9c6456b0 introduced in kernel
> 3.10 changed user space API for modifing lp5523 led patterns via /sys.
> 
> Before this commit there were sysfs attributes engineX_mode, engineX_load and
> engineX_leds (for every engine X).
> 
> Now (after commit) there are sysfs attributes: select_engine, loading and
> data (see: 10c06d178df11b0b2b746321a80ea14241997127
> for description). Old sysfs attributes were removed.
> 
> So commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0 totally broke all existing
> userspace applications which use lp5523 leds.
> 
> This also broke application MCE which is used on Nokia N900 phone for
> changing LED patterns in lp5523 led.

First of all, I'm really sorry for this conflict.

> 
> I think that kernel api which is used by userspace applications (like
> attributes in /sys) should not be changed in way that totally broke existing
> applications.
> 
> Can you fix this api problem? (maybe adding old sysfs attributes which would
> call new api function...)

I'll recover old sysfs attributes and implement them by using new functions.
Additionally, I'll do same works in LP5521 driver also.

Best Regards,
Milo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
