Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaIXHSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:18:51 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:64113 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaIXHSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:18:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140924043423.GA28993@roeck-us.net>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
	<20140923190222.GA4662@roeck-us.net>
	<5421D8B1.1030504@infradead.org>
	<20140923205707.GA14428@roeck-us.net>
	<5421E7E1.80203@infradead.org>
	<20140923215356.GA15481@roeck-us.net>
	<20140924043423.GA28993@roeck-us.net>
Date: Wed, 24 Sep 2014 09:18:46 +0200
X-Google-Sender-Auth: dKcPL7SqrLi5-aclrae4v-sCoAI
Message-ID: <CAMuHMdW3J17CpH3LAfCdNsVuBqsqcWVCrAFt+7aewB-xzzzuiA@mail.gmail.com>
Subject: Re: mmotm 2014-09-22-16-57 uploaded
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Michal Hocko <mhocko@suse.cz>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 6:34 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Tue, Sep 23, 2014 at 02:53:56PM -0700, Guenter Roeck wrote:
>> > Neither of these patches enables CONFIG_NET.  They just add dependencies.
>> >
>> This means CONFIG_NET is now disabled in at least 31 configurations where
>> it used to be enabled before (per my count), and there may be additional
>> impact due to the additional changes of "select X" to "depends on X".
>>
>> 3.18 is going to be interesting.
>>
> Actually, turns out the changes are already in 3.17.
>
> In case anyone is interested, here is a list of now broken configurations
> (where 'broken' is defined as "CONFIG NET used to be defined, but
> is not defined anymore"). No guarantee for completeness or correctness.

Fortunately (for m68k) I always work with the full defconfig files, and
regenerate the minimal ones from the full ones on every -rc release locally.

That way you see the churn...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
