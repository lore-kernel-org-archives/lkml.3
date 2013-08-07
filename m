Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3HGPMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:12:39 -0400
Received: from sauhun.de ([89.238.76.85]:36505 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab3HGPMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:12:38 -0400
Date: Wed, 7 Aug 2013 17:12:34 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Nguyen Viet Dung <nv-dung@jinso.co.jp>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com
Subject: Re: [PATCH v2 1/1 resend] i2c: rcar: modify I2C driver
Message-ID: <20130807151234.GH2978@katana>
References: <1375687174-577-1-git-send-email-nv-dung@jinso.co.jp>
 <1375687174-577-2-git-send-email-nv-dung@jinso.co.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyqLL/JqMvClXZi1"
Content-Disposition: inline
In-Reply-To: <1375687174-577-2-git-send-email-nv-dung@jinso.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyqLL/JqMvClXZi1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 05, 2013 at 04:19:34PM +0900, Nguyen Viet Dung wrote:
> This patch modify I2C driver of rcar-H1 to usable on both rcar-H1 and rca=
r-H2.
>=20
> Signed-off-by: Nguyen Viet Dung <nv-dung@jinso.co.jp>

Isn't it possible to distinguish between H1 and H2 somewhere in
hardware? Then we could skip the 'flags' variable in pdata.

Thanks,

   Wolfram

--oyqLL/JqMvClXZi1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSAmPiAAoJEBQN5MwUoCm2/1AP/RsNhLGQzx1lTiCdZi1uLQbe
XoclsNmEWf28MAllnuoBKaCoutoMi73SxwCxTnj18BEEh97aASUWw7ouT5NiQGY5
rRoEnC6IhShTlcOV6ZB5hc4R2LUj6T7lSYkY0SvT7xXN5CvII8AhGd1zf8bD5OFS
794SahaycxemsZhZgGNu5roikFipPvrWrThbVamElh3x+cZzbaL/mBJ2iqMWrkAU
OkWmT3a9s/SUTUXWeD7sq5MpKsH7zXwUymGZcJCRFOLiej0DOP0mxx+NlujjScPD
JvipfodMIZXypkZ08kjxrmXowmZkKEkGNh/Zo9wG11ajcVzTC46tTSr6+dHEbiuV
4ThqOo8EZE8+YPfZjC799GrL6Ea84SvQQcPvyWnnTXioOCBFhet6JgkqbVnsm8kS
qUg3GeCIR596jzLOuv2+EW6b9IrGZHdFjc8+UL8yb6A6gVtIEWenf+PrcTl4NafQ
8t3lvSdd51Y7r3x7G15ZG2KBdD+3nhO7eTXB6LGGVOwPAV4dixAkUmEpbrpGwz/C
3y+gVRe0rK0vzwzStT6JsNqlGXBJ2+lmwApStF8A8AjOScUY3zmfdBUOuKlJ2K2J
y1eqOEgKYNilgMaqNzsR/VRmVd1d+6odcfnDn0o6jEmLstpxfON/m6t7+JY6Fj51
Mb+/tVnZjmcNEdAji7jE
=+uhN
-----END PGP SIGNATURE-----

--oyqLL/JqMvClXZi1--
