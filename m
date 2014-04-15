Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaDOJqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:46:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57920 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaDOJqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:46:43 -0400
Message-ID: <534CFFF5.70801@ti.com>
Date: Tue, 15 Apr 2014 12:46:29 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Miao <realmz6@kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        Steven Miao <realmz6@gmail.com>
Subject: Re: [PATCH RESEND] video: bf54x-lq043fb: fix build error
References: <1397546239-6650-1-git-send-email-realmz6@kernel.org>
In-Reply-To: <1397546239-6650-1-git-send-email-realmz6@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="jq0wtTc0SQ3mpriR7WsHnvXV2tA2RePiN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jq0wtTc0SQ3mpriR7WsHnvXV2tA2RePiN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 15/04/14 10:17, Steven Miao wrote:
> From: Steven Miao <realmz6@gmail.com>
>=20
> include <linux/gpio.h>, drop <asm/gpio.h>
>=20

Thanks, queued for 3.15 fixes.

Btw, usually it's good to say in the description what kind of build
error happens (i.e. copy paste the error).

 Tomi



--jq0wtTc0SQ3mpriR7WsHnvXV2tA2RePiN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTTP/1AAoJEPo9qoy8lh710pIP/1fU3dKO2a81CprHfEDq0y4t
jy0heifu2dKmNZorLKU4SCm/WOOU1GLP1yfdwxbgPSiYLSNK4E+wzyD/f3hkZbkb
A3c9tpAQ6FwuhzD+0+qDSCToBqTy/uu0g0NBmtOxFxn3GQPzehFtAJ6sQJ0mme3S
pIsLFf13nOhy/pyHeE0oq8N8JHEGCXWMQT90z3yvCUve9TUTngiixSfav/eXCso/
yWSK+/Yan59FnNtLJMk1Wc0WNrO1hrE3Wr7XkqemqUmpt0i2310QIGB/48jqHAcG
PUsHg9fdB4zHwYcZ4v+xzO9Zad8z17KQigFKpDQ/61WtgclVQ+NjrdPSNW/FjAid
sLce3oODbs/kqi8ZS+hOLz6ycVV+viFk9EBE3miRsTYi8ok3znG2hlYDsJ38i9Bu
LeXwlGdcYWHK1YWSLIOFTysvQ7TUa+orLXgXoB5nsdPxBXFSbjnJtJXqjF6a33ep
qpd/5SHqCm4Wo5LPfRwqDioi8xNtavv3MONQd6U7myQlISjeY++Ic59iWPKd2S4c
Lt59fnFrU1ZRVKH5hfYQVKDc7u0+tnM+XOANmYmiVi0Zb0G2r+zZghgu+1NH83ca
4GCz8vpFu4to7zIpwVVvNMTKBukCUWtDB9Kg11dqoc+eeAWhOh5NGsfPzSl2DGx4
PUSpLlbTdQujcWyMwzER
=0gqq
-----END PGP SIGNATURE-----

--jq0wtTc0SQ3mpriR7WsHnvXV2tA2RePiN--
