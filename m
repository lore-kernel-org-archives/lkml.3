Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbaIHMOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:14:25 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:35249 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaIHMOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:14:24 -0400
MIME-Version: 1.0
In-Reply-To: <540D9A9B.6070706@gmail.com>
References: <20140905171959.GO5216@hansolo.jdub.homelinux.org>
	<540D9A9B.6070706@gmail.com>
Date: Mon, 8 Sep 2014 08:14:23 -0400
X-Google-Sender-Auth: boV_78OnRWEGN4dd6X6RunFn_WI
Message-ID: <CA+5PVA5eTMqON9TwPR-Mi7Bz=EY71q54CtaQ-T1U5pxpCODxpA@mail.gmail.com>
Subject: Re: [PATCH] drm/vmwgfx: Fix drm.h include
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Brian Paul <brianp@vmware.com>,
        David Airlie <airlied@linux.ie>, dmarlin@redhat.com,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 8:01 AM, Emil Velikov <emil.l.velikov@gmail.com> wrote:
> Hi Josh
>
> On 05/09/14 18:19, Josh Boyer wrote:
>> The userspace drm.h include doesn't prefix the drm directory.  This can lead
>> to compile failures as /usr/include/drm/ isn't in the standard gcc include
>> paths.  Fix it to be <drm/drm.h>, which matches the rest of the driver drm
>> header files that get installed into /usr/include/drm.
>>
> Is this an actual issue or a hypothetical one ? Afaict no-one is using the
> kernel drm headers, but instead the ones from libdrm are in place.
> linux-headers does not even ship /usr/include/drm on my Archlinux box.

It's shipped in kernel-headers in Fedora and I'm guessing someone hit
it at one point, but I don't know what the actual initial problem was.

> Additionally most (all?) vmwgfx components (mesa, ddx) use a local version of
> the header, which albeit not ideal should not cause issues.
>
> Or perhaps I'm missing something ?
>
>
> To the VMware guys,
>
> Any objections if we update the libdrm header and drop the mesa/ddx copies ?
>
> Cheers,
> Emil
>
> P.S. I'm against the patch in any way :)

Was that meant to say "I'm not against the patch in any way" ?

josh
