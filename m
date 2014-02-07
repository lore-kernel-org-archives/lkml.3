Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaBGNOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:14:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37831 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbaBGNOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:14:17 -0500
Date: Fri, 7 Feb 2014 13:13:59 +0000
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140207131359.GM32298@sirena.org.uk>
References: <20140206175059.GW32298@sirena.org.uk>
 <1391759007-25305-1-git-send-email-iivanov@mm-sol.com>
 <20140207122716.GH32298@sirena.org.uk>
 <1391778043.27491.61.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T43c3KFQhpwAjRij"
Content-Disposition: inline
In-Reply-To: <1391778043.27491.61.camel@iivanov-dev>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND 1/2] spi: qup: Add device tree bindings information
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T43c3KFQhpwAjRij
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 07, 2014 at 03:00:43PM +0200, Ivan T. Ivanov wrote:
> On Fri, 2014-02-07 at 12:27 +0000, Mark Brown wrote:=20

> > Please fix the formatting of this document so the lines are less than 80
> > columns, it's hard to read as is.  Otherwise this is fine.

> File is looking fine in editor with smart tab support

I don't know what "smart tab support" is intended to be in this context
but whatever it is it's not working well in the e-mail you sent, bear in
mind that you're looking for a readable patch.

--T43c3KFQhpwAjRij
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9NwUAAoJELSic+t+oim9eisP/30DpFKOX4dd4nJJQL5BeS2b
wSwgErmuLcfh7KQa0x/0iWv8LjgtOVR1FJO7RN3C7VwDkfvdw92ZtLbWE5FGxsIR
8yJp5hPm58wDOYm8DZCHycJJ30TuQcQin5zzVU+BWlDJtJM6SnDWtBwRE/5cs2BQ
KFllUNU+heXWZdMpD5naOflKEyV+KoLbrHDTyVFC6nSe+Eya9qpluhVFzv3Hv8e/
f2mmeE+xyprzELIZjDlc+/GlgyXhznq8fHn48gX2s+yyd9aHMhDQqqsZmX1rA+31
oYTg+Vkg2rr+m3Cor21PU5UijBxkuN7b+DkXW0Ihu8yDDiPMTR9eevt8+t+0DHFs
Cys84/HLG0GMIHB7cCFCqD5Z4oHUGHVWGxBHe0rThir81k4Xl0Rxal58we1mRKvy
gqNKr6HD9RvrKWAFBj0wOW8kgX0x4Va7exWHtRWTsGkBbCjxK62LbdiCtYpGXTO1
udGL/DaGE013O86fl4FEjpnsThNIyPQ1HtO1+Qsg5gwGSRB6qK0nMLNEdQLgZoT9
0X88QhhK6v7XZL+kOAsmvaSPTvw1KKc2JrqTuBwEdj3SHRiJnVfY+CFwR47wzBuF
NDK/SZPYQZ4WEBm5SdaEw7BlCcpwmVMEw5HysbBRvYuFGbbh8h1Vg1tqAFWT2CjJ
rtjz/GMOS6yB9UFEQ3p6
=ZetQ
-----END PGP SIGNATURE-----

--T43c3KFQhpwAjRij--
