Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab3HKLut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 07:50:49 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:37250 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3HKLup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 07:50:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1308102226220.32627@pobox.suse.cz>
References: <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
 <20130617111031.GQ20992@atomide.com> <20130701211753.GC15318@amd.pavel.ucw.cz>
 <20130704171939.GA27374@blackmetal.musicnaut.iki.fi> <20130704202145.GB10752@amd.pavel.ucw.cz>
 <20130704203256.GB27374@blackmetal.musicnaut.iki.fi> <20130713121709.GC16473@amd.pavel.ucw.cz>
 <20130714222819.GB3296@blackmetal.musicnaut.iki.fi> <20130728134409.GB5382@amd.pavel.ucw.cz>
 <20130801234355.GA15611@amd.pavel.ucw.cz> <20130810110955.GA11437@amd.pavel.ucw.cz>
 <CAAfyv34w1e+sAuB==-+Pj2gOO1auVNQgawcNC1Z4QfeqchRh3g@mail.gmail.com> <alpine.LNX.2.00.1308102226220.32627@pobox.suse.cz>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Sun, 11 Aug 2013 13:50:24 +0200
Message-ID: <CAAwP0s3uNQ0Mp_QDdPuu4ThQW+cT3F6x62gkU1ku9fWUAtXLHg@mail.gmail.com>
Subject: Re: [PATCH v2] N900: add device tree
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, Belisko Marek <marek.belisko@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@osdl.org>,
        Tony Lindgren <tony@atomide.com>, b-cousson@ti.com,
        pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 10:29 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 10 Aug 2013, Pavel Machek wrote:
>
>> [I wonder if this is clean-enough cause for "trivial in resubmit
>> mode?]
>
> On Sat, 10 Aug 2013, Belisko Marek wrote:
>
>> Same for gta04 (omap3 based device) [1].
>> It was send upstream 2 times and second time there is no reply from 1.3.2013.
>
> Hi guys,
>
> once I am able to match signoffs in the patches to MAINTAINERS, I can take
> those through trivial.git in "re-transmission mode" (or feeeding those
> thgough akpm si an option as well).
>
> Please just send the patches to me in a new thread properly with all the
> Acks/Signoffs, and mark those appropriately (i.e. maintainer that would
> normally push this upstream desurfaced).
>

Hi folks,

I noticed that you are using Benoit older emails address
(b-cousson@ti.com) which no longer exists instead of his new email
address (benoit.cousson@linaro.org). So, it may be possible that
Benoit have not even been getting your patches.

I'll send a patch to MAINTAINERS updating Benoit's email address so
get_maintainer.pl will stop lying.

Jiri, is ok if I send this patch to you? I guess this falls into the
trivial group.

Thanks a lot and best regards,
Javier
