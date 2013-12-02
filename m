Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3LBNjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:39:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:44567 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3LBNjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:39:05 -0500
Message-ID: <529C8D74.10007@linutronix.de>
Date: Mon, 02 Dec 2013 14:39:00 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: Michael Trimarchi <michael@amarulasolutions.com>,
        Felipe Balbi <balbi@ti.com>, lee.jones@linaro.org,
        sameo@linux.intel.com, tomi.valkeinen@ti.com,
        Stefan Roese <sr@denx.de>, ljkenny.mailinglists@gmail.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems
 on OMAP4 Panda
References: <1385730118-26402-1-git-send-email-rogerq@ti.com>	<1385730118-26402-2-git-send-email-rogerq@ti.com> <CAOf5uwmEkzFd=e3j8m8=qdTCAMkk_-DPw0fTm=7Vzy0PbE2oDQ@mail.gmail.com> <529C55DF.3000808@ti.com> <529C76AF.10106@linutronix.de> <529C7922.5000601@ti.com> <529C854F.3010101@linutronix.de> <529C8CBD.4070003@ti.com>
In-Reply-To: <529C8CBD.4070003@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 02:35 PM, Roger Quadros wrote:
>> It refers to "Errata Id:i660" why it is required. Once you figured what
>> why it has been added you could have an idea if it is okay to remove it
>> and if the reset you do here might lead to it (I dunno).
>>
> 
> Keshava no longer works @TI. I have no other means to check why it was added
> other than doing dome tests and making sure nothing breaks if we remove it.
> 
> So far, things are going fine for about 50 or so boots divided between OMAP3 and 4
> platforms. If more people can test and give feedback it'd be great.

Hmm. Can't you lookup the errata he revers to?

> cheers,
> -roger
> 

Sebastian
