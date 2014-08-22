Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaHVVNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:13:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55828 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaHVVNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:13:06 -0400
Date: Fri, 22 Aug 2014 16:12:47 -0500
From: Mark Brown <broonie@kernel.org>
To: "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        David Brown <davidb@codeaurora.org>
Message-ID: <20140822211247.GB24407@sirena.org.uk>
References: <1408709666-5927-1-git-send-email-arnout@mind.be>
 <1408721456-8101-1-git-send-email-arnout@mind.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OJnKAutO47z+s2LZ"
Content-Disposition: inline
In-Reply-To: <1408721456-8101-1-git-send-email-arnout@mind.be>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] tps65910: Work around silicon erratum SWCZ010
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OJnKAutO47z+s2LZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 05:30:56PM +0200, Arnout Vandecappelle (Essensium/M=
ind) wrote:
> From http://www.ti.com/lit/pdf/SWCZ010 :
>=20
> Glitch on SDA-SCL not managed correctly by the I2C IP

Applied, thanks.

--OJnKAutO47z+s2LZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT97JHAAoJELSic+t+oim9Z/4P/RlDW9p6gu6H6HkIvI00HIJR
OV8JxBSmFqI53LX7MpmIOZj3OTEle9PwMYaoFkmnwsinAKLXQWZ1ASmhYY/rZMj3
n6fkAvkx8QULkCfs2jEeRyCRtWXB/MJvq0mJge5/jcW0e3ZS2PTNTQnjRzLtPrp0
OMmfKF16N4vYk6FCbkMdx5+QghCAQfmKr2Ok6aPwwwBBg+eUQiRfZZBnRGw7Ezhg
/u2TXCc++lEva8N2xRY/friWq7D6WA8FMEWy3p0HdqK2ThUQuHgTNOSuLTFf39QA
O3C2t0QzC2oVbP/JyEy+EZs2a5AkVx5U7siwcV85K1b6I7d0F+88MJhpheN/Xtyi
POmPIqL4O7eFhaSfCX2a0xrwie8ZcM4U5+0+qpCEwK/hxk2v4Q0VkeN73OW3a2ir
DiUKmZmSKaHv3XRGq/9SRmL2OqhFh4M/gjZKIJOdXjGrU1qgYRENTzHyHwNEEISq
OgljwTx8m/dYGNETA8wjjz22mszCO8AIjjTCheEyRt3LWkJRi7iyF/byR3PvgV+P
MZpxjGCDsoGcvTHI2xaH1eYKBwZwP4Q/+47IZaJ8WAtN4c5JptPZY4CCdletbWmI
eHIpI0cl0mlNMj0JosmjAvmLTBCQuLKgpKf3TvE1ylu9udpIMZ9k5P6JGHHQVdY1
O1gqFqXnI9xmf4bnp/wh
=OBj9
-----END PGP SIGNATURE-----

--OJnKAutO47z+s2LZ--
