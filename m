Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaCJHCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 03:02:31 -0400
Received: from f256.i.mail.ru ([94.100.178.221]:46949 "EHLO f256.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaCJHC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 03:02:29 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: jon@ringle.org
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        =?UTF-8?B?Sm9uIFJpbmdsZQ==?= <jringle@gridpoint.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gUkZDOiBXSVA6IHNjMTZpczd4eCBbdjAuNF0=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Mon, 10 Mar 2014 11:02:25 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1394434945.519725450@f256.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1394432777-13005-1-git-send-email-jon@ringle.org>
References: <1394432777-13005-1-git-send-email-jon@ringle.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2A72bTi014943

ĞŸĞ¾Ğ½ĞµĞ´ĞµĞ»ÑŒĞ½Ğ¸Ğº, 10 Ğ¼Ğ°Ñ€Ñ‚Ğ° 2014, 2:26 -04:00 Ğ¾Ñ‚ jon@ringle.org:
> From: Jon Ringle <jringle@gridpoint.com>
...
> +config SERIAL_SC16IS7XX
> +	tristate "SC16IS7xx RS485 serial support"
> +	  select SERIAL_CORE
> +	  default n
> +	  help
> +	  This selects support for SC16IS7xx for use as a RS485 serial port

Documentation says:
The SC16IS740/750/760 is a slave IÂ²C-bus/SPI interface to a single-channel
high performance UART.
...
The SC16IS740/750/760 also provides additional advanced features such
as auto hardware and software flow control, automatic RS-485 support...

So why do you position this chip as RS485 only? Automatic direction for
RS485 is just a feature as an addition for standart UART.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
