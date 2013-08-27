Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab3H0PBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:01:24 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55930 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3H0PBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:01:21 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Benoit Cousson <bcousson@baylibre.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
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
	<521CB046.9070408@baylibre.com>
Date: Tue, 27 Aug 2013 08:01:18 -0700
In-Reply-To: <521CB046.9070408@baylibre.com> (Benoit Cousson's message of
	"Tue, 27 Aug 2013 15:57:26 +0200")
Message-ID: <878uznxjnl.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit Cousson <bcousson@baylibre.com> writes:

> + Kevin,
>
> On 27/08/2013 15:53, Sebastian Andrzej Siewior wrote:
>> On 08/27/2013 03:24 PM, Benoit Cousson wrote:
>>> Hi Sebatian,
>>
>> Hi Benoit,
>>
>>> Yes. DT patches are an endless source of merge conflicts if they are
>>> merge throught different trees.
>>
>> Usually there are small conflicts because two people added / changed a
>> node nearby. This patch turned the .dts file almost upside down.
>
> Yes, that's true.
>
>>> What was discussed with Olof and Arnd during Connect is that we should
>>> avoid merging DT patches outside arm-soc tree to avoid that kind of
>>> situation.
>>
>> I am aware of this now. However these changes belonged together because
>> a) they belonged together and b) would break the driver until the .dts
>> changes and driver code is in-sync.
>> In future I am going to ask you for a topic branch so I can get my
>> changes in one piece without breaking stuff in the middle.
>>
>> What do we do now?
>
> Cannot you just merge the stable arm-soc/dt branch into your branch
> before applying your patches?

Unfortunately, the next/dt branch of arm-soc is not necessarily stable
so should *not* be merged.  In fact none of the arm-soc branches should
be considered stable.

As was already mentioned, this should be split up into driver changes
and DTS changes through arm-soc.  They'll both merge for v3.12.

BTW, how did this patch get merged without a signoff/ack from the OMAP
DT maintainer in the first place?  Hmm, looks like Benoit was not copied
nor was linux-omap or linux-arm-kernel copied in the original mails.

Kevin
