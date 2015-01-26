Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbbAZPpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:45:12 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:11534 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbbAZPpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:45:08 -0500
Message-ID: <54C660FE.3000401@atmel.com>
Date: Mon, 26 Jan 2015 16:45:02 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        ARM Maintainers <arm@kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: re-fromat AT91 part to match other entries
References: <20150112224203.GL22090@quad.lixom.net> <20150113230956.GA15087@quad.lixom.net> <20150113234759.GH3843@piout.net> <2263559.r5MiMeqJt6@wuerfel>
In-Reply-To: <2263559.r5MiMeqJt6@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/01/2015 10:05, Arnd Bergmann a écrit :
> On Wednesday 14 January 2015 00:47:59 Alexandre Belloni wrote:
>>
>> On 13/01/2015 at 15:09:56 -0800, Olof Johansson wrote :
>>> On Tue, Jan 13, 2015 at 03:43:00PM +0100, Nicolas Ferre wrote:
>>>> The entries are separated as ARM V4/V5 and ARM V7 as some other per-SoC config
>>>> options may be removed in the near future.
>>>>
>>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>>> ---
>>>> Hi Olof,
>>>>
>>>> This is an attempt to match other ARM SoC families format.
>>>> If you feel that the patch can be good, do not hesitate to take it yourself. I
>>>> don't plan to integrate it in any of my pull-request so it can appear quickly in
>>>> arm-soc and can be used by everyone.
>>>
>>> Hi,
>>>
>>> If you see what Peter did, he split up the rules per-SoC based on how
>>> things were selectable in Kconfig. Since you seem to have the Kconfig
>>> entries already, how about doing the same? That way the same information
>>> w.r.t. SoC family that you have as comments isn't lost either.
>>>
>>
>> You didn't see the patch set yet because it depends on a lot of other
>> series still being discussed but after the switch to multiplatform, the
>> only config option left will be SOC_AT91RM9200, SOC_AT91SAM9 (both
>> under SOC_SAM_V4_V5) and SOC_SAMA5, under SOC_SAM_V7.
>>
>> That's our plan, unless you feel that we should keep one config option
>> per SoC.
> 
> With the patches that I prepared last year, all of AT91SAM9 becomes
> one small file, so there really isn't any need to have separate Kconfig
> options.

Hi Olof,

After what noted Alexandre and Arnd, don't you think my initial attempt
was okay? Aka: ping ;-)

Bye,
-- 
Nicolas Ferre
