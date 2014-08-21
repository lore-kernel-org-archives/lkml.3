Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaHUKfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 06:35:51 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49052 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaHUKfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:35:48 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.97.15]
In-Reply-To: <53F58DFD.900@denx.de>
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
	<1408419205-10048-14-git-send-email-tuomas.tynkkynen@iki.fi>
	<CAKohpokQOALPH13Ykz4nTBOby8J1X6_F30LNKz=gsC4wN3=3vg@mail.gmail.com>
	<53F3A900.8010805@nvidia.com>
	<CAKohponcZv9-MFNUQFxC_49-+P6QOhdjxsnYAyL3i4sXdCBYrw@mail.gmail.com>
	<CABxcv=ncm3Y7Ecfymro6TOuP=d10OV5--8n=dYmHyj6zi8hwEw@mail.gmail.com>
	<53F4FED4.7060408@suse.de>
	<53F50554.3050505@wwwdotorg.org>
	<CAOh2x=mO1r76fkvruvBLaL144G8fHgDPMwhKVCxv4HW8FRUE_Q@mail.gmail.com>
	<53F58DFD.900@denx.de>
Date: Thu, 21 Aug 2014 12:35:47 +0200
Message-ID: <CABxcv=kJixq0WW5YEX-LvBfU-e9_0pkPw5JeHFOWz8h-_eSjyg@mail.gmail.com>
Subject: Re: Handling commit change logs
From: Javier Martinez Canillas <javier@dowhile0.org>
To: hs@denx.de
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Vince Hsu <vinceh@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Heiko,

On Thu, Aug 21, 2014 at 8:13 AM, Heiko Schocher <hs@denx.de> wrote:
> Hello Viresh,
>
> Am 21.08.2014 06:26, schrieb Viresh Kumar:
>
>> On Thu, Aug 21, 2014 at 2:00 AM, Stephen Warren<swarren@wwwdotorg.org>
>> wrote:
>>>
>>> On 08/20/2014 02:02 PM, Andreas Färber wrote:
>>>>
>>>> Am 20.08.2014 17:39, schrieb Javier Martinez Canillas:
>>>>>
>>>>> If this not the correct workflow and you have a better way to manage
>>>>> this, I would love to know about it.
>>
>>
>> Oh yes, this was certainly useful. I was missing this (mis)feature :)
>
>
> maybe patman from u-boot is also interesting for you, see:
>
> http://git.denx.de/?p=u-boot.git;a=blob;f=tools/patman/README;h=5fb508b80df10d3b11d95eea95a141ce3d0ef578;hb=67ee22b0681305ba1099c508eecade996abc1c65
>

Very interesting and seems to match my workflow as well so I'll take a
look, thanks for sharing!

> bye,
> Heiko
> --

Best regards,
Javier
