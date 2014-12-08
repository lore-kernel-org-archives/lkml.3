Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaLHJwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:52:07 -0500
Received: from sauhun.de ([89.238.76.85]:39663 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbaLHJwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:52:05 -0500
Date: Mon, 8 Dec 2014 10:51:39 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Addy Ke <addy.ke@rock-chips.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: Fix falling time bindings doc
Message-ID: <20141208095139.GA1088@katana>
References: <1417805379-8999-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <1417805379-8999-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 05, 2014 at 10:49:39AM -0800, Doug Anderson wrote:
> In (6468276 i2c: designware: make SCL and SDA falling time
> configurable) new device tree properties were added for setting the
> falling time of SDA and SCL.  The device tree bindings doc had a typo
> in it: it forgot the "-ns" suffix for both properies in the prose of
> the bindings.
>=20
> I assume this is a typo because:
> * The source code includes the "-ns"
> * The example in the bindings includes the "-ns".
>=20
> Fix the typo.
>=20
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Fixes: 6468276b2206 ("i2c: designware: make SCL and SDA falling time conf=
igurable")

Applied to for-next and added stable, thanks!


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUhXSrAAoJEBQN5MwUoCm20HQP/jcWHm32P7hLUIadcCH0pSaO
HrVbgasKdBAYsyQW55xKV2xQc/01keMXWaNZWti/uBRdoTBVjvkuSyykN+gQBGHu
5HOFE1QvA3h72gF5pMSFiG5YxCd5S4gL+W7cej1w/FD2T3D9AJjEl6uNHuwwJxgC
SGyBx2rohKF8InMHOn6RVCXRjr5IjTTpjhZpdkFIZfwKvJtOAFnuYn9bfoHcu5QT
lM2jW56aaW9qfPp8+59/Ln5VcwaR29/chZ/3e0uRKY1m5QaST2fUaRC5zo0+Ijh1
WvVkpJS8y41E/Hy9/qXqJFfdioZP0sYFG6UTlKIpG4KQidBUjixvH3xkjW0rskWo
eraLquoZfUc7gBlkRvW0gMRULdlEXqM/7BfomIT+eXJMTbIJuxywZB1QhUlYz756
BaapgNJ+VFSK4+eednS/9O+EqI7XqmjyFzQhhqNasSBOk2NEaGP0hPvW8vaMAfTR
ZmlWpHpSIUgAk8A2uOeniNWV/x7CQjj7+AgByvOrOkNTe22z0XJFT/B3H3Nu9bj4
mWRT4gODbUigZ6fuwOOAL2Kka9PamNLd1Vmbud1DRBdREpuvuljnoLqr1DxO86gZ
4J6/Z2P73ZDpMhk2a2mJ46PsZo0J6XKepDhRKkOxI64fEIXkk4PUqvrhK9x1U8uY
Ss4MbKo6QrnWDyv1s1A9
=SrVj
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
