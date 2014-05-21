Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaEUK3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:29:50 -0400
Received: from sauhun.de ([89.238.76.85]:46908 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbaEUK3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:29:45 -0400
Date: Wed, 21 May 2014 12:29:16 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: olof@lixom.net, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: mux: Add more warnings to i2c-arb-gpio-challenge
 docs
Message-ID: <20140521102916.GL2708@katana>
References: <1398792651-27115-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHuqAdgBYNjQz/wy"
Content-Disposition: inline
In-Reply-To: <1398792651-27115-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lHuqAdgBYNjQz/wy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 10:30:51AM -0700, Doug Anderson wrote:
> This adds some more warnings to the i2c-arb-gpio-challenge docs to
> help encourage people not to use it in their designs unless they have
> no choice.
>=20
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Woha, you forgot to add the i2c list. It nearly slipped through.
Luckily, I found it nonetheless :) Applied to for-next, thanks!


--lHuqAdgBYNjQz/wy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTfH/8AAoJEBQN5MwUoCm29HgQAINpfBjhm47mPkMwwwWq0IL0
lT9P2jq9Ad1P0ixLa4nju4n6W/nNonGEVMCzZKBOT/AAZADYU8gczsU5a+2tBlR/
r63HFipAPOhuNz2a2DslzsrvXGETcTaxBXRNgeyEgrtuA2ZuCROUnK17efDlVlEJ
hnIMD3nrNJvJ77+mKAGvFkpz+6bP9E8uCcplho5NZbAqnf1CKh7Weqsr45nfp56U
Y3qW1A1RiAhGMuMCYAtD5HoKO9zRnecX/Kvv0PXakYOCbhygEH+vQxo0AdsAEYTM
ZJNymbAPjjEsSjASQ2JulwMD//KJ4Pn7F+xYik8ZulLNw9JVubq2YFkXVRidE4V3
Mz/7816uI/O0K9MpdLtqQX53UrhwOqQ0vEHgtmRCeKIFpeP2AX4iNesG/h/K7rJg
0vniJcqUs/iJnAlAnQQ3ez0ryT2oeBCHzWKAAuYiux8FHof2DIoVHhWzneymutkO
+Y/sEB9SWAW1KpYvFOUTIspAixKiRg7TDO9PQk5W4cRwvp3Q/sed3nYDXkHRXNOt
IfJsdvO9e+D7pPP+wl+iBNte2MLe0gvr/dQN3gGwrzMsd3tz662IqLJTsqsBMPbm
9iZSzsbeujtnjLMyrLS6VY23SOKORCMqvwExnMDl3hBTqvd9xM5prxOZUZQLZqgJ
2NbFXMay5tRPXMum2NgA
=itao
-----END PGP SIGNATURE-----

--lHuqAdgBYNjQz/wy--
