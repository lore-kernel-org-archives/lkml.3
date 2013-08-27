Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3H0QUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:20:34 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37320 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3H0QUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:20:32 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Benoit Cousson <bcousson@baylibre.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-next@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
References: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au>
	<521C6961.9020103@linutronix.de>
	<CABxcv=mg6t5wPqpF3j5sr_76qfZ7N7KgpWhcKSGoPTOcaR=V6A@mail.gmail.com>
	<521CA888.1080909@baylibre.com> <521CAF59.1090203@linutronix.de>
	<521CB046.9070408@baylibre.com> <878uznxjnl.fsf@linaro.org>
	<521CC4E3.8030204@linutronix.de>
Date: Tue, 27 Aug 2013 09:20:26 -0700
Message-ID: <87mwo3umut.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

> On 08/27/2013 05:01 PM, Kevin Hilman wrote:
>>>> What do we do now?
>>>
>>> Cannot you just merge the stable arm-soc/dt branch into your branch
>>> before applying your patches?
>> 
>> Unfortunately, the next/dt branch of arm-soc is not necessarily stable
>> so should *not* be merged.  In fact none of the arm-soc branches should
>> be considered stable.
>> 
>> As was already mentioned, this should be split up into driver changes
>> and DTS changes through arm-soc.  They'll both merge for v3.12.
>
> But splitting will break the driver until .dts & code is in sync again.

I wouldn't lose any sleep about breaking the driver since this was not
merged properly for various reasons (as Olof has pointed out.)

Unfortunately, since it's already in Greg's stable tree, we're now left
to clean up the mess in arm-soc land [grmbl]

Kevin




