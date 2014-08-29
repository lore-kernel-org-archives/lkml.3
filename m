Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaH2MAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:00:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39464 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaH2MAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:00:06 -0400
Date: Fri, 29 Aug 2014 12:59:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Xiubo Li <Li.Xiubo@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <20140829115943.GV29327@sirena.org.uk>
References: <20140829110601.GB21473@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s0H35NU0PUc8VBh+"
Content-Disposition: inline
In-Reply-To: <20140829110601.GB21473@leverpostej>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s0H35NU0PUc8VBh+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 29, 2014 at 12:06:01PM +0100, Mark Rutland wrote:
> On Fri, Aug 29, 2014 at 08:12:12AM +0100, Xiubo Li wrote:

> > The 'big-endian-data' property is originally used to indicate whether the
> > LSB firstly or MSB firstly will be transmitted to the CODEC or received
> > from the CODEC, and there has nothing relation to the memory data.

> Both Nicolin [1] and Mark [2] asked for the old property to be kept
> around for compatibility reasons. Those requests seem to have been
> ignored entirely; the commit message doesn't even describe why you
> believe removing support for the old property is safe.

The response was that the relevant chips aren't out in the wild so it's
vanishingly unlikely that anyone would have a real DT with this option
enabled.  I'll defer to Nicolin on if that's the case or not.

--s0H35NU0PUc8VBh+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAGssAAoJELSic+t+oim9TNYQAJwN380ACjc82CC/8I5V25OZ
i1VqXY0W+SHBnFx1ENACiHFAZS/IsiCd+n2h0yFlPrGfDGqxU+zZ/W+m364CJYSF
psd+Udnyx8TI1MPq9cbWyvWCCIS4CGjRmySNfk1l8u7YYUcR/+Z7QU2NHNzyyvcg
0vpvs7Ycqhp0WUIfMh4u7n3/2bCEBzgWPrbkGgpx3hgQ+9X/isFGKQQfFX/9jtn3
eigxkQ9B5eqNJjk5wa+tOaOYy66Us/8u8yXCe9T4i9UzgkRjjPY62rpoSe0HyREa
1ui7fydT/Olg6KLaaJqsOsKzUSkLKt8XSDCyQYigHf/s3ja3nwB+ku+A5LwStFSc
pJiPmh5S48ODao1fn3KXxdAYObYNPpFFYb5LEn6yDzT/VZMrmvfkVR/sMZewMsDb
MtuY/32fdVm/5Hk9UJsWVYx0lL/YyrOAKw718oHKcq8ZX8shaeTWp7rzyQz3DY13
RFtfeuu2HKtrfuFgNbGYbmWMb4iujpydGaCjNjrPIaAd45XdDmZOLG8gWUVJc4n4
uz2AmMd3C2IzBm6As6uns68VqeF0W7jczQX5Pd69HosVmgopCQwOlJl/o8QYst7R
XuQBGkhiWSxW3XUiu74Q98QUanthoaDEyk4CYD9WFNtBq+jNzACkbz/vtEzjDRJ1
PIgIV6U2vyS+ZTanKfXT
=CMuk
-----END PGP SIGNATURE-----

--s0H35NU0PUc8VBh+--
