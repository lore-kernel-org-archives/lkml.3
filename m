Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaKYULp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:11:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51764 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750925AbaKYULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:11:43 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Brown <broonie@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
Date: Tue, 25 Nov 2014 21:32:58 +0100
Message-ID: <2374046.oRBoy0cD3d@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141125193623.GL7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <5474D35A.3000601@linux.intel.com> <20141125193623.GL7712@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 25, 2014 07:36:23 PM Mark Brown wrote:
> 
> --njUEgrJvs9ryr/H/
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
> 
> On Tue, Nov 25, 2014 at 11:07:06AM -0800, Darren Hart wrote:
> > On 11/25/14 10:43, Mark Brown wrote:
> 
> > > Link from where - do we want to talk to the ACPI/UEFI forum and=20
> > > figure out some kind of fast track process for them to add an
> > > "it's already covered by DT, see here" entry to their database for=20
> > > example?  We also ought to work out how to make sure ACPI IDs are=20
> > > registered there as well, should be possible to have something=20
> > > simple as part of that.
> 
> > This is a current topic with the ACPI working group. We have the
> > following document:
> 
> > http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-=
> UUID.pdf
> 
> > I don't know if we want to have a list of them here, or if a separate
> > document is needed. The important point is that it is independent from
> 
> Seems to me like some indirection is going to be better rather than
> having one big document if there's widespread adoption, avoids lots of
> document churn.
> 
> > the ACPI specification itself so that it can be updated out of band
> > with the specification, and not be subject to rather plodding pace
> > that would imply.
> 
> > Rafael, I've missed several of these meetings unfortunately, and I'm
> > not sure if we've closed on this point. Do you know?
> 
> OK, I'll see if any of the people at work have been following as well.
> For now continuing to just document everything as DT bindings in the way
> we are already seems like a sensible interim approach.

Yes, that currently is the case in my view too.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
