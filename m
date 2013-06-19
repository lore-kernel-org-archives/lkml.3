Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319Ab3FSJY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:24:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52893 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab3FSJYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:24:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: Marek Vasut <marex@denx.de>, Chao Xie <chao.xie@marvell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, drwyrm@gmail.com,
        stefan@openezx.org, laforge@openezx.org,
        Robert Jarzmik <robert.jarzmik@free.fr>, sleep_walker@suse.cz,
        slapin@ossfans.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH V3 5/5] input: pxa27x-keypad: add device tree support
Date: Wed, 19 Jun 2013 11:25:26 +0200
Message-ID: <5961561.7UgodVjTLY@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.4; x86_64; ; )
In-Reply-To: <CADApbeiQWOi8SYEFf0bOsf1yn+TgXhwgDWaWFpGk7+nbC9bNDg@mail.gmail.com>
References: <1371527778-5236-1-git-send-email-chao.xie@marvell.com> <201306191022.51630.marex@denx.de> <CADApbeiQWOi8SYEFf0bOsf1yn+TgXhwgDWaWFpGk7+nbC9bNDg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SdogtIVHP15vM3pVjRHfHGowF3YAbFNDi1wGnVKyavn
 6nXwSTyF9wODGcyntKYJM1+DIWBqc8Yp8a7SaHvAKet7nXVTCV
 Fjf2wQdVnh9uZuxO/uydADhM8Fq73Aleeiwf8/5qc39jh6Hr6K
 3MekYaEO6mrRzsc8hilMlHHUe2nM8GOxNBGxQQXTEOLBxAfRkx
 q24UsLV6z/mdhEQ1zHUn2BD6KGXhimTmHuALUL7ZedRi5nod9N
 6tCX6B8nVQCkzizPZy8g7WJXntjwWlWUS2X4/3HkGFZcr2gM+s
 XQf9FdMa0T6lVe2Mh8LqHq7r5zgWIFeeLUpJ9AF4vSMJK4+y7e
 9Fn7gjirOFfzE0bHZWTE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013 16:38:38 Chao Xie wrote:
> >> index 0000000..f8674f7
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/input/pxa27x-keypad.txt
> >> @@ -0,0 +1,60 @@
> >> +* Marvell PXA Keypad controller
> >> +
> >> +Required Properties
> >> +- compatible : should be "marvell,pxa27x-keypad"
> >> +- reg : Address and length of the register set for the device
> >> +- interrupts : The interrupt for the keypad controller
> >> +- marvell,debounce-interval : How long time the key will be
> >
> > Is there no generic prop name for this debounce interval?
> >
> I searched at drivers/input and Documents.
> Two drivers use "debounce-interval", gpio-keys.c and stmpe-keypad.c.
> They describe the meanings of "debounce-interval" at its own document file.
> Some other drivers uses "xxx,debounce-delay-ms" or "debounce-delay-ms"
> So it seems that there is no generic prop name for this debounce interval.

I'd suggest using "debounce-interval" as in gpio-keys then, since that
is the most generic driver.

	Arnd
