Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaKQI4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:56:35 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:2799 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaKQI4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:56:34 -0500
Message-ID: <5469B83C.7080004@atmel.com>
Date: Mon, 17 Nov 2014 09:56:28 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Arnd Bergmann <arnd@arndb.de>, <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.18 #2
References: <1415963482-16582-1-git-send-email-nicolas.ferre@atmel.com> <20141116231244.GD14929@quad.lixom.net>
In-Reply-To: <20141116231244.GD14929@quad.lixom.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/11/2014 00:12, Olof Johansson :
> On Fri, Nov 14, 2014 at 12:11:22PM +0100, Nicolas Ferre wrote:
>> Arnd, Olof, Kevin,
>>
>> I don't have more for the moment, so here is trivial at91 material for 3.18.
>>
>> Thanks, best regards,
>>
>> The following changes since commit 106c67af2fb938880edbf43b49dabbd8d2534839:
>>
>>   ARM: at91/dt: sam9263: fix PLLB frequencies (2014-10-22 10:08:22 +0200)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-fixes2
>>
>> for you to fetch changes up to c4e4bbcee9fa37024a2d4cdcaa5fe89a2c5c7a05:
>>
>>   ARM: at91/dt: Fix sama5d3x typos (2014-11-13 12:37:44 +0100)
>>
>> ----------------------------------------------------------------
>> Tiny typo fixes for this second batch for 3.18
>>
>> ----------------------------------------------------------------
>> Ludovic Desroches (1):
>>       ARM: at91/dt: sama5d4: use macro instead of numeric value
> 
> I don't consider this to be a fix at this time in the release, please
> include in your 3.19 material.

Ok, taken in at91-3.19-dt branch that I will sent to you soon.

>> Peter Rosin (1):
>>       ARM: at91/dt: Fix sama5d3x typos
>>
> 
> I did cherry-pick this one in though.
> 
> Not sure if I'll make today's -rc with my fixes pull request. :)

It did it. Thanks.

Bye,
-- 
Nicolas Ferre
