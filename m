Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaHBHuD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 03:50:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaHBHuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 03:50:01 -0400
Message-ID: <53DC9821.3010108@suse.de>
Date: Sat, 02 Aug 2014 09:49:53 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Tomasz Figa <tomasz.figa@gmail.com>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/4] ARM: dts: Add exynos5250-spring device tree
References: <1406822910-6255-1-git-send-email-afaerber@suse.de>	<1406822910-6255-5-git-send-email-afaerber@suse.de>	<53DA936E.9060004@gmail.com>	<53DA9709.10602@suse.de>	<53DA9BA9.60808@gmail.com> <CAD=FV=XVM4FUMxjindZGXku5DZ1MkTWq=Smmt_Fs7=_i4MBFKw@mail.gmail.com>
In-Reply-To: <CAD=FV=XVM4FUMxjindZGXku5DZ1MkTWq=Smmt_Fs7=_i4MBFKw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.08.2014 07:15, schrieb Doug Anderson:
> On Thu, Jul 31, 2014 at 12:40 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> On 31.07.2014 21:20, Andreas Färber wrote:
>>> Am 31.07.2014 21:05, schrieb Tomasz Figa:
>>>> On 31.07.2014 18:08, Andreas Färber wrote:
>>>>> +&sd1_clk {
>>>>> +   samsung,pin-drv = <0>;
>>>>> +};
>>>>> +
>>>>> +&sd1_cmd {
>>>>> +   samsung,pin-pud = <3>;
>>>>> +   samsung,pin-drv = <0>;
>>>>> +};
>>>>> +
>>>>> +&sd1_cd {
>>>>> +   samsung,pin-drv = <0>;
>>>>> +};
>>>>> +
>>>>> +&sd1_bus4 {
>>>>> +   samsung,pin-drv = <0>;
>>>>> +};
>>>>
>>>> Here generic settings are being overridden, so it might be a good idea
>>>> to explain why, like with i2c pull-up above.
>>>
>>> Snow does not have an explanation either, so please suggest what comment
>>> you'd like to see. Consider me just a user with no specs. :)
>>
>> Doug, Vincent, someone else?
> 
> The comment is just in a different place--it's in the dw_mmc node.
> Probably belongs here, though:
> 
>                 /*
>                  * Wifi is a SiP, so can keep drive strengths low
>                  * to reduce EMI.
>                  */
> 

I did copy such a comment for the MMC node in v5, still present in v6.

Andreas

> I guess the cmd line isn't documented.  There is no external pull on
> the command line and on most boards there is one.  Our hardware guys
> thought we didn't need it and apparently we don't...

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
