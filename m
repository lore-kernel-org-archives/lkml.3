Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbaHZJqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:46:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33742 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaHZJqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:46:38 -0400
Date: Tue, 26 Aug 2014 10:46:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        David Brown <davidb@codeaurora.org>
Message-ID: <20140826094619.GG17528@sirena.org.uk>
References: <1408709666-5927-1-git-send-email-arnout@mind.be>
 <1408721456-8101-1-git-send-email-arnout@mind.be>
 <20140822211247.GB24407@sirena.org.uk>
 <20140826092521.GH9574@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+UUbfbeT7dlNqfT"
Content-Disposition: inline
In-Reply-To: <20140826092521.GH9574@lee--X1>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] tps65910: Work around silicon erratum SWCZ010
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H+UUbfbeT7dlNqfT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 10:25:21AM +0100, Lee Jones wrote:
> On Fri, 22 Aug 2014, Mark Brown wrote:
>=20
> > On Fri, Aug 22, 2014 at 05:30:56PM +0200, Arnout Vandecappelle (Essensi=
um/Mind) wrote:
> > > From http://www.ti.com/lit/pdf/SWCZ010 :
> > >=20
> > > Glitch on SDA-SCL not managed correctly by the I2C IP

>  drivers/mfd/tps65910.c | 5 +++++
>  1 file changed, 5 insertions(+)

> > Applied, thanks.

> Eh?

So, this is an example of why it's important to both use subject lines
matching the pattern for the subsystem and try to select CC lists
sensibly.  I've dropped the patch.

--H+UUbfbeT7dlNqfT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/FdoAAoJELSic+t+oim9yBcQAJFJYiFktMQRv3Ci3gkIACIu
FDmZTZpr52Y3ZR2z4iPhrlwxLyukqhfbBwWD/WXL2fxMEq+YgJKOzxOKy9Gsw5X7
ZvSj3qROxJa7zB/doVlHoVyGdC4jxP+Bhs1M6UBnAHKo1wBnqBtOJCgpVn9kJOzc
dDIwVHKSo939SuVwGCJqDLbQy6mNzYN2lR2yew8cFmOMKynobnXkoWEJsgAKmyeS
zRnTgoa9hmD3b/n/6maQ3ClsPeFbkncjUWx4yFKyG1qG3idBCpLE0fhsRB7HWY8k
q9XJ9pBYYG69ve9CJ6jKXFT2l84NZ07I+2iUB6604Pu8kk/4VaiYMVq8p9HTFK6g
LDI1IF2ix5K7wS/+Fb99bKT/brnJ8wBzqdDDFDN3TSLohLdwzgd+w67xKLrkgL0Q
bP+4ZC0xPt8KyVaBx20BwCiF9OsnuFf6nTaUT3wqNuH1EvBJgpOWYchxA8jkqTf8
AwbmyrDH+hJscaCWYGoCXjs+JM8lev6AUaHtq1rhFnkTz9mKNzHGJFCC9bI00G4Z
PX1Xvd/PFdDCi3GJthYsmRPu1PRlwgV1elV7inaXtyxZ+KV9Tq3Qs3JOB+VwvPiL
AIXnm109/nIxavkKD18wgBRio0h9IeZrOcOQTXv9sCH4LUXlTPaYVB4S76Y+e5W0
a0y6V5bboaLAnOyt3ouE
=j6ZH
-----END PGP SIGNATURE-----

--H+UUbfbeT7dlNqfT--
