Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaBYL6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:58:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51623 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaBYL6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:58:50 -0500
Date: Tue, 25 Feb 2014 20:58:40 +0900
From: Mark Brown <broonie@kernel.org>
To: Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Cc: sachin.kamat@linaro.org, linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140225115840.GA25940@sirena.org.uk>
References: <CAK9yfHyAK+LtQLr_b-OLHa63dSNT5KN7MBHxqVoTbiHVb4-7DA@mail.gmail.com>
 <1393318071-13524-1-git-send-email-philippe.retornaz@epfl.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X26S3VlOCigMEekJ"
Content-Disposition: inline
In-Reply-To: <1393318071-13524-1-git-send-email-philippe.retornaz@epfl.ch>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: mc13xxx: check if DT is enabled
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X26S3VlOCigMEekJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2014 at 09:47:51AM +0100, Philippe R=E9tornaz wrote:

> +	if(!pdev->dev.parent->of_node)
> +		return -ENODEV;

I know Sachin was going to post a more complete patch here but watch out
for coding style - there should be a space between if and the (.

--X26S3VlOCigMEekJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDIVlAAoJELSic+t+oim9+34P/1rdU48dNyH3cTlcvI/qKA/a
KH6lmWtPLF0MAf2+Vn0+xs6Z/qmEQz8uAYZRMC6BK23DOe6hBb3px7j8jwapp7jT
iAAiO6eo7ZeG/78nj6moYlyPxEGoJlr/ihpnkv0jIonUMnLjR3QNWXPeSsSAjqXN
dYB8A/xwqOSzvJipiGSiIE+pYI7Aq3C2fOxpnQ/hQdPYMHwN21Zmv0eMM/dnF+KM
Yxgq8XsXc1r7UR135v/XHV81QfRPLUPitbipw6gyH6lUrZSu4g6fZshF+JbcgdVJ
sCnAHX2HyybeGiCZTqRKP072h4atKan2gbkQjm+VHhI27aPSn8hnsEgnDdEG77L6
MvvQvuV8EFcYeYNV59UsUpzIrFZIYhwsrAyewVIh+JLZuUt00HvvWsNPN3fCY502
E4aBZxnEeJ72GQLDJVWCqHUQ3r/F9uNTiSfsqe3eMTU/m85Kemw8Z9p9Hs6P5kli
yR8YZ5ipou7bYwVXOEgZNjwXFXaD8SY60A0uc7yvw6e1QD5aV515b5F7m+mmK+l3
nAgaBacFyLbapXd6GjXYPGzgPg0WHJypcQvctU4MG/JzSUDPfwGW364K82NS3YhQ
uDfR73MGxh8p3xJhQtKZ1KM/yOtCBWOq6OtnYnrg6BHqRi8SRjwz8F+RN8Cqnt/i
bzhb+0Q4ZWkJ5fwPE607
=iDuI
-----END PGP SIGNATURE-----

--X26S3VlOCigMEekJ--
