Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab3G0MZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 08:25:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49623 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3G0MZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 08:25:29 -0400
Date: Sat, 27 Jul 2013 13:25:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Felipe Tonello <eu@felipetonello.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Message-ID: <20130727122524.GH9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
 <1374863133-6745-2-git-send-email-eu@felipetonello.com>
 <20130726185458.GX9858@sirena.org.uk>
 <CAGrhNMy7qZ8CbAjFX5Gv8OqYkit+Eqzr2zZTYXeQ-cNO22+pTQ@mail.gmail.com>
 <20130726224813.GB9858@sirena.org.uk>
 <CAGrhNMwGdMwhd5L2gGxQ=N=8nFk4L5txYmhEtLBVcFj-Etphnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wYxcee34aMWaJ3Dn"
Content-Disposition: inline
In-Reply-To: <CAGrhNMwGdMwhd5L2gGxQ=N=8nFk4L5txYmhEtLBVcFj-Etphnw@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] ALSA: Added jack detection kcontrol support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wYxcee34aMWaJ3Dn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 04:13:40PM -0700, Felipe Tonello wrote:
> On Fri, Jul 26, 2013 at 3:48 PM, Mark Brown <broonie@kernel.org> wrote:

> >> > What I'd expect to happen here is that for multi function jacks we
> >> > create a control per function if the controls are valid.

> Ok, so the idea is just to change the control to type integer instead
> of boolean, right?
> Because as you say, the user will be able to check the type of jack
> based on the status value, right?

It might be more idiomatic and more compatible with userspace to create
multiple controls for the jack, there was some discussion of this in the
past I think but I can't remember the result.

> > Yes.  If there's only one function supported the current code is fine
> > but for multiple functions it's going to discard useful information.

> So, what do you suggest to do that? I'm not sure if I understand what
> you are saying.
> When you mean function, do you mean the SND_JACK_BTN_n or the the jack
> types, such as SND_JACK_HEADPHONE, and so on?

The jack types, the buttons definitely sohuld be going up as input
events.

> If a codec creates a jack type SND_JACK_HEADSET (= SND_JACK_HEADPHONE
> | SND_JACK_MICROPHONE). It should be created two controls, name +
> "Headphone Jack" and name + "Microphone Jack"? If so, what about the
> status to report? How to know which control to report?

The drivers report a bitmask for status.

--wYxcee34aMWaJ3Dn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR87wwAAoJELSic+t+oim9+mQP/1k4go6YP6lj28tlHI9rFsQE
A6BmXP2rleyhzvSFdSPNf/2cPn6KqwwGoGX5kJ5GukvVlf4G3q44dWV8/vCBwMx5
nifxGL6qifMAvdv7a5JDsvyPMnHwRogYeKtM9pfRUgqELMa3ByXwAlDwQLuqucSJ
c/vrjJivw//kgryq7wWPquUbbSjQpdWdX+iFT+SnUxehKT8lzyQecIBbM3MQxzDI
m7J76KoKMqrseK03S33hnqjVOl+i1VkvnalnktMega/NKL+MSfpHv9ytiI1+51S4
4fMv8Dk17ZaKAAoS5aZQs9xO0N1onRPoy9KTvY+E6mp7IkkwxFM4gyI6wms3IjEN
on9c6vri9AqdUBSzomd1JvepjH/T1jxWfuyeh7bEWHPjz46hXhzLVU6aQ3pMZVfK
mDPrLRdySWCx7T4DJRRR0L4aRei+xqxk3tu6m8+ERIK50ps84XzT5AIpjElT7EAl
MG2m+tU8sC0q5zyCOgzgMbo9IRYXyOAFeYXwraHELi7OGpG7e314Y5UwonUuk0QC
cVoxODbL3JGxc/Tv1+yR8kVK/9U7wwrfmGN5Wfit1+FD8uhYfcETAaGhWzUhaa1b
KL2FW9OrVOY++2YC1G4VyZYyYCdVYOGbcZYA9k5jtpEzjAVRbDfl5nemxHvThnfN
wK4gmJgQkHsQEyXq2bWc
=7bGj
-----END PGP SIGNATURE-----

--wYxcee34aMWaJ3Dn--
