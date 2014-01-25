Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaAYKRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 05:17:40 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:49572 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaAYKRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 05:17:38 -0500
MIME-Version: 1.0
In-Reply-To: <s5hd2jgpj81.wl%tiwai@suse.de>
References: <1390593374-6592-1-git-send-email-adrienverge@gmail.com>
 <1390594484.15637.2.camel@x220> <CANsc=4XiKexRwApFDdDi09mrduz6BXQPDTz880ucwJA1SOV27Q@mail.gmail.com>
 <1390597685.15637.6.camel@x220> <s5hd2jgpj81.wl%tiwai@suse.de>
From: "Nicolo'" <nicolopiazzalunga@gmail.com>
Date: Sat, 25 Jan 2014 11:17:15 +0100
Message-ID: <CABru_zWurg5tiOy-LtyizB0bqK5HoTScw0f3TizX4VHTorttTw@mail.gmail.com>
Subject: Re: [PATCH] ALSA: hda - Fix silent output on MacBook Air 1,1
To: Takashi Iwai <tiwai@suse.de>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        =?ISO-8859-1?Q?Adrien_Verg=E9?= <adrienverge@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com>, Hui Wang <hui.wang@canonical.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm this happens on my machine too: does anybody have a hint
on why changing VREF on 0x18 mutes/unmutes speakers and hp, which are
on 0x14 and 0x15 ?

On Sat, Jan 25, 2014 at 9:18 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 24 Jan 2014 22:08:05 +0100,
> Paul Bolle wrote:
>>
>> On Fri, 2014-01-24 at 15:46 -0500, Adrien Vergé wrote:
>> > I think very few people use Linux on their MBA 1,1. Moreover, part of
>> > them remained on v2.6.
>>
>> I see. Well, if your analysis is correct I think you're supposed to add
>>      Fixes: 1a97b7f22774 ("ALSA: hda/realtek - Remove the last static quirks for ALC882")
>>
>> to your commit explanation. Not sure, since this tag is not documented,
>> as far as I can see.
>
> I applied with fixes and cc-to-stable tags now.
>
> thanks,
>
> Takashi
