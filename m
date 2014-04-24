Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbaDXQbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:31:31 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:43708 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaDXQb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:31:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140424162536.GD22987@atomide.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
	<1397767775-10965-1-git-send-email-nm@ti.com>
	<53504041.7090906@ti.com>
	<5350410B.5010507@ti.com>
	<5358D16A.9000500@ti.com>
	<20140424162536.GD22987@atomide.com>
Date: Thu, 24 Apr 2014 11:31:27 -0500
X-Google-Sender-Auth: jWtJsMg1-CUfezT-sRcHYadIG48
Message-ID: <CAGo_u6p8wivmN-S8V2dyk7ZcoDbkkTiEJGJON4+9NYXqYFA2YQ@mail.gmail.com>
Subject: Re: [PATCH V2 00/19] bus: omap_l3_noc: driver cleanups and support
 for DRA7/AM4372
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        dt list <devicetree@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, lkml <linux-kernel@vger.kernel.org>,
        Sricharan R <r.sricharan@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:25 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Peter Ujfalusi <peter.ujfalusi@ti.com> [140424 01:55]:
>> On 04/18/2014 12:00 AM, Nishanth Menon wrote:
>> > On 04/17/2014 03:57 PM, Santosh Shilimkar wrote:
>> >> I looked at the series and its looks pretty good. Thanks for fixups, updates.
>> >> For whole series,
>> >> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> >>
>> >
>> > Thanks.
>> >
>> >>> Patches(including Peter's) is available here:
>> >>> https://github.com/nmenon/linux-2.6-playground/commits/l3noc/driver-fixes-v2
>> >>>
>> >> Can Tony pull this branch for 3.16 then which includes Peter's series as well ?
>> >
>> > there is just an empty commit with information about peter's patches
>> > that i lined up to differentiate the series.. I can drop it if Tony
>> > would like me to.
>>
>> Looking at the branch I see my patches underneath so they are in the branch.
>> It would be great if Tony pulls this... Will be a great present to my patches
>> (omap_l3 patches in the branch) for their 1 year anniversary of being out on
>> the mailing list ;)
>
> If you insist :) Maybe we should have some cake or something with it?
> Seriously, I always thought that's a nice clean-up set, but never thought
> I'm supposed to merge it. Will merge it as soon as I'm out of the fixes
> and regressions land as that way I can easier test for any kind of
> new regressions that might occur related to PM at least.

Thanks Tony. I will try and post a v3 tomorrow as a clean set of
patches and a v3.15-rc1 based branch to ease integration.

This should also give additional time for any further comments as well.

Regards,
Nishanth Menon
