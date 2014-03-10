Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaCJQej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:34:39 -0400
Received: from sauhun.de ([89.238.76.85]:46385 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbaCJQeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:34:37 -0400
Date: Mon, 10 Mar 2014 17:34:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@st.com, kernel@stlinux.com
Subject: Re: [PATCH] drivers: i2c: i2c-st: Fix return in case of arbitration
 lost
Message-ID: <20140310163435.GH11592@katana>
References: <1393591976-10771-1-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAgJxtfIS94j9H4T"
Content-Disposition: inline
In-Reply-To: <1393591976-10771-1-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAgJxtfIS94j9H4T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2014 at 01:52:56PM +0100, Maxime COQUELIN wrote:
> This patch fixes the error returned to the i2c_transfer function
> to -EAGAIN in case of arbitratin lost, so that the retry mechanism
> can be used.
>=20
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Applied to for-next, thanks!


--uAgJxtfIS94j9H4T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHembAAoJEBQN5MwUoCm2KC0P/jExj86oqGhV6DDEA5sUAUyS
NiHePCfaoWOdZpqDdoonjSxtKhJoU5GxAij0UvabmCh/cnMfn5hfviFExwgwA45q
IK2TLjPjVO3SNAu1+O5uyAv57aZRyFtaKCAe95+pvN7IvHOGYCdUMiezrV8sLCVq
oGunhKEQqN5SRHsqMKUjAVq1MgfOrnqD5LKc/KvDEMyy0Fp67J8VlthnlxCXKKTl
x/cGwxz7T8yc74+OXwvS+dhuQtzfEYruPgslXExwMpmOgo86yQD3FpQab2pQ8iTh
1vo3r+qtZYmMph5BgnabG/RheNtAoqUb3HtotVpCK73pCXj22qd5zXnaymVZqzi7
UmIrMPSolpGlwmZzocEweOky5R81CTyKfD78qxARpH0nTMbXyThh8Cf/0YjOm5Wm
0RjhKuvuYI6c3sStywFL2LkMmL8OJEwFaMmEqchMEwZjSLLYYI3xzPs3DTkfqfDd
vfQ3fBfW6EJjYAHV4+bjSuYyokv6RR0of4iN5SLDI0ZtAhSy8oYo6qF2B4b6UU9l
hoHnVohgDeaAR2jOIVCY5Z2H8yqDfH0an13oLehOvNySFm7kiJcE/O/EJD8RKjnJ
7FTVu00HRILafpX9+ghV2kv7WElgQujl8KX4vmuRiwGdmXoPA7IHUuf9rgjD/Cfg
8vDvK8G4OT9gVTh5l+eL
=qF2t
-----END PGP SIGNATURE-----

--uAgJxtfIS94j9H4T--
