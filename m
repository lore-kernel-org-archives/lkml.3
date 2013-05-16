Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3EPOxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:53:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51423 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3EPOxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:53:02 -0400
Message-ID: <5194F2B7.6080204@ti.com>
Date: Thu, 16 May 2013 10:52:39 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [patch] Documentation: allow multiple return statements per function
References: <20130515172021.GA304@elgon.mountain>
In-Reply-To: <20130515172021.GA304@elgon.mountain>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2NMVSOMWVQWOQPRKRSNHI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2NMVSOMWVQWOQPRKRSNHI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 15-05-2013 13:20, Dan Carpenter wrote:
> A surprising number of newbies interpret this section to mean that only=

> one return statement is allowed per function.  Part of the problem is
> that the "one return statement per function" rule is an actual style
> guideline that people are used to from other projects.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index e00b8f0..7fe0546 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -389,7 +389,8 @@ Albeit deprecated by some people, the equivalent of=
 the goto statement is
>  used frequently by compilers in form of the unconditional jump instruc=
tion.
> =20
>  The goto statement comes in handy when a function exits from multiple
> -locations and some common work such as cleanup has to be done.
> +locations and some common work such as cleanup has to be done.  If the=
re is no
> +cleanup needed then just return directly.

Agreed with this rephrasing.

> =20
>  The rationale is:
> =20
>=20



------enig2NMVSOMWVQWOQPRKRSNHI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGU8rcACgkQCXcVR3XQvP2MJgEAmV6bA22/4MPPrGI8qWgq1x3A
G+6p2fxl8Sd8xu0dGiUBAMCS33hsHuy8hN4Sd15kPH6XLlcV1IP8py7gaptvZ+8i
=qEZW
-----END PGP SIGNATURE-----

------enig2NMVSOMWVQWOQPRKRSNHI--
