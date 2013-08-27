Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3H0OC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:02:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:37244 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3H0OC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:02:58 -0400
Message-ID: <521CB18B.4080000@linutronix.de>
Date: Tue, 27 Aug 2013 16:02:51 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Benoit Cousson <bcousson@baylibre.com>
CC: Javier Martinez Canillas <javier@dowhile0.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-next@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
References: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au> <521C6961.9020103@linutronix.de> <CABxcv=mg6t5wPqpF3j5sr_76qfZ7N7KgpWhcKSGoPTOcaR=V6A@mail.gmail.com> <521CA888.1080909@baylibre.com> <521CAF59.1090203@linutronix.de> <521CB046.9070408@baylibre.com>
In-Reply-To: <521CB046.9070408@baylibre.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 03:57 PM, Benoit Cousson wrote:
> + Kevin,
> 
> On 27/08/2013 15:53, Sebastian Andrzej Siewior wrote:
>> What do we do now?
> 
> Cannot you just merge the stable arm-soc/dt branch into your branch
> before applying your patches?

That is up to Greg. This changes sat in his usb-next tree for a while
now. And before they hit Greg they were in Felipe's tree for a while.

To be exact, last .dts change via USB was:

Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Thu Jun 20 12:13:04 2013 +0200
Commit:     Felipe Balbi <balbi@ti.com>
CommitDate: Fri Aug 9 17:40:16 2013 +0300

	usb: musb dma: add cppi41 dma driver

> Regards
> Benoit

Sebastian
