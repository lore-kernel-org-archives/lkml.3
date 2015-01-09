Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbbAIRLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:11:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47260 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897AbbAIRLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:11:52 -0500
Date: Fri, 9 Jan 2015 17:11:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        devicetree <devicetree@vger.kernel.org>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-ide@vger.kernel.org, Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <20150109171131.GH2634@sirena.org.uk>
References: <1420799989-10645-1-git-send-email-gregory.clement@free-electrons.com>
 <1420799989-10645-3-git-send-email-gregory.clement@free-electrons.com>
 <54AFF7E3.4070506@redhat.com>
 <54AFFFDC.7020307@free-electrons.com>
 <CAGb2v674q4Cjp9qy9CbUXe2j5pT_ez98CKxXHC8u4Diap2TT1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FOk1sPzRVyI5JND9"
Content-Disposition: inline
In-Reply-To: <CAGb2v674q4Cjp9qy9CbUXe2j5pT_ez98CKxXHC8u4Diap2TT1A@mail.gmail.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/4] Documentation: bindings: Add the regulator
 property to the sub-nodes AHCI bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FOk1sPzRVyI5JND9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 10, 2015 at 12:29:32AM +0800, Chen-Yu Tsai wrote:

> Since the AHCI library code already supports the generic phy subsystem,
> with one phy possible for each port node, you could possibly add a
> generic phy that just takes a regulator, and hook it up that way.

> I don't know if the extra layer of indirection is good or not.
> Just offering an alternative.

Or if the supply is for the device at the other end of the link (which
is what it sounded like) then use that.  This just sounds like the same
problem we have for all the enumerable buses in embedded systems where
we need to be able to understand that the device exists prior to it
being fully ready to appear in the system.  Having the link/slot be a
device in Linux does indeed seem to be a common way people think about
doing this, it sounds like for this one it might be the most direct.

--FOk1sPzRVyI5JND9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUsAvCAAoJECTWi3JdVIfQTM4H/2UO7wLAPT10oLokFxKC8HXb
KP7QN4TELOy1HDifgnj3/qSDMrRehT51hVPq90sFgdzzop/FxEupk+AabC71nm32
w9ggTQejndTbFqr2rRHEKLiMLSvlPWi7kjXTvTSLb3nR0+CTR9cr82dvAbzUgyKo
FqvJNZ0DAZrvRnia0roNSslFrVsjZmf+jMFLSA9CbmQ2hKOD1BqIUpe0L4L2R+w9
W/hzs/R89kBcwTfHTvoPD11Omqzz0yT2gIiwGTA5Kh/cKAt5hlclwkmbQagjNGKE
sUdte9p/y32SLpS90qT3hYrQsFk5tYTzlFlKkpIBRpFFk4Fh1kaRpO0FDs8+vHo=
=4wRN
-----END PGP SIGNATURE-----

--FOk1sPzRVyI5JND9--
