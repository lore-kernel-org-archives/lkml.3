Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab3DCHpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:45:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:46263 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762890Ab3DCHpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:45:51 -0400
Message-ID: <515BDE2C.9030904@atmel.com>
Date: Wed, 3 Apr 2013 09:45:48 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: DT changes for 3.10 #2
References: <1364569179-24773-1-git-send-email-nicolas.ferre@atmel.com> <20130402184947.GA8015@quad.lixom.net>
In-Reply-To: <20130402184947.GA8015@quad.lixom.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 08:49 PM, Olof Johansson :
> On Fri, Mar 29, 2013 at 03:59:39PM +0100, Nicolas Ferre wrote:
>> Arnd, Olof,
>>
>> Here is a pull-request for AT91 that is dedicated to Device Tree
>> modifications. It is stacked on the material that you already have
>> for 3.10 in your arm-soc/at91/dt branch.
>> Following our discussion with Arnd, I added the non-urgent patches that I
>> already proposed too late for 3.9. I also included the moving of macb node
>> and kept the original patch.
>>
>> Thanks, best regards,
>>
>> The following changes since commit 6901d947be5ba1245a0f63271355b95f9056a362:
>>
>>   ARM: at91/at91sam9x5cm: add 1-wire chip on CM board (2013-03-21 16:07:15 +0100)
>>
>> are available in the git repository at:
>>
>>   git://github.com/at91linux/linux-at91.git tags/at91-dt
>>
>> for you to fetch changes up to cc2e191b0ccc5a987fdb29261ab9c264c608924d:
>>
>>   ARM: at91/dt: fix macb node declaration (2013-03-29 10:02:04 +0100)
>>
>> ----------------------------------------------------------------
>> One macb DT node move for 9x5 family: 9g15 doesn't
>> have an Ethernet interface.
>> Little fixes mainly related to at91sam9x5 DT and the
>> RTC addition.
>> Addition of the Acme Systems Aria G25 board.
>>
>> ----------------------------------------------------------------
>> Douglas Gilbert (1):
>>       ARM: at91: add Acme Systems Aria G25 board
> 
> Hi,
> 
> I just replied to the above patch -- please prefix the dts files with the
> platform so it's easier to navigate the directory.

Yes, I have to make sure that everybody agree on our side...

> Otherwise the branch contents looks good, so send a fresh request when you've
> respun.
> 
> Also, the new dts isn't added to the Makefile, please add it.

Ok, I will do. Maybe I can also stack a DT related patch about ADC
support that I was planning to add in another pull-request covering the
same topic.

Thanks, best regards,
-- 
Nicolas Ferre
