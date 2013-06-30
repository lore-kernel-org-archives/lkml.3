Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3F3QLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:11:20 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37466 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3F3QLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:11:19 -0400
Message-ID: <51D058A4.7020101@free-electrons.com>
Date: Sun, 30 Jun 2013 18:11:16 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 5/8] ARM: mxs: dt: cfa10037: make hogpins grabbed by
 respective drivers
References: <1372424577-8279-1-git-send-email-alexandre.belloni@free-electrons.com> <1372424577-8279-6-git-send-email-alexandre.belloni@free-electrons.com> <20130629070529.GD2593@lukather>
In-Reply-To: <20130629070529.GD2593@lukather>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi Shawn,

On 29/06/2013 09:05, Maxime Ripard wrote:
>> ---
>>  arch/arm/boot/dts/imx28-cfa10037.dts | 19 ++++++++++++++-----
>>  1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/imx28-cfa10037.dts
b/arch/arm/boot/dts/imx28-cfa10037.dts
>> index c2ef3a3..182b99f 100644
>> --- a/arch/arm/boot/dts/imx28-cfa10037.dts
>> +++ b/arch/arm/boot/dts/imx28-cfa10037.dts
>> @@ -22,13 +22,19 @@
>>      apb@80000000 {
>>          apbh@80000000 {
>>              pinctrl@80018000 {
>> -                pinctrl-names = "default", "default";
>> -                pinctrl-1 = <&hog_pins_cfa10037>;
>
> The pinctrl-name property isn't relevant since the 10036 patch. You
> should probably have ordered them the other way around: first the
> breakout board, then the 10036.

Do you want me to send a reordered serie or will you do it when applying
the patches ? You can just apply patch 4/8 last.

thanks,

- -- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJR0FikAAoJEKbNnwlvZCyz40UQAMwmqHS1p0tY6MJ6fPy6rBK8
SH/a1afzKxudNxT5JzM4k5YR1V9TjJXnq658jcu0p5HiYpvCpgXDbde1QKJwf5Hg
lZMw8hg2ogEvCOvaiOGbXc4qEReVWPV5xKw26ur7S8rwNg1AenDJw0tBZIjHzOUp
yo1ZaGC5mV3MDzOcbZ1sfrMXCB2Alwa0zS5Mc1cKIj9d2uVp0U6feWAZ2+1iVcK8
Js23PEpMaagwAWxVjfMH2LThj/vxnM7lkOisaAsbnTyalW7ztdqUhzL4qqFQ7WrC
D8gKgEo9cFTNJrfuwB09eVZmCW8/OqBC0uTH4StgneOwWsiRAn2UZPqwxW2BChik
LeQI+1W67GzVFyuxwmipQyNOCU8iJOKST4a2wIgCiZ27iWPRX5TFOqSr2E1L/lzX
Fdmjjjr9ezxbyFx/hOOvYxZtfCpeyFo0nHfnSU4JnAncC5pQqzgo2ZvvmoGFJE92
jVvhThOGh+glDk85/7Dt5PhXCPQWdwDxu8V6QlWD4RXfAAixq1vCo2odKjaC6P5W
2aEaBaT0oe1YKCKL7s/62gLNwwUtasZyJChhJikhV06aQt8qYdVyP7MYRZaXC8EZ
LcRSAhj+IZUqykqW6VhBlxjxq5Q/HdzgUcwn0EKdhQ2blHhB5cdfQxFLXZpGPsoi
b0+7VLLSM9VeofjhDB2Z
=/A5s
-----END PGP SIGNATURE-----

