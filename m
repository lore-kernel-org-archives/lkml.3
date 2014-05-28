Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaE1J1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:27:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:33298 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaE1J07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:26:59 -0400
Message-ID: <5385ABDD.6000205@linutronix.de>
Date: Wed, 28 May 2014 11:26:53 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Jamie Iles <jamie@jamieiles.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH v3] gpio: dwapb: use a second irq chip
References: <CACRpkdY=oVyBCwRkppq11B0tkn2bMw+-h_fDhy538eatVUJ=pQ@mail.gmail.com>	<1401137894-6096-1-git-send-email-bigeasy@linutronix.de>	<CACRpkdYx9Zwoig5QZmpF1w_Gcyoga8erPZd0RwvHsiC3prjNTA@mail.gmail.com>	<5384BD93.6030502@linutronix.de> <CACRpkdaO+_d_WTE_Or0R1KXqoHyyviFP9eVSHKZ_pB8E8wKoOQ@mail.gmail.com>
In-Reply-To: <CACRpkdaO+_d_WTE_Or0R1KXqoHyyviFP9eVSHKZ_pB8E8wKoOQ@mail.gmail.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 11:01 AM, Linus Walleij wrote:
> On Tue, May 27, 2014 at 6:30 PM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> 
>> What remains in my queue is:
>>
>> * gpio: dwapb: use irq_linear_revmap() for the faster lookup
>> * gpio: dwapb: use irq_gc_lock() for locking instead bc's lock
>> * gpio: dwapb: use d->mask instead of BIT(bit)
>>
>> what do we do about those?
> 
> Rebase on my devel branch and resend please ... but for linear
> revmap I'd much prefer some effort being put into using the
> gpiolib irqchip helpers with generic chips instead.

Hmmm. I would have to look what this is about. The irq_linear_revmap()
lookup is a linear lookup.

> 
> Yours,
> Linus Walleij
> 

Sebastian
