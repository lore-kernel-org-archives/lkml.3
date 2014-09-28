Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaI1M0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 08:26:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50802 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaI1M0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 08:26:13 -0400
Date: Sun, 28 Sep 2014 13:25:43 +0100
From: Mark Brown <broonie@kernel.org>
To: PERIER Romain <romain.perier@gmail.com>
Cc: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140928122543.GA27755@sirena.org.uk>
References: <1411834906-9533-1-git-send-email-romain.perier@gmail.com>
 <20140928103301.GN27755@sirena.org.uk>
 <CABgxDo+h2AYjAO4darK4+RTXqnhf4OqouGLfF2yuJCpu7r6tLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z0JXx0QNa4/JeB8y"
Content-Disposition: inline
In-Reply-To: <CABgxDo+h2AYjAO4darK4+RTXqnhf4OqouGLfF2yuJCpu7r6tLg@mail.gmail.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.138
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 1/3] regulator: act8865: Add support to turn off all
 outputs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z0JXx0QNa4/JeB8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 28, 2014 at 02:00:54PM +0200, PERIER Romain wrote:
> 2014-09-28 12:33 GMT+02:00 Mark Brown <broonie@kernel.org>:

> > We really need to come up with a standard property for this and document
> > it rather than continuing to add individual device specific properties
> > all doing the same thing, and probably also some helper code and/or a
> > standard operation for this - there's a lot of drivers implementing the
> > same pattern here.

> I completly agree about adding a unified and generic property for that purpose.
> I already proposed something for that on devicetree ML, see the thread
> "Proposal: generic property for system-power-controller".
> Unfortunately I did not get replies :) .

Did you CC relevant maintainers and send a patch?

--z0JXx0QNa4/JeB8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJ/5GAAoJECTWi3JdVIfQWqsH/2xGS5zNCoOxQajdk9xsFD1l
n20Of1CrP5/nv0zcN4NhSAoJvPXFIq1wkGOsj4pfq1/swBLsOtNt38yQ/EVT9nkh
yNry4WCzF7/V9UaSSFgQ662ISNu49rv7Py7bC9jBhY+beQ16Vrmd44xrgMj1RFgn
1XW8DQ4U+7rfE77X0R9sOxIjV2o99YvW097h50z3LqsWDUj98whSDUzxaG9MNS6z
Zk7uCzfTGcN751BFmMV2eUwvhvY3Dhtxi6/wQQ4TaBq6om6G91B/4PAHbo4p8b6O
ZxATyy6EIRmMvgkewNbst716rT0PApcecfOlUOYvzKkKvKodETaNTEFN7GIApZU=
=U1Kk
-----END PGP SIGNATURE-----

--z0JXx0QNa4/JeB8y--
