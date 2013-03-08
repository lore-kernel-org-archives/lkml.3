Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974Ab3CHJhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:37:55 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:46904 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383Ab3CHJhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:37:52 -0500
Message-ID: <5139B169.7050807@atmel.com>
Date: Fri, 8 Mar 2013 10:37:45 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>, Olof Johansson <olof@lixom.net>,
        "Arnd Bergmann" <arnd@arndb.de>
CC: <FlorianSchandinat@gmx.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <jacmet@sunsite.dk>
Subject: Re: [PATCH 0/5] at91: atmel_lcdfb: regression fixes and cpu_is removal
References: <cover.1360340791.git.nicolas.ferre@atmel.com> <20130210004740.GH16278@quad.lixom.net> <CAMgPeKV4=C_msvZixVS-o3-QHaJxZP7T4EwLa9vnmYgVheXHgQ@mail.gmail.com>
In-Reply-To: <CAMgPeKV4=C_msvZixVS-o3-QHaJxZP7T4EwLa9vnmYgVheXHgQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2013 07:45 PM, Johan Hovold :
> On Sun, Feb 10, 2013 at 1:47 AM, Olof Johansson <olof@lixom.net> wrote:
>> On Fri, Feb 08, 2013 at 05:35:13PM +0100, Nicolas Ferre wrote:
>>> These patches fix a regression in 16-bpp support for older SOCs which
>>> use IBGR:555 rather than BGR:565 pixel layout. Use SOC-type to
>>> determine if the controller uses the intensity-bit and restore the
>>> old layout in that case.
>>>
>>> The last patch is a removal of uses of cpu_is_xxxx() macros in
>>> atmel_lcdfb with a platform-device-id table and static
>>> configurations.
>>>
>>>
>>> Patches from Johan Hovold taken from: "[PATCH 0/3] atmel_lcdfb: fix
>>> 16-bpp regression" and "[PATCH v2 0/3] ARM: at91/avr32/atmel_lcdfb:
>>> remove cpu_is macros" patch series to form a clean patch series with
>>> my signature.
>>>
>>> Arnd, Olof, as it seems that old fbdev drivers are not so much
>>> reviewed those days, can we take the decision to queue this material
>>> through arm-soc with other AT91 drivers updates?
>>
>> It would be beneficial to get an ack from Florian. Was he involved in
>> the review of the code that regressed 16-bpp support in the first
>> place? When was the regression introduced?
> 
> In v3.4 by commit 787f9fd2328 ("atmel_lcdfb: support 16bit BGR:565 mode,
> remove unsupported 15bit modes").

Arnd, Olof,

Please tell me if I can do something to ease the adoption of these
patches during 3.9-rc timeframe (I can rebase it on top of 3.9-rc1 to
avoid any conflict: the file board-neocore926.c was removed during the
merge window).
Johan has written the series a long time ago and we still do not have it
in mainline.

If the option to ask Andrew is better in your opinion, please tell me.

Best regards,
-- 
Nicolas Ferre
