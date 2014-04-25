Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaDYNim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:38:42 -0400
Received: from fallback4.mail.ru ([94.100.176.42]:60774 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaDYNii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:38:38 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?Q2hhcmxlcyBDb2xkd2VsbA==?= <coldwell@gmail.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org,
        =?UTF-8?B?Sm9uIFJpbmdsZQ==?= <jringle@gridpoint.com>, jon@ringle.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NyAxLzJdIHNlcmlhbDogc2MxNmlzN3h4?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.0]
Date: Fri, 25 Apr 2014 17:35:35 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1398432935.28366949@f70.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <alpine.LRH.2.03.1404250914380.30160@frank.harvard.edu>
References: <1398387367-4047-1-git-send-email-jon@ringle.org>
 <alpine.LRH.2.03.1404250914380.30160@frank.harvard.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3PDcvdD007340

Fri, 25 Apr 2014 09:21:26 -0400 (EDT) Ğ¾Ñ‚ Charles Coldwell <coldwell@gmail.com>:
> On Thu, 24 Apr 2014, jon@ringle.org wrote:
> 
> > diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
> > new file mode 100644
> > index 0000000..ed139f5
> > --- /dev/null
> > +++ b/drivers/tty/serial/sc16is7xx.c
> 
> > +
> > +/* SC16IS7XX register definitions */
> > +#define SC16IS7XX_RHR_REG		(0x00) /* RX FIFO */
> > +#define SC16IS7XX_THR_REG		(0x00) /* TX FIFO */
> > +#define SC16IS7XX_IER_REG		(0x01) /* Interrupt enable */
> > +#define SC16IS7XX_IIR_REG		(0x02) /* Interrupt Identification */
> > +#define SC16IS7XX_FCR_REG		(0x02) /* FIFO control */
> > +#define SC16IS7XX_LCR_REG		(0x03) /* Line Control */
> > +#define SC16IS7XX_MCR_REG		(0x04) /* Modem Control */
> > +#define SC16IS7XX_LSR_REG		(0x05) /* Line Status */
> > +#define SC16IS7XX_MSR_REG		(0x06) /* Modem Status */
> > +#define SC16IS7XX_SPR_REG		(0x07) /* Scratch Pad */
> 
> Isn't this a lot of duplication?  We have already in 
> 
> /*
>  * include/linux/serial_reg.h
>  *
> #define UART_RX		0	/* In:  Receive buffer */
> #define UART_TX		0	/* Out: Transmit buffer */
> #define UART_IER	1	/* Out: Interrupt Enable Register */
> #define UART_IIR	2	/* In:  Interrupt ID Register */
> #define UART_FCR	2	/* Out: FIFO Control Register */
> #define UART_LCR	3	/* Out: Line Control Register */
> #define UART_MCR	4	/* Out: Modem Control Register */
> #define UART_LSR	5	/* In:  Line Status Register */
> #define UART_MSR	6	/* In:  Modem Status Register */
> #define UART_SCR	7	/* I/O: Scratch Register */
> 
> and the bit definitions, as well.

And it would be nice to have a small changelog,
because it is unclear what has changed with version 6.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
