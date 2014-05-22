Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaEVOIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:08:22 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:51746 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaEVOIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <537DC6A1.3090206@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
	<1395505004-22650-7-git-send-email-bigeasy@linutronix.de>
	<5331F6D5.7070809@gmail.com>
	<53427718.30406@linutronix.de>
	<CANk1AXSuBGj3vZ7knKmHTwDZLTkvVFT42Lt9ZTdk-E+sp=xQ+g@mail.gmail.com>
	<20140430111308.GA11829@linutronix.de>
	<CACRpkdY=oVyBCwRkppq11B0tkn2bMw+-h_fDhy538eatVUJ=pQ@mail.gmail.com>
	<537DC6A1.3090206@linutronix.de>
Date: Thu, 22 May 2014 09:08:20 -0500
Message-ID: <CANk1AXSAKhOYuBeNgVJRXnYV_9cEmAhy+DSR3WXmWwFGGe4y7w@mail.gmail.com>
Subject: Re: [PATCH 6/7 v2] gpio: dwapb: use a second irq chip
From: Alan Tull <delicious.quinoa@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 4:42 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 05/16/2014 05:01 PM, Linus Walleij wrote:
>> OK this patch is ACKed by Alan so I would like to apply it but:
>>
>> Content-Type: text/plain; charset=utf-8
>> Content-Disposition: inline
>> Content-Transfer-Encoding: quoted-printable
>>
>> This is not good. Quoted-printable makes the raw patch look like
>> that:
>>
>> - int err, irq;
>> + int err, irq, i;
>> =20
>>   irq =3D irq_of_parse_and_map(node, 0);
>>
>> Notice spurious =20 and =3D encoding.
>>
>> Please resend in ISO8859-1 and take this opportunity to add
>
> doesn't "git am" handle this on its own?

Neither 'git am' nor 'patch -p1' can apply this patch.  When I was
testing it, I assumed those '=3D' were  a product of my webmail, so I
manually edited the patch to get it to apply.

Alan

>
>> Alan's ACK.
>
> I will try to add his ack and tell git resent the patch.
>
>> Yours,
>> Linus Walleij
>
> Sebastian
