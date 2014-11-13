Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaKMBCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:02:49 -0500
Received: from ozlabs.org ([103.22.144.67]:43030 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbaKMBCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:02:47 -0500
Date: Thu, 13 Nov 2014 12:02:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH]  of/base: Fix PowerPC address parsing hack
Message-ID: <20141113120238.44b75c82@canb.auug.org.au>
In-Reply-To: <1415839522.5124.58.camel@kernel.crashing.org>
References: <1415771461.5124.33.camel@kernel.crashing.org>
	<20141113091036.4e9ec43d@canb.auug.org.au>
	<1415833725.5124.53.camel@kernel.crashing.org>
	<1415839522.5124.58.camel@kernel.crashing.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_eW2/tve9mYpwuPinUdxq1m"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_eW2/tve9mYpwuPinUdxq1m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Thu, 13 Nov 2014 11:45:22 +1100 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> What about this one instead ? I want to cache it because that function
> can be called quite a while and doing two additional property lookup
> and string compares every time might hurt some platforms.

Looks good to me.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/_eW2/tve9mYpwuPinUdxq1m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUZAM0AAoJEMDTa8Ir7ZwVrnoP/A24CIX3wKmsCcSQJC4xXQQ6
yJy3tW0SnQYqrbLcYlu9P0Lxr/lm519TJt8BHik7qLAPCm62/XH4mHeARb83yKFA
XJDCmTcgLlMxd6be5OsAXJLzmuWv/NHk7DAqd4vgpgZHAgwV0rL6kSA7aHNRugjs
vo/y+aTsJ9gfGw8Nj0e6sXd/ESEOTPbW6LtbriofuI0jn6SmESmXnSjDWBGF8PdD
hAhBOSLtrGWubLvjbNkGWW+OBTey9DZGdv/8uWoV/O+mex5mKjYJ3A74NNfRgyi6
q7ADFO/EhTjHoVj72yo9Xvgz+nqtrJuLTEsDHQZAcu2atz4MdFEK/H6UAQRrQtYu
tEFNASCx7/hsjMPFwcjd44nAEVgfArFYZccz5p1XOAxY1UQlIg8Dp4zyQX3mXpdA
pAWikXuhh5Pq+SkicjEXvmwCxM/7LO4VYiafGo9SRmF7HCjUyTnCXxqMtu+y5hlQ
ekQgqG/ZXlU5TMYnMt3FV7wby4o32ihah71j6TI/nhqlJ8QkpnEVAMW7XJjjgkHY
s3u8pguu95zbkLK0+NdxMV2MI8+pyg6gINRXSQdla1sbbh9IIvczBVMyL7zxqcGI
3Bauhn3ANksvycEJy2LLPuh8R2+/BMM1m94ymmRtsc+wxfsnT3iVNWSTV3IaAyQt
Ev9cYcBAa/YONC9dMlBw
=qQ5C
-----END PGP SIGNATURE-----

--Sig_/_eW2/tve9mYpwuPinUdxq1m--
