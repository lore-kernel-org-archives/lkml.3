Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab3CRRvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:51:38 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:57667 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398Ab3CRRvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:51:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1363628979!12750979!107
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ryan Mallon <rmallon@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>
Date: Mon, 18 Mar 2013 12:51:29 -0500
Subject: RE: [PATCH 1/3] backlight: ep93xx_bl: fix section mismatch
Thread-Topic: [PATCH 1/3] backlight: ep93xx_bl: fix section mismatch
Thread-Index: Ac4h6+UlcXUthXLuQoirE+D+iIzi2QCFLMyg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020980106E11@AUSP01VMBX24.collaborationhost.net>
References: <201303151803.08774.hartleys@visionengravers.com>
 <5143D6C4.9060503@gmail.com>
In-Reply-To: <5143D6C4.9060503@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2IHpeHR018558

On Friday, March 15, 2013 7:20 PM, Ryan Mallon wrote:
> On 16/03/13 12:03, H Hartley Sweeten wrote:
>
>> Remove the __init tag from ep93xxbl_probe() to fix the section
>> mismatch warning.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ryan Mallon <rmallon@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>
>
> There is a patch for this already queued in Andrew Morton's tree.

Ah, missed that one. Please drop patch 1/3.

The other two, as well as the compile bug fix for ep93xx_fb.c should still
be ok. The bug fix patch is probably valid for stable as appropriate.

[PATCH] video: ep93xx_fb: include <linux/io.h> for devm_ioremap()
[PATCH 2/3] video: ep93xx-fb.c: fix section mismatch and use module_platform_driver
[PATCH 3/3] misc: ep93xx_pwm.c: fix section mismatch and use module_platform_driver

Thanks,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
