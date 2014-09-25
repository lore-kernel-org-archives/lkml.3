Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaIYHpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:45:32 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:61217 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYHpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:45:31 -0400
MIME-Version: 1.0
In-Reply-To: <1411420912.2513.32.camel@jtkirshe-mobl.jf.intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
	<20140922153355.GB4510@pd.tnic>
	<AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
	<20140922184049.GB4709@pd.tnic>
	<3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
	<20140922192152.GD4709@pd.tnic>
	<1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
	<20140922195737.GE4709@pd.tnic>
	<1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
	<20140922203336.GF4709@pd.tnic>
	<1411420912.2513.32.camel@jtkirshe-mobl.jf.intel.com>
Date: Thu, 25 Sep 2014 09:45:29 +0200
X-Google-Sender-Auth: F3OkWubPe6QloaCSevnRQmxg1o4
Message-ID: <CAMuHMdU7VO01_qRGc0TV2K+nJJCu4sm0zbH773_zBWdaxSR1aQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:21 PM, Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:
>> > Why grep through 100,000 warnings, when we should be fixing the code to
>> > prevent 100,000 warnings.  Not saying that the MACRO is the best
>> > solution, it is just a solution, in hopes that it spurs discussions like
>> > this on how to properly fix the warnings.  Not a discussion on how to
>> > grep through the warnings and do nothing.
>>
>> There's only one thing I don't understand: why is so bad to grep through
>> the warnings? I mean, sure, fixing them *without* jumping through hoops
>> to do so is the optimal thing. But what's wrong with grepping through
>> them?
>
> Nothing is wrong with grepping for an error, especially when you know
> the error your grepping for.  But then again, why grep when it can be
> fixed to begin with?  The fact that there are over 100,000
> warnings/errors to begin with is somewhat disconcerting.  It makes me
> wonder whether it was due to coding laziness.

Instead of grepping, you can feed the build log to linux-log-summary.
Or when changing a driver, feed the before and after build logs to
linux-log-diff. That way you won't miss the single new warning you've
just introduced.

https://github.com/geertu/linux-scripts

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
