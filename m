Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaCYQVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:21:16 -0400
Received: from sauhun.de ([89.238.76.85]:57493 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbaCYQVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:21:14 -0400
Date: Tue, 25 Mar 2014 17:21:11 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] clocksource: efm32: use $vendor,$device scheme for
 compatible string
Message-ID: <20140325162111.GC6374@katana>
References: <1395757522-6431-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1395759044-10700-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
In-Reply-To: <1395759044-10700-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2014 at 03:50:44PM +0100, Uwe Kleine-K=F6nig wrote:
> Wolfgang Sang pointed out that "efm32,$device" is non-standard. So use the
> common scheme and prefix device with "efm32-". The old compatible string
> is left in place until arch/arm/boot/dts/efm32* is fixed.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

"Wolfram" please, next time. No need to resend, though.

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTMaz3AAoJEBQN5MwUoCm23e8P/0qcFiMW+VTEMEFRvXFBa/S9
fV3h6zox5V114XknYqIgvJRRG/wpkqwccgj/kXwclhh6pjKtRKJQi/gfherNDeQQ
de/ag6g4svZ1dJkUZ6ID+2sGO1dm/GKOtnMlcYEzAlx60/hJqpss5Q4/oYSLNEo9
GRgCxMy1f3Uru0BKynwPtuWjxuQVMfkslTHLxhrRxwnWW1sjeG7D4NjuP/H5Nszw
k3Hyy3SF329Zak1zDDI9kOG8c3UKFb65meVklaVnOXv+rQXZC2PpBMFrgWmipwVC
vcsNKSjnwwBopI/qvK8cbzD9RdDsDv8XfRBWt6d4lnJpnVfbmhRQC/D+iZCVeD3m
iiM9JIhMd1kioWVggJ3n3rpttwn1iJi61bsWj4bGoNLjOeIiPfkLv/ttc/HY8gQl
RIkutMAaXQKa1ooiMq5lP+c7gK3Ngy35pPGPRh2B3PBGg/POFxTeGTQjLFKoPHUY
GXcKE/UJclUBms/QeKopPjojaIjjDJ/9mgzgvLQh/Ah8QgWGoJ8GbX+elHhM5zny
/Q+5XT8bCuOs2i4HJFfLczMCpYvqMOPIkxPqt22OTM72dKykG/nlai/WEdpcqwb7
5UmwhQDsiRcEDeDy8hRQcl/pG79v+3db9qvmx81KTWQEHaLNbxnKj3/apnc8tro0
a8/nyeyp+tOrU+ymo3Cq
=NieZ
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
