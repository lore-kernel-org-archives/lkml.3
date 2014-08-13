Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaHMKit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:38:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33151 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaHMKis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:38:48 -0400
Date: Wed, 13 Aug 2014 11:38:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140813103836.GJ17528@sirena.org.uk>
References: <1407921833-7818-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T480zUvqkH9MG8CR"
Content-Disposition: inline
In-Reply-To: <1407921833-7818-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2 RESEND] mfd: wm5102: Mark register write sequencer
 control 3 readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T480zUvqkH9MG8CR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 10:23:52AM +0100, Charles Keepax wrote:
> From: Mark Brown <broonie@linaro.org>
>=20
> During init the core checks if the wm5102 has finished starting by reading
> register 0x19 and looking at the value. This read always fails since this
> is not a readable register, mark it as being one. While we're at it provi=
de
> a constant for the register name (as supplied by Charles Keepax).
>=20
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---

If you're resending my patch you need to add your own signoff.

--T480zUvqkH9MG8CR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT60ApAAoJELSic+t+oim95woP/2gmHqY7gxzbtmpkOGulN1Qg
pZ7CL7BWlKJ8zHSKD6hVi/lNB2XM2nkL7eLitXwiu4qDmoy3ZEplKiN8SkUVpB2p
L/niRMuC+zd9xdxZ8ins+iXEdXkUt6o7v3tHJF8Hao2vlyaRzhiyO2Fg0klEvHiz
8X7hsbzCUyHDilPVe/iuwAB19BtysZBsGABmPIUbucRy4z45LFN4KqA+2o+BszL/
i/UGy/zQFEcw4IjYcwutqLf4dG0L+5kZX9HxSGxSjy+BL8KTSxbCv/ZqOI1RvPbv
IcpPZM2izbHSATWF4PBukDoVZEZ6XdPjhWmJzprYc/EcKHSjv2NBQ+jXHMqHeZNR
Y3QrVA3JKXDrDuiQz9CtWE+E7pntYPXhAqszp4fPlgaR/bzUIhHbAsGJS8dPl/rm
zicH4NpJjjkTyRzyAX4fA2MDFmkw000kMZqkrhcbRZyEKa6wrDNLXD8BuTUD48DX
AH7IGYO6nWg9/2UKedrZGwWHgbHgiEwQ4//wSx58TbsNWCIX6eoSH7k2vf1hxMg8
mwHERcwCt7Fvdmk+LFJsBI6UqRxTCIpNQ0cO6y1DvWqz8jUl0Q7v/xpFm43Y8If1
QgHpmJBXkWsQI3FAEHsvATnsnzqk3ptHvGiNSMWwfw9aOJf9wRX1JH71aJVOxmQE
rVWA332mc/nV0Rjps0x5
=qkMt
-----END PGP SIGNATURE-----

--T480zUvqkH9MG8CR--
