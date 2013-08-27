Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3H0PZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:25:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:37803 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3H0PZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:25:30 -0400
Message-ID: <521CC4E3.8030204@linutronix.de>
Date: Tue, 27 Aug 2013 17:25:23 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Benoit Cousson <bcousson@baylibre.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-next@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
References: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au> <521C6961.9020103@linutronix.de> <CABxcv=mg6t5wPqpF3j5sr_76qfZ7N7KgpWhcKSGoPTOcaR=V6A@mail.gmail.com> <521CA888.1080909@baylibre.com> <521CAF59.1090203@linutronix.de> <521CB046.9070408@baylibre.com> <878uznxjnl.fsf@linaro.org>
In-Reply-To: <878uznxjnl.fsf@linaro.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 05:01 PM, Kevin Hilman wrote:
>>> What do we do now?
>>
>> Cannot you just merge the stable arm-soc/dt branch into your branch
>> before applying your patches?
> 
> Unfortunately, the next/dt branch of arm-soc is not necessarily stable
> so should *not* be merged.  In fact none of the arm-soc branches should
> be considered stable.
> 
> As was already mentioned, this should be split up into driver changes
> and DTS changes through arm-soc.  They'll both merge for v3.12.

But splitting will break the driver until .dts & code is in sync again.

> BTW, how did this patch get merged without a signoff/ack from the OMAP
> DT maintainer in the first place?  Hmm, looks like Benoit was not copied
> nor was linux-omap or linux-arm-kernel copied in the original mails.

Hmm. I had Benoit's okay [0] to do the change "as long as Felipe is
fine with it". I indeed forgot to Cc Benoit on the dts changes.
For the phy-rename Felipe pinged you and we did the topic-branch, here
I forgot.

> 
> Kevin

[0] http://www.spinics.net/lists/linux-usb/msg88423.html

Sebastian
