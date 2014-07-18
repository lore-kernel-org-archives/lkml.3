Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbaGRX0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:26:04 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:32841 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750AbaGRX0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:26:02 -0400
Message-ID: <53C9ACF4.7050002@gmail.com>
Date: Sat, 19 Jul 2014 01:25:40 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        =?ISO-8859-1?Q?=27Heiko_St=FCbner=27?= <heiko@sntech.de>,
        "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Subject: Re: [PATCH 13/19] ARM: s5pv210: move debug-macro.S into the common
 space
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com> <1404496099-26708-14-git-send-email-t.figa@samsung.com> <53C5BF24.9030302@samsung.com> <046101cfa090$51757260$f4605720$@samsung.com> <53C5CDCB.2050307@gmail.com> <53C9779E.7060400@samsung.com>
In-Reply-To: <53C9779E.7060400@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 18.07.2014 21:38, Kukjin Kim wrote:
> On 07/16/14 09:56, Tomasz Figa wrote:
>> On 16.07.2014 02:53, Kukjin Kim wrote:
>>> Kukjin Kim wrote:
>>>>
>>>> On 07/05/14 02:48, Tomasz Figa wrote:
>>>>> Move debug-macro.S from mach/include to include/debug where
>>>>> all other common debug macros are.
>>>>>
>>>>> Signed-off-by: Tomasz Figa<t.figa@samsung.com>
>>>>> ---
>>>>>    arch/arm/Kconfig.debug                           | 12 +++++--
>>>>>    arch/arm/include/debug/s5pv210.S                 | 34
>>>>> ++++++++++++++++++++
>>>>>    arch/arm/mach-s5pv210/include/mach/debug-macro.S | 41
>>>>> ------------------------
>>>>>    3 files changed, 44 insertions(+), 43 deletions(-)
>>>>>    create mode 100644 arch/arm/include/debug/s5pv210.S
>>>>>    delete mode 100644 arch/arm/mach-s5pv210/include/mach/debug-macro.S
>>>
>>> [...]
>>>
>>>> Tomasz,
>>>>
>>>> I couldn't apply this one from this your series because of conflict
>>>> with
>>>> others. Can you please respin this one?
>>>>
>>> One more note, since I didn't apply this, there is a build breakage for
>>> s5pv210_defconfig now...
>>>
>>> arch/arm/kernel/debug.S:24:33: fatal error: mach/debug-macro.S: No
>>> such file or directory
>>> compilation terminated.
>>> make[2]: *** [arch/arm/kernel/debug.o] Error 1
>>> make[1]: *** [arch/arm/kernel] Error 2
>>> make[1]: *** Waiting for unfinished jobs....
>>
>> Hmm? Are you sure previous patches applied correctly? I have tested this
>> series patch by patch on all affected configs and it built fine back
>> then. Maybe some conflict, I'll see tomorrow.
>>
> Tomasz, I've applied this whole series including this again. Can you
> please check my branch before sending pull-request to arm-soc for 3.17?

Thanks for applying this.

A quick look through the patches didn't reveal any issues.
s5pv210_defconfig builds fine too. I don't have any s5pv210-based board
at home, though, so I can't do anything else than compile testing until
Tuesday.

Best regards,
Tomasz
