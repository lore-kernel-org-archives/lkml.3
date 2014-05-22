Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaEVJnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:43:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:47927 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaEVJnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:43:02 -0400
Message-ID: <537DC6A1.3090206@linutronix.de>
Date: Thu, 22 May 2014 11:42:57 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: delicious quinoa <delicious.quinoa@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 6/7 v2] gpio: dwapb: use a second irq chip
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>	<1395505004-22650-7-git-send-email-bigeasy@linutronix.de>	<5331F6D5.7070809@gmail.com>	<53427718.30406@linutronix.de>	<CANk1AXSuBGj3vZ7knKmHTwDZLTkvVFT42Lt9ZTdk-E+sp=xQ+g@mail.gmail.com>	<20140430111308.GA11829@linutronix.de> <CACRpkdY=oVyBCwRkppq11B0tkn2bMw+-h_fDhy538eatVUJ=pQ@mail.gmail.com>
In-Reply-To: <CACRpkdY=oVyBCwRkppq11B0tkn2bMw+-h_fDhy538eatVUJ=pQ@mail.gmail.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 05:01 PM, Linus Walleij wrote:
> OK this patch is ACKed by Alan so I would like to apply it but:
> 
> Content-Type: text/plain; charset=utf-8
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
> 
> This is not good. Quoted-printable makes the raw patch look like
> that:
> 
> - int err, irq;
> + int err, irq, i;
> =20
>   irq =3D irq_of_parse_and_map(node, 0);
> 
> Notice spurious =20 and =3D encoding.
> 
> Please resend in ISO8859-1 and take this opportunity to add

doesn't "git am" handle this on its own?

> Alan's ACK.

I will try to add his ack and tell git resent the patch.

> Yours,
> Linus Walleij

Sebastian
