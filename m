Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaJGRyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:54:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39063 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbaJGRyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:54:50 -0400
Date: Tue, 7 Oct 2014 18:54:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Marcel Ziswiler <marcel@ziswiler.com>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch, Fabio Estevam <festevam@gmail.com>
Message-ID: <20141007175402.GT4609@sirena.org.uk>
References: <cover.1412381377.git.marcel@ziswiler.com>
 <74ea4fe20e653d2da555c8d7dd1478746bccd529.1412381377.git.marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z1gw0Ba8VHj8Ap4r"
Content-Disposition: inline
In-Reply-To: <74ea4fe20e653d2da555c8d7dd1478746bccd529.1412381377.git.marcel@ziswiler.com>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/3] ASoC: tegra: add tegra sgtl5000 machine driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z1gw0Ba8VHj8Ap4r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 04, 2014 at 02:15:43AM +0200, Marcel Ziswiler wrote:
> This binding and driver describe/support playback to headphones, and
> capture from line-in and microphone.
>=20
> This driver is useful for the Toradex Apalis T30 and Colibri T30 modules.
>=20
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes in v3:
> - Revert to not using simple-audio-card being incompatible with tegra.
> - Rebased to for-next.

I can't help but think that't there's still room for a Tegra simple card
here, there doesn't seem to be anything particularly CODEC specific
about the driver here - it *could* use simple-card were it not for the
CPU side.  This also seems like a specific example of the same problem
we see with supporting DPCM in simple-card, we need a way for CPUs to
be able to say that they need some general setup that covers the CPU
internal configuration.

--Z1gw0Ba8VHj8Ap4r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNCi5AAoJECTWi3JdVIfQEAQH/i4sms+iNsBEGLCrkZmdPBR+
NdQBJrohsOUj0V4xeOOspSVUlM3PeR2PDEh7QxNInRnFRmi8+r8cqmgX49AOhFr5
vk3s+aIJY+vjhpctHG3uzwKvJC/4pdem+oV1qdgjSTs1EmZIMpiilRzavx/Etugu
ZYfVxeC7xNVsaYnBhIVSC+7mF4vDRaf+cPpfAGls7VkkuEw4X8eFs5hwKLMctY+r
RBxeiqQ6Qh7++Esj6nJE4Z9wFpxePhKnN4hfjcoka21U6oSfBaQkdp8VVEExEY8E
ms9B4g+ErcvtPJVoBnLaWXTcO9eXc5Dr49PmqDyvaUn5Q5tFcIEsvGqjBre63vg=
=ZNY2
-----END PGP SIGNATURE-----

--Z1gw0Ba8VHj8Ap4r--
