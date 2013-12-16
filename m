Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3LPUup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:50:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38644 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3LPUun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:50:43 -0500
Date: Mon, 16 Dec 2013 20:50:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20131216205020.GY3185@sirena.org.uk>
References: <1387100211-19101-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6AmSH+YAqnsWd9jO"
Content-Disposition: inline
In-Reply-To: <1387100211-19101-1-git-send-email-shc_work@mail.ru>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: Allow using zero value for ack_base
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6AmSH+YAqnsWd9jO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 15, 2013 at 01:36:51PM +0400, Alexander Shiyan wrote:
> In some cases, clear interrupt register may be at address 0.
> This patch allows to use such configurations by adding additional
> configuration bit to indicate this.

Applied, thanks with the grammar for the docs corrected.  We probably ought=
 to do this for most of the fields :/
I guess this is for some driver you're upstreaming so a signed tag would
be useful? =20

--6AmSH+YAqnsWd9jO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSr2eIAAoJELSic+t+oim94+oP/jWOElodGQA5rt1H8wLRq87K
68lLxG467ApTdCHuwVArQMFJOg3xLUuAMkK/vxtE9wQek6kv+dShFvqa+ewhIrNO
0dxgAhtCt73z44VGi6J+DbscTQQ2ZflZTFHSAMYyTEX2vIX7BEm3NXJ3daq6FQWr
AEOJAR5UkQQ7OCdwnrsB6CliJsCUIg7UBlf05H3tPFLGd3+G+d364xyqSdi2gEdf
THODAeA+l+VdeMB2L8FZpKT91geCUrubb5O+eETTefZFd/zurXi4g+k1fVxkrmHs
K8HxuhqCYzzWyTHAW1mreeRGfOzfWF+ZNJML4n+9ZHuFeoJO2VSyHuP6Sp3Q+Zjd
064IpvBi27g+9mcqJ068H+Lvknkoi5mtGdsBYyIel3irz/z/+qi8PSs/1ok45PBA
Ri48OT+OXQdB3gEFAHdO1skz8kNWrmmfDcPh7dXXpE5RxsHBVvNZUzLOGwEFVL9u
fA7RBTZhaJvw0elZH5PtJsoZ8fd8AvOemtys63aMZKkesc23dMTYo6aCzMKB1Ayb
xBJ/He/8Fb2uribnsW6AsNgnL/GMf+b0FJDJA6G0A7gueg1rH3mvEwJnT5pkX7I9
Pmx4AcA2r9ycSqYsbo9VtmCMrv1+RwA0dZs99pGXWjYiy3g0u+OGyQkSUkfIhW8O
vis4DXbOYbpMYpmJ3+1L
=vgTR
-----END PGP SIGNATURE-----

--6AmSH+YAqnsWd9jO--
