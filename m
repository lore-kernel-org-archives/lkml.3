Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3FCIpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:45:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:55244 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3FCIpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:45:22 -0400
Message-ID: <51AC579B.8040902@atmel.com>
Date: Mon, 3 Jun 2013 10:45:15 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: linux-next: Tree for May 30
References: <20130530163334.105322d3c166b74165f1dad4@canb.auug.org.au> <CAMuHMdXNzmJtfxzzt3kuzROzJmfsTKkp_4_8pdg=ahLv2LdU+Q@mail.gmail.com> <20130603163633.e392dffdacc316b490b12a26@canb.auug.org.au>
In-Reply-To: <20130603163633.e392dffdacc316b490b12a26@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 08:36, Stephen Rothwell :
> Hi Geert,
>
> On Thu, 30 May 2013 10:07:48 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>
>> The following defconfigs fail without anything useful in the log:
>>    - at91sam9g20_defconfig
>>    - at91sam9261_defconfig
>>    - at91sam9260_defconfig
>>
>> A manual run reveals why:
>> Can't find default configuration "arch/arm/configs/at91sam9g20_defconfig"!
>>
>> This is due to the merge of several config files:
>>
>> commit b3f442b0eedbc20b5ce3f4a96530588d14901199
>> Author: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>> Date:   Wed May 15 17:19:21 2013 +0200
>>
>>      ARM: at91: udpate defconfigs
>>
>>      Merge 9g20 with 9260 and 9g10 with 9261 as those SoCs can run from the same
>>      kernel even in non DT world.
>>
>>      Fix the sam9261ek to allow 9g10 and sam9261 to compile together.
>>
>>      Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>      Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>
> Thanks for letting me know.  I have stopped those three configs from
> being built.

Stephen, Geert,

Thanks for having taking care about this.

Is it possible for you to move the building to the replacement defconfigs:
at91sam9260_9g20_defconfig
at91sam9261_9g10_defconfig

Best regards,
-- 
Nicolas Ferre
