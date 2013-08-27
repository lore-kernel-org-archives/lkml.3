Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3H0N5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:57:32 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:36368 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3H0N5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:57:30 -0400
Message-ID: <521CB046.9070408@baylibre.com>
Date: Tue, 27 Aug 2013 15:57:26 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Javier Martinez Canillas <javier@dowhile0.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-next@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
References: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au> <521C6961.9020103@linutronix.de> <CABxcv=mg6t5wPqpF3j5sr_76qfZ7N7KgpWhcKSGoPTOcaR=V6A@mail.gmail.com> <521CA888.1080909@baylibre.com> <521CAF59.1090203@linutronix.de>
In-Reply-To: <521CAF59.1090203@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Kevin,

On 27/08/2013 15:53, Sebastian Andrzej Siewior wrote:
> On 08/27/2013 03:24 PM, Benoit Cousson wrote:
>> Hi Sebatian,
>
> Hi Benoit,
>
>> Yes. DT patches are an endless source of merge conflicts if they are
>> merge throught different trees.
>
> Usually there are small conflicts because two people added / changed a
> node nearby. This patch turned the .dts file almost upside down.

Yes, that's true.

>> What was discussed with Olof and Arnd during Connect is that we should
>> avoid merging DT patches outside arm-soc tree to avoid that kind of
>> situation.
>
> I am aware of this now. However these changes belonged together because
> a) they belonged together and b) would break the driver until the .dts
> changes and driver code is in-sync.
> In future I am going to ask you for a topic branch so I can get my
> changes in one piece without breaking stuff in the middle.
>
> What do we do now?

Cannot you just merge the stable arm-soc/dt branch into your branch 
before applying your patches?

Regards
Benoit

