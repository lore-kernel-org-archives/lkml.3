Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaDTIdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:33:44 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:52372 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaDTIde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:33:34 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2014 04:33:34 EDT
X-Spam-Flag: NO
X-Spam-Score: -0.045
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de 80377526272
X-DKIM: OpenDKIM Filter v2.0.2 smtp-02.vodafone.de 53F39E8B74
Message-ID: <535384FC.1060708@vodafone.de>
Date: Sun, 20 Apr 2014 10:27:40 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Alex Deucher <alexdeucher@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        =?ISO-8859-1?Q?Chris?= =?ISO-8859-1?Q?tian_K=F6nig?= 
	<christian.koenig@amd.com>
Subject: Re: [git pull] drm fixes
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie> <20140419190305.GA267@x4> <CADnq5_M9COdOJhOu4_9yRpDoFt3bcc9HVqrvQqnYM3YuTLv15A@mail.gmail.com> <20140420062450.GA281@x4>
In-Reply-To: <20140420062450.GA281@x4>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I did and it doesn't fix the issue.
In this case please open up a new bugreport on 
https://bugs.freedesktop.org/enter_bug.cgi?product=DRI and select 
DRM/Radeon as component.

Additional to that please provide a dmesg output generated with 
drm.debug=0xE for both the good and the bad case.

Thanks in advance,
Christian.

Am 20.04.2014 08:24, schrieb Markus Trippelsdorf:
> On 2014.04.19 at 21:21 -0400, Alex Deucher wrote:
>> On Sat, Apr 19, 2014 at 3:03 PM, Markus Trippelsdorf
>> <markus@trippelsdorf.de> wrote:
>>> On 2014.04.19 at 08:19 +0100, Dave Airlie wrote:
>>>> Unfortunately this contains no easter eggs, its a bit larger than I'd
>>>> like, but I included a patch that just moves code from one file to another
>>>> and I'd like to avoid merge conflicts with that later, so it makes it seem
>>>> worse than it is,
>>>> Christian König (2):
>>>>        drm/radeon: apply more strict limits for PLL params v2
>>>>        drm/radeon: improve PLL params if we don't match exactly v2
>>> commit f8a2645ecede4eaf90b3d785f2805c8ecb76d43e
>>> Author: Christian König <christian.koenig@amd.com>
>>> Date:   Wed Apr 16 11:54:21 2014 +0200
>>>
>>>      drm/radeon: improve PLL params if we don't match exactly v2
>>>
>>> The commit above causes my monitor to just stay blank after boot.
>>> No framebuffer, no Xorg, no nothing. I'm using a Radeon RS780.
>> Can you try the patch on:
>> https://bugs.freedesktop.org/show_bug.cgi?id=77673
> I did and it doesn't fix the issue.
>

