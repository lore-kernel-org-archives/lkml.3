Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3FRIjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:39:15 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51039 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3FRIjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:39:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130617231638.GV7998@zurbaran>
References: <1368049529-8168-1-git-send-email-geert@linux-m68k.org>
	<CAPnjgZ3Akf0+LKBt4c5HQX5c8PhL+zuvvHWrDpVj0W++GiOanA@mail.gmail.com>
	<20130515064248.GB24297@core.coreip.homeip.net>
	<20130617231638.GV7998@zurbaran>
Date: Tue, 18 Jun 2013 10:39:10 +0200
X-Google-Sender-Auth: gYJn5NfVSvh0192G094qa7N9N1o
Message-ID: <CAMuHMdVL=9m6zB_Jc+hE=iZr7LBT+vb9ckc2c-yxPJOvM-wrPQ@mail.gmail.com>
Subject: Re: [PATCH] input: cros_ec_keyb_clear_keyboard() depends on CONFIG_PM_SLEEP
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Simon Glass <sjg@chromium.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 1:16 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Tue, May 14, 2013 at 11:42:48PM -0700, Dmitry Torokhov wrote:
>> On Wed, May 08, 2013 at 09:25:56PM -0600, Simon Glass wrote:
>> > On Wed, May 8, 2013 at 3:45 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > > If CONFIG_PM_SLEEP is not set:
>> > >
>> > > drivers/input/keyboard/cros_ec_keyb.c:211: warning: ‘cros_ec_keyb_clear_keyboard’ defined but not used
>> > >
>> > > Move the definition of cros_ec_keyb_clear_keyboard() inside the section
>> > > protected by #ifdef CONFIG_PM_SLEEP to fix this.
>> > >
>> > > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> >
>> > Acked-by: Simon Glass <sjg@chromium.org>
>>
>> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>
>> Could you please forward this to Linus as I do not have this driver in
>> my branch yet.
> I guess you took that one now ? Or are you expecting me to merge it ?

FWIW, I also have it in my exotic-arch-fixes branch, now destined for 3.11.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
