Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaHUHQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:16:13 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:63037 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaHUHQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:16:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140820144952.GB18099@core.coreip.homeip.net>
References: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
	<20140820051815.GA1109@core.coreip.homeip.net>
	<s5hwqa3hetu.wl-tiwai@suse.de>
	<20140820063130.GA11226@core.coreip.homeip.net>
	<s5htx57hc89.wl-tiwai@suse.de>
	<s5hfvgrwe59.wl-tiwai@suse.de>
	<20140820144952.GB18099@core.coreip.homeip.net>
Date: Thu, 21 Aug 2014 09:16:10 +0200
X-Google-Sender-Auth: oked3OWVyueExmfLTdnIlgST6Xs
Message-ID: <CAMuHMdXctPvoJGOOVPA+a=ZGqYHsttTw3eGNU1sNGRcidshF3A@mail.gmail.com>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Andreas Mohr <andi@lisas.de>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, Aug 20, 2014 at 4:49 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Aug 20, 2014 at 02:15:30PM +0200, Takashi Iwai wrote:
>> At Wed, 20 Aug 2014 09:05:58 +0200,
>> Takashi Iwai wrote:
>> > Well, it worked on my test machine a year ago or so.  Maybe I had a
>> > good luck.
>>
>> FYI, now I tested again an analog joystick on SB Live put on a Dell
>> IvyBridge desktop with 3.17-rc1 x86-64 kernel, and it worked fine as
>> is.
>>
>> So it's not that broken.
>
> That's probably because in your system TSCs are stable when switching CPU
> frequency. Earlier systems had bunch of issues there IIRC.

>From the success stories above, it seems gameport doesn't work on only
a limited number of systems.

Perhaps the subsystem can fail with a big fat warning at runtime if such
a system is detected?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
