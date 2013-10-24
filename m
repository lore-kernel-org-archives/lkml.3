Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3JXMpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:45:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49469 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380Ab3JXMpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:45:17 -0400
Message-ID: <1382618704.21018.4.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 094/149] can: flexcan: fix flexcan_chip_start() on
 imx6
From: Ben Hutchings <ben@decadent.org.uk>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Date: Thu, 24 Oct 2013 13:45:04 +0100
In-Reply-To: <5265037D.2080908@pengutronix.de>
References: <lsq.1382345188.205668698@decadent.org.uk>
	 <5265037D.2080908@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oxZ5d7sv8XbQuVhs/gAb"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.221.165.98
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oxZ5d7sv8XbQuVhs/gAb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-10-21 at 12:35 +0200, Marc Kleine-Budde wrote:
> On 10/21/2013 10:46 AM, Ben Hutchings wrote:
> > 3.2.52-rc1 review patch.  If anyone has any objections, please let me k=
now.
>=20
> Please postpone until:
>=20
> d5a7b40 can: flexcan: flexcan_chip_start: fix regression, mark one MB
>         for TX and abort pending TX
>=20
> hits mainline as this patch (fix flexcan_chip_start() on imx6) causes
> another problem.
[...]

This is in mainline now, so I'll add it.  Thanks all.

Ben.

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-oxZ5d7sv8XbQuVhs/gAb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUmkWUOe/yOyVhhEJAQpRrw/7BszhwFi40OPjMZhpnNYG77dmXuhHdx6e
l6it/dFAumoSByPfduwWS//8n4Vn6bMep7K1jRpNfKXw19O+EUgXmBDj2dFIObWp
7RfEExy7YnDG+NB8tBaW/mD3PqH0hi9UamQCtRImAhjhYLrYG+HJvOzf+8eSgk4K
E3a74bm2phchM2bmYVO5xKsJzVVki32Ap+iDlV2gK4UXpXoyfZqqn1U1VBaniEFJ
O8GzZktM3B/orGGHqkfiOfmEWOV59D5EZFAXMP3fXdTDvOuVkJoC8EGy/pFzlyAH
gt/rUem5dwUu8n4cIZyx5TqbiJI/VmQCq+3WW22HA1GsuiiOB/Xphl2R84HBl2Fr
L6W+qmbK6yjWYOwh25nj/hkvhPIhgm7upmA7DQG2SqZcL5E4UO3zAQ2C0LN3V9vf
xoVloPnJVgPVYvmL2MlWlW1KfU26+PZ+RTxEd+7OxJkfP1mZl1rcyGm5OqgjYCGx
iR8WxzC24DlLCp98nrBgiIUpoUbgNJVizPIBP3xAt5DRN0rxcDayt5K/jXIqsdtO
jV2f976IRcK2c5DEkdJCJqMOpyTPfDre0VmKYXxHSCQnygHglIr/q4J5CJ/xIZZl
T3zlMr6MnmPs+Lz99Vlo87lElFPVTpMT1twSiWvTzvzS8bVnsOzq4VElfPjId2zo
OLWD5NnGp6c=
=J2fP
-----END PGP SIGNATURE-----

--=-oxZ5d7sv8XbQuVhs/gAb--
