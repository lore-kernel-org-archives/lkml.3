Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3IRGcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:32:54 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:49029 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3IRGcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130918103750.21e32e537dec100fe30a4839@canb.auug.org.au>
References: <CA+55aFxg-WropC74v5ir5r9kBJKEd93fgye4oTBhw5T8e8sb+g@mail.gmail.com>
	<20130917155057.2125aa5f69fb9cf9bbe01166@canb.auug.org.au>
	<1379463821.32763.601.camel@haakon3.risingtidesystems.com>
	<20130918103750.21e32e537dec100fe30a4839@canb.auug.org.au>
Date: Wed, 18 Sep 2013 08:32:52 +0200
X-Google-Sender-Auth: zD1ca-O3neWqMaMifAUWJhWM-gs
Message-ID: <CAMuHMdVhS3YNKyiDaV4M9f+hJ7B=ncRszTNCeKp5RERSVAB4FQ@mail.gmail.com>
Subject: Re: linux-next stats (Was: Linux 3.12-rc1)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 2:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > So better than last time, but it would be still nice to figure out where
>> > the last lot came from.  I have the "git log --oneline --no-walk" list if
>> > someone wants them.
>> >
>> > Some breakdown of that list:

>> I'm totally confused by these stats..
>>
>> The target-pending/for-next pull had ~30 commits with the term 'target'
>> in the first word of the commit summary, and yours truly had 40 commits
>> merged.
>>
>> Is there a reason why these would not be showing up in the above..?
>
> These are the lists if things that went into Linus' tree but were *not*
> in linux-next prior to the merge window opening.

Perhaps it should be made a little bit clearer that it's a hall of shame, not a
hall of fame? If you miss "the last lot", and continue reading to the various
"top ten"s, you really think you want to be part of them...

The first time they got published, I was also caught by this :-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
