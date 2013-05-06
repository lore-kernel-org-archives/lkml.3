Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3EFPZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:25:09 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:37843 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3EFPZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <km8de1$mel$1@pye-srv-01.telemetry.co.uk>
References: <CAPweEDym3TSEKWB1PsRWZ77irkTPF-Qdm9nRGfRBrv72CQ8zJA@mail.gmail.com>
	<km8de1$mel$1@pye-srv-01.telemetry.co.uk>
Date: Mon, 6 May 2013 16:25:07 +0100
X-Google-Sender-Auth: fGlc9p87P55zbNvOuywiDLIht1c
Message-ID: <CAPweEDxJGExW0JWTnqxV_-HHO_d-6C75AzDrmawGEdEuWu_1Xw@mail.gmail.com>
Subject: Re: device tree not the answer in the ARM world
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Mark Morgan Lloyd <markMLl.debian-arm@telemetry.co.uk>
Cc: debian-arm@lists.debian.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mark, thank for this.  i'm bringing lkml back in [my decision] but
just this once as i believe the point's now been made.  i'm also
leaving it below [top-post style] as it's background, as well as
standing on its own merit.

i was under the impression that device tree had been declared
successful on power-pc [and wasn't aware of SPARC], so a reality check
is much appreciated.  in effect what you're saying is that the
standardisation through things *other* than device tree - i.e. there
wasn't so much of a problem of diversity in the first place [*1], and
this in turn means that device tree could be declared "more"
successful.

in other words, once again, the link between the original purpose for
which device tree was invented [solve the ARM hardware diversity /
proliferation problem] and its actual success in achieving that
purpose is demonstrated to be at best an assumption and at worst a
failure [in the ARM world].

that there are *other* successes - incidental to its genesis - that
device tree has solved is fantastic, but completely beside the point.

so the question becomes - unless someone can demonstrate that device
tree has or can solve the [ARM hardware diversification] problem and
nobody has so far - what *can* solve the problem of massive hardware
diversity [both SoCs and peripherals] in the face of pathological
corporate behaviour that i've outlined over the course of the past few
messages?

l.

[*1] for many reasons - not least but most obviously as mark clearly
points out: there aren't that many peripherals to support!!!


On Mon, May 6, 2013 at 3:06 PM, Mark Morgan Lloyd
<markMLl.debian-arm@telemetry.co.uk> wrote:

> [Grimace] DeviceTree works up to a point on SPARC and PPC Macs, where there
> is a limited number of peripheral device types and (in general) they're
> described by published data. Part of that success though is because these
> machines also expose a standardised UI (OpenPROM or whatever you want to
> call it) which developers can use for manual enumeration and debugging and
> which the kernel can use provided that it gets the calling convention right
> (I've seen a firmware change on SPARC break the kernel).
>
> Leaving aside the more esoteric peripherals (sending morse using a camera
> flash LED or whatever :-) there are at least t^Hfour problems:
>
> i)   There's no standardised interface to get at the configuration.
>
> ii)  It's not self-describing, particularly in the case of GPIO-attached
> peripherals.
>
> iii) It's no replacement for enumerating PCI-attached peripherals.
>
> iv)  It's no replacement for enumerating chips on a JTAG loop.
>
> Put another way, Cory Doctorow's "InstallParty" software isn't even science
> fiction: it's pure fantasy, and is likely to stay that way.
>
> --
> Mark Morgan Lloyd
> markMLl .AT. telemetry.co .DOT. uk
>
> [Opinions above are the author's, not those of his employers or colleagues]
>
>
> --
> To UNSUBSCRIBE, email to debian-arm-REQUEST@lists.debian.org
> with a subject of "unsubscribe". Trouble? Contact
> listmaster@lists.debian.org
> Archive: http://lists.debian.org/km8de1$mel$1@pye-srv-01.telemetry.co.uk
>
