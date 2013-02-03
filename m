Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab3BCNBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 08:01:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33295 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab3BCNBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 08:01:22 -0500
Message-ID: <1359896460.29976.0.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 06/89] powerpc/book3e: Disable interrupt after
 preempt_schedule_irq
From: Ben Hutchings <ben@decadent.org.uk>
To: Tiejun Chen <tiejun.chen@windriver.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 03 Feb 2013 14:01:00 +0100
In-Reply-To: <20130201130207.918022394@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
	 <20130201130207.918022394@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GHf5r4mvRSsgtPtM6M6D"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GHf5r4mvRSsgtPtM6M6D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-02-01 at 14:07 +0100, Greg Kroah-Hartman wrote:
> 3.7-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Tiejun Chen <tiejun.chen@windriver.com>
>=20
> commit 572177d7c77db1981ba2563e01478126482c43bc upstream.
>=20
> In preempt case current arch_local_irq_restore() from
> preempt_schedule_irq() may enable hard interrupt but we really
> should disable interrupts when we return from the interrupt,
> and so that we don't get interrupted after loading SRR0/1.
>=20
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

Is this needed for any earlier kernel versions?

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-GHf5r4mvRSsgtPtM6M6D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIUAwUAUQ5fjOe/yOyVhhEJAQpBRg/4z8k3CVQ5UoAb3fW4kyge2An2twCpUsGz
HeMjohTbwmWW8EvfY1VuBB5+PaX8fPHICTmZK5UlJ9ziQKHmAiCqRYSF+jHMX9Ul
07qVsEJ+e4anvqEPkb7bMVpBOpIu6csl2xfvbJ6uTmCm+trBC1rd8FAJiVCWpAI1
mckEZeUW5Z4V1fDAJU4Nzq6g/QMC4BhcMLM7dbuzUxlcR5RxCPdt6hPxMxVvSj8m
7cRXK84CzuYhrHh0g8FwTuaFPiME0E8+d8rfjj/axlSkQLOEwhv/+hdboyGqVe96
gT+oS/GZx4t3Fbx5SIhEctRfgKrjeiWHUuZhQvrSRc6509CScFgnmBKPhvXRGrt9
+PLUqqW6MJvfYYjXY+muZgdPVG1+TFNliEL+dwPbWA/51RQ3RUjPBZthR/9kWess
HwoostCeEfXyiyTvX04CWma1j9Y3s22n025lV3ZPhzP0sWv4P7yGqzW4m7eJHS0v
HM+rNEh4ccsGXAwj5/0+lMNBmLFt64jlxYT4E8KWcOC8vzywnEEoyFjCTpnn9skr
D9b271U2OMuMZ+0v6ityFoVHQbHAXG4slDwtPbIWzcn2n8h8wdvkn1tDISq5Ix3p
RtLV9SHff8QMguTUQhDmL0Glg2dzvDH0RGenizGr7WXNCm7VjXxhwqCxqSdwFLY5
2ITI02HKig==
=HGE8
-----END PGP SIGNATURE-----

--=-GHf5r4mvRSsgtPtM6M6D--
