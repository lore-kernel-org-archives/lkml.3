Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3KYIqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:46:37 -0500
Received: from sauhun.de ([89.238.76.85]:37425 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab3KYIqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:46:36 -0500
Date: Mon, 25 Nov 2013 09:46:28 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Fallback to of_node of parent
Message-ID: <20131125084628.GD2705@katana>
References: <528791EF.9060505@koalo.de>
 <20131116160601.GA8723@katana>
 <CABDT8WzUoPmPzDnjD3w+Oj=jUVcMf91+toWDS+hK6CrXLveCFg@mail.gmail.com>
 <5287A463.6020307@koalo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Content-Disposition: inline
In-Reply-To: <5287A463.6020307@koalo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 16, 2013 at 05:59:15PM +0100, Florian Meier wrote:
> I have looked through all bus drivers and in most
> cases they have a corresponding line that could be removed.
>=20
> Although, this patch would break i2c-powermac, because it
> relies on the fact that of_node stays NULL.
>=20
> Any idea how to handle that?

You are right, yet I don't have the time to look into that. If you have
an idea, please go ahead.


--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSkw5kAAoJEBQN5MwUoCm2UbsQAJ8VoKZN54O5v8yuc9Aw7tTz
4KyDLYz6h0TRv4Csg/yyACx92jhfi8zknWM+Vh4z7bTU/FdIx1GAb6AjPHXNKn0j
+2S0vm8BL6OI2HyphWG+X/2BYRlot24lsZ3YhPPv6ghXLpfDsptO8oOpE4xux5fW
ynqaATQariqLRV6pPpWA3OO7ooFZOxSqdraWMRa5kWQVeYtWnvE5wKAmlPkGiezv
LBHi4AaI4/3kTRNEan7aN6s11XK11N2YnLiNgwg4jT3HLdQk+LcvyexcL6vggOGL
2BpjXBlgRBnpz3YJG+0Qbd2tpN2eypZE3NshN8AHoZIXc7fXnSSzYAB2qTjMmIoY
j3FBM6dbUZtwEDAtiJbzKZpnlT5sewYQM0rDL50uNSJO7nzbE8xQ5voBwH1Bxi60
SIPPoVjA/hMPJT16FMtpWbbgD7rYBrDOsjomQFNHpO27gI6NtyQHM//dpTOkpEtC
Lnbv9Djc/QDzFo/fVLWZlG/U2hFVvjBOqETD9/lBxaR3rcDGuBKzpcNkwMtC6y8F
VMSBKvipfZ69fuMCUKLoLJbez1BSKoRnTvgaIzF0nsuheEBnfgzstwNVSwNmFj4x
cine4fKKedUQXRXZ6viExHQI4p6CQPlZ2zY0DLOUlllSv+ai08T/vRATYWPINjpq
N9RWopmYr3URVmQVZhkF
=OA7v
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--
