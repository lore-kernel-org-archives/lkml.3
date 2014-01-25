Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaAYOgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:36:42 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:45206 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaAYOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:36:41 -0500
MIME-Version: 1.0
In-Reply-To: <CABru_zWurg5tiOy-LtyizB0bqK5HoTScw0f3TizX4VHTorttTw@mail.gmail.com>
References: <1390593374-6592-1-git-send-email-adrienverge@gmail.com>
	<1390594484.15637.2.camel@x220>
	<CANsc=4XiKexRwApFDdDi09mrduz6BXQPDTz880ucwJA1SOV27Q@mail.gmail.com>
	<1390597685.15637.6.camel@x220>
	<s5hd2jgpj81.wl%tiwai@suse.de>
	<CABru_zWurg5tiOy-LtyizB0bqK5HoTScw0f3TizX4VHTorttTw@mail.gmail.com>
Date: Sat, 25 Jan 2014 09:36:39 -0500
Message-ID: <CANsc=4WLVub0RSJTwnGabqhBcaSUDV4g1JEbDA7NjBsaA6t9AQ@mail.gmail.com>
Subject: Re: [PATCH] ALSA: hda - Fix silent output on MacBook Air 1,1
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: "Nicolo'" <nicolopiazzalunga@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Paul Bolle <pebolle@tiscali.nl>,
        Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com>, Hui Wang <hui.wang@canonical.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-24 Paul Bolle <pebolle@tiscali.nl>:
> I see. Well, if your analysis is correct I think you're supposed to add
>      Fixes: 1a97b7f22774 ("ALSA: hda/realtek - Remove the last static quirks for ALC882")

Sorry for that. Thank you for correcting.

2014-01-25 Nicolo' <nicolopiazzalunga@gmail.com>:
> I can confirm this happens on my machine too: does anybody have a hint
> on why changing VREF on 0x18 mutes/unmutes speakers and hp, which are
> on 0x14 and 0x15 ?

Very strange indeed. However Nicolo', on my machine (with v3.13),
playing with pin 0x18 only mutes/unmutes speakers, not headphones.
