Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3BCAVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 19:21:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56773 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664Ab3BCAVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 19:21:05 -0500
Message-ID: <1359850847.31386.91.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 14/33] iwlegacy: fix IBSS cleanup
From: Ben Hutchings <ben@decadent.org.uk>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jaroslav Skarvada <jskarvad@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 03 Feb 2013 01:20:47 +0100
In-Reply-To: <20130201104725.670932664@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
	 <20130201104725.670932664@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-r/gt8L/7tKACwJ8hT37H"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 109.129.208.115
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-r/gt8L/7tKACwJ8hT37H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-02-01 at 11:49 +0100, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Stanislaw Gruszka <sgruszka@redhat.com>
>=20
> commit fa4cffcba9e13798ed7c6b8526b91b1631ecb53e upstream.
>=20
> We do not correctly change interface type when switching from
> IBSS mode to STA mode, that results in microcode errors.
>=20
> Resolves:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D886946
>=20
> Reported-by: Jaroslav Skarvada <jskarvad@redhat.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

This one didn't apply to 3.2 or presumably to 3.0.  Do they have the bug
and if so could you provide a backport?

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-r/gt8L/7tKACwJ8hT37H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQ2tX+e/yOyVhhEJAQqbrhAA0J8SokIBInhysi0upihK/115txAVkK9l
Kx7sAcgjVCGgz6x5Csf23q4sJIkmG4MR3q1QDLvaP+83iln3EsBinRydUWWL+IUP
m9YaHwb0W3rgMu408KBvwW0cC2tz8Qumsqx0tSYCb1Y7ze8EHPqUJuffFGUVMY/V
gQKqIxhH4+WLUo77lgWaXj1a5KwgQWKi6ySFqEgtbgX8V144yaAXRJg4k+B504kH
GT6YssvRwLoHz0yMbaPaabSGm1TIHYxEGusVNb7tySqwpduueyz18Krcy2PhmXOw
We3oIkegfSStgmN3XBaOSJI2tW6wIlsP/7RZaXyyv+tmjyLo0jRf+feJ7QqhBDe4
vu1kmam9GdugNHtZO8X5764DTJO8X/BLffMbD4XpVlEr+ZGIH3xQcH8qXfBKM7q0
sDynn3N1kiMpuNq/z8ggImZMf/i0HlMHWgwc5OSRzhgfg70hZEJ/RMIU9SRPM+ez
udq5FA6/Z1HKQxtfVlKZsDJ/zVsfEyrDS4RK5U2xPzA3+68k0Yk1WUBRea2k2VGq
FC0nmktGFFvd2nEZZPJOt5ZtMvIt79cWHBAgcIp31e/y3vqymV6IvjcgRvxqBcwr
5T0zAs/PjCki+hW74oW+SAZbYHQEWYo7OPGYwfUpeHyDKrStcyPFjVtD7l340H4k
BQWxfCxzCVs=
=zfCT
-----END PGP SIGNATURE-----

--=-r/gt8L/7tKACwJ8hT37H--
