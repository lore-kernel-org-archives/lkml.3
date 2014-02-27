Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaB0LzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:55:18 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33068 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaB0LzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:55:14 -0500
MIME-Version: 1.0
In-Reply-To: <2e8474df8cbb7cc583fe1c4e01649835@biophys.uni-duesseldorf.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
	<2e8474df8cbb7cc583fe1c4e01649835@biophys.uni-duesseldorf.de>
Date: Thu, 27 Feb 2014 12:55:13 +0100
X-Google-Sender-Auth: qYN5BdfRvSkQ_cEs4hv0DKA5DWw
Message-ID: <CAMuHMdWvgO=RBp0ctofFqWWyX2V933_RsRLsh83MDdcXnw_1Zg@mail.gmail.com>
Subject: Re: [PATCH 00/16] sleep_on removal, second try
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Cc: Arnd Bergmann <arnd@arndb.de>, scsi <linux-scsi@vger.kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        linux-atm-general@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
        "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael, Arnd,

On Thu, Feb 27, 2014 at 7:37 AM, Michael Schmitz
<schmitz@biophys.uni-duesseldorf.de> wrote:
>> It's been a while since the first submission of these patches,
>> but a lot of them have made it into linux-next already, so here
>> is the stuff that is not merged yet, hopefully addressing all
>> the comments.
>>
>> Geert and Michael: the I was expecting the ataflop and atari_scsi
>> patches to be merged already, based on earlier discussion.
>> Can you apply them to the linux-m68k tree, or do you prefer
>> them to go through the scsi and block maintainers?
>
> Not sure what we decided to do - I'd prefer to double-check the latest ones
> first, but I'd be OK with these to go via m68k.
>
> Maybe Geert waits for acks from linux-scsi and linux-block? (The rest of my
> patches to Atari SCSI still awaits comment there.)

I was waiting for a final confirmation. I was under the impression some rework
was needed, and seeing Michael's NAK confirms that.

I'd be glad to take them through the m68k tree (for 3.15), once they have
received testing and Michael's ACK. Or the block resp. SCSI maintainers can
take them if they prefer, which apparently already happened for 01/16.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
