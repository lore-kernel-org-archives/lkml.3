Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaHRNmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:42:25 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:10439 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaHRNmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:42:22 -0400
Message-ID: <53F202B2.50407@atmel.com>
Date: Mon, 18 Aug 2014 15:42:10 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: move of AIC drivers for 3.17: fixes #1
References: <1408031156-13573-1-git-send-email-nicolas.ferre@atmel.com> <20140815142225.GF5063@titan.lakedaemon.net> <20140815164150.5085b324@bbrezillon> <20140815150503.GG5063@titan.lakedaemon.net>
In-Reply-To: <20140815150503.GG5063@titan.lakedaemon.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/2014 17:05, Jason Cooper :
> On Fri, Aug 15, 2014 at 04:41:50PM +0200, Boris BREZILLON wrote:
>> On Fri, 15 Aug 2014 10:22:25 -0400 Jason Cooper <jason@lakedaemon.net> wrote:
>>> On Thu, Aug 14, 2014 at 05:45:56PM +0200, Nicolas Ferre wrote:
>>>> Arnd, Olof, Kevin,
>>>>
>>>> Boris moved both of our AIC drivers to their new home: the drivers/irqchip
>>>> directory taking advantage of the genirc framework. For DT-enabled SoCs, we can
>>>> use these drivers (aic and aic5) right now: Jason merged them and they are
>>>> available in early 3.17 merge window.
>>>> So, I build this pull-request for enabling the use of these drivers now as:
>>>> - we are very early in 3.17 development
>>>> - it allowed us to avoid having to depend on Jason's branch before the opening
>>>>   of the merge window
>>>
>>> Then why did I create a topic branch for you to base on?
>>>
>>>   git://git.infradead.org/users/jcooper/linux.git irqchip/atmel-aic
>>
>> Don't blame Nicolas for this, he was in vacation when you created this
>> branch (he came back this week), and I should have told you that he
>> couldn't use it for this release cycle.
> 
> 'Blame' is too strong a word. :)  It was more of a friendly, "wtf?"  I
> guess I could have worded it better...
> 
>>>> - it removes some code from the mach-at91 directory: including the whole
>>>>   aic5 driver
>>>> - we'd have quite a bit of time to solve issues if we found a bug
>>>> - the code is basically moved so it should be error free.
>>>
>>> Well, this is certainly up to Arnd, Olof and Kevin, but it seems a bit
>>> unusual.  You're basically asking to merge changes into the current window
>>> that has had _no_ time in -next...  Sounds like a recipe for trouble to
>>> me.
>>>
>>> In the future, please let me know if you're not going to need a topic
>>> branch.
>>
>> This is all my fault, I'm the one who asked Nicolas to get these patches
>> merged in 3.17, and, as I said, I should have told you that he was in
>> vacation and thus could not use your topic branch for this release
>> cycle.
> 
> Ah, no problem.  If there was nothing exciting going on in the SoC
> directory, I probably could have kept the whole series together in one
> branch with just an Ack.  But that's water under the bridge now.
> 
> We'll see what arm-soc says, but I suspect it's going to be wait for the
> next window...

Jason,

(back in the game, recovering an Internet access in Chicago)

Yes, bad timing for this material indeed but I tried to explain lengthy
what to expect from these patches, what was the at91 irqchip drivers
situation in 3.17 and, I believe, not pushing arm-soc guys at all.

So, for sure I tried something a little bit weird I admit, and well, now
I am happily to re-purpose this for 3.18. There is absolutely no problem
to wait a little bit more on my side.

Anyway, thanks for your help with the review and your topic branch.

Bye,
-- 
Nicolas Ferre
