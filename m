Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaGPVe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:34:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40775 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaGPVev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:34:51 -0400
Date: Wed, 16 Jul 2014 22:34:33 +0100
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org
Message-ID: <20140716213433.GD17528@sirena.org.uk>
References: <cover.1387336613.git.lv.zheng@intel.com>
 <7ac00c9c5a32f7a3ec98f061080ba1573ae57d0d.1405500886.git.lv.zheng@intel.com>
 <20140716120750.GM17528@sirena.org.uk>
 <4307509.CpjlMkz69H@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P6PRkhImOxklJvkF"
Content-Disposition: inline
In-Reply-To: <4307509.CpjlMkz69H@vostro.rjw.lan>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 7/7] ACPI: Cleanup useless ACPI inclusion.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P6PRkhImOxklJvkF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 16, 2014 at 11:46:14PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 16, 2014 01:07:50 PM Mark Brown wrote:
> > On Wed, Jul 16, 2014 at 04:59:02PM +0800, Lv Zheng wrote:

> > > The sst-haswell-dsp.c is an ACPI independent file, this patch removes
> > > ACPI header files for it.

> > Applied, thanks.  Please use subject lines matching the style for the
> > subsystem and send at least the cover letter for the series to everyone
> > so that they know what's going on with dependencies and so on.

> Lv thought that this would go through the ACPI tree I suppose.

Even so the subject line should still line up (it's part of how some of
us pick out which mail to read).

--P6PRkhImOxklJvkF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxu/lAAoJELSic+t+oim9wBkP/1QbAlgd9M7esohmJeMORy+S
QWPqzk1Nw/fur4BH2EZO+fc3WRRtpIk7gWXWgV+S9SHu1xIm5qjQreQriEf6DRFC
zH9iGs32EkRDq+6GAI1qlmHF2w153nQhMUt4MeD4GnaVfsZtc8Ny9x6AvOoDcdka
JV78pmoZ2acIVLLEUGgztfFFEV4boq8fdgoyIdKZRD+1F+1PDTi4+sK7LY8aS/7p
bXpdl6vF6SMLuLaC/nvVAdLHNDj6N61cDkpu/DF3ReTIdfCM8pGZyv3TgwnAYt6M
lffxpgLCiyklhJ1cDph0TCu6IOWyAyMZhpUFDEw+b1wDr5xFtzdI/YoiEcJQ6t+y
D3OAaAN2kNG70EskwH0yU8MCyDFqAnSbwQpUuxEzBCToIOT96HNvgGYDcpuYKAcY
Pv/Hg3xQSIQvRc7nOP/NunSHFi6Iw1EsHmfKttiAzoIq0vpRNN9H78rs66XtTM+t
rjyQ9zGNqZOQZIPclnmZoNFGv9gUK79X96CDU97NFib7kXm2rZOEfyxDLSEnSYkN
v3+popRs6i/guW5yMv1SY2kAESE5l/Exdm5N8gWgKNZi7sFZBRez+4qQb8a4GnSH
ewxUx98UerBq8QI1Mu2H/oefdGDj1o1IDaMTsezpEi6mQPe614CVTOAhTJyMhn0d
imclPC3RSOh3tJXAApV/
=MK6C
-----END PGP SIGNATURE-----

--P6PRkhImOxklJvkF--
