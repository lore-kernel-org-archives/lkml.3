Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaBJM6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:58:14 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:10017 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBJM6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:58:13 -0500
Message-ID: <52F8CCD8.3070409@atmel.com>
Date: Mon, 10 Feb 2014 13:58:00 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Boris BREZILLON <b.brezillon@overkiz.com>, <jjhiblot@traphandler.com>,
        "Bo Shen" <voice.shen@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.14 #1
References: <1391790986-31936-1-git-send-email-nicolas.ferre@atmel.com> <20140207172055.GC9558@ns203013.ovh.net>
In-Reply-To: <20140207172055.GC9558@ns203013.ovh.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 18:20, Jean-Christophe PLAGNIOL-VILLARD :
> On 17:36 Fri 07 Feb     , Nicolas Ferre wrote:
>> Arnd, Olof, Kevin,
>>
>> This is a first "fixes" series for AT91 on 3.14.
>> The content is only DT-related and quite boring.
>> I took the opportunity of this early "fixes" pull-request to collect
>> some Documentation patches that were lying around and I guess that
>> they can be merged by arm-soc nicely (addition of CCF to 2 drivers).
>> A new board is added to the lot because it is dead simple and integrates
>> well with the new sama5d36 SoC that we added earlier in this development cycle.
>>
>> Thanks, best regards,
>>
>> The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:
>>
>>   Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)
>>
>> are available in the git repository at:
>>
>>   git://github.com/at91linux/linux-at91.git tags/at91-fixes
>>
>> for you to fetch changes up to b7c2b6157079811586180d13c44a1095b57c2d47:
>>
>>   ARM: at91: add Atmel's SAMA5D3 Xplained board (2014-02-07 17:20:39 +0100)
>>
>> ----------------------------------------------------------------
>> First series of AT91 fixes for 3.14.
>> All of them are DT-related.
>> - fixes for typos in i2c and ohci clocks
>> - addition of a USB host node for at91sam9n12ek
>> - 2 DT documentation updates that have been sent a long time ago
>> - a new board based on the sama5d36 SoC
>>
>> ----------------------------------------------------------------
>> Bo Shen (1):
>>       ARM: at91: enable USB host on at91sam9n12ek board
>>
>> Boris BREZILLON (3):
>>       ARM: at91/dt: fix sama5d3 ohci hclk clock reference
>>       mmc: atmel-mci: document clock properties
>>       spi/atmel: document clock properties
>>
>> Jean-Jacques Hiblot (1):
>>       ARM: at91/dt: sam9263: fix compatibility string for the I2C
>>
>> Nicolas Ferre (1):
>>       ARM: at91: add Atmel's SAMA5D3 Xplained board
> 
> still comment on it please drop it on the PULL

No, please don't.

I wrote this pull-request after having considered Jean-Christophe's
comments and having corrected my initial DTS file.
The comments that Jean-Christophe made in addition to the patch included
in this pull-request are just his point of view that I don't share (and
I've just answered his email BTW).

Jean-Christophe, I tend to ask for code inclusion when I am sure that
the content is ready and don't build a pull-request lightly. So please
do not add fuzziness to the AT91 maintenance process.

That said, I do not plan to put pressure on anybody. I just thought that
this board was simple enough so that it can seamlessly integrate 3.14...

Bye,

>>  .../devicetree/bindings/mmc/atmel-hsmci.txt        |   5 +
>>  .../devicetree/bindings/spi/spi_atmel.txt          |   5 +
>>  arch/arm/boot/dts/Makefile                         |   1 +
>>  arch/arm/boot/dts/at91-sama5d3_xplained.dts        | 229 +++++++++++++++++++++
>>  arch/arm/boot/dts/at91sam9263.dtsi                 |   2 +-
>>  arch/arm/boot/dts/at91sam9n12ek.dts                |   4 +
>>  arch/arm/boot/dts/sama5d3.dtsi                     |   2 +-
>>  7 files changed, 246 insertions(+), 2 deletions(-)
>>  create mode 100644 arch/arm/boot/dts/at91-sama5d3_xplained.dts
>>
>> -- 
>> Nicolas Ferre
> 


-- 
Nicolas Ferre
