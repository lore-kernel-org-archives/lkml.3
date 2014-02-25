Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaBYXHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:07:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51835 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaBYXHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:07:31 -0500
Date: Wed, 26 Feb 2014 08:07:21 +0900
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140225230721.GA2927@sirena.org.uk>
References: <201402191637.s1JGb45N017694@swsrvapps-02.lan>
 <20140225085701.GD19099@lee--X1>
 <24DF37198A1E704D9811D8F72B87EB51BCFDB5D2@NB-EX-MBX02.diasemi.com>
 <20140225115036.GF13246@lee--X1>
 <20140225121555.GB25940@sirena.org.uk>
 <20140225124050.GA7571@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20140225124050.GA7571@lee--X1>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2014 at 12:40:50PM +0000, Lee Jones wrote:

> > The advice here is usually that sending against -next is a good proxy
> > for sending against the individual tree without having to figure out all
> > the different trees - almost all of the time the effect is the same.
> > This only applies when sending patches via e-mail, for git pulls it's an
> > absolute no of course.

> Good point. But it's worth reiterating that this should only be done
> if you have dependencies which haven't yet reached Mainline.=20

It can be worth doing anyway with a subsystem that's actively developed
since sometimees the dependencies are the other way - the APIs in Linus'
tree may have gone away.

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDSIfAAoJELSic+t+oim9Dh4P/0KRHYoJ0XpdnMuYDwWvVd5D
gg9Dy2HKt4EK3pu0OBrWCztlpZpnxM4/iaOjmYisJpYQjX1kxHlEUnZWRJkLNNyX
jMTSo8pOKyEeIsDrZqtbCI50T9bCJgU2c9NdkhFe6oeRV3Aj2vfdQwwyVTzS/hJE
7l6i6qryj22Ub4Jw2pCp3KVaJcm9OLV7rayKAi3M93CSRfCH4lZupNw4fdeGS+J+
OwcgIa2e26ME9z9IqJMCdfGzbL7CX7TevrZDUBFR5T0riaUV6WWv1oQJ0t2BJW0R
Vcv3RW0rIf/mrRzuQg5urz0mu3amF099/xDtQqAavpPO+UnAAyB5IbvXoiX4nlKx
T/ZLaYt8jqRbWCHPdWoUjhXp96RcBucIjwgO99MV1rELW+LhVhPjQ0BKGOcrd0Yi
5vUohyNS+I64g4XxyEIRfKIcnnViCgya2bzzsL0E5jg3DUZRBooAf5QMY3CPB8Kt
V1JeCoz+/PQIbvUT03J7ZobO5DSgSHCTzM6U3TjJw6ORiTTL40f5tXdddDYxvAdj
S9dCIc4xe9mt1SF39TQUTqAn98BvUGDk4x+/xfY28+f2T8JUYHkGOPxCgtwTe00v
qwsxw24VW5oDiQCM8oT6MTm6c97xXI54fBAaF2+oueOu+Yd9zznUpHlTu7zZLhuO
alCFSq21OXV8FchrVixL
=Zrir
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
