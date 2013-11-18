Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3KRXbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:31:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55596 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3KRXbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:31:36 -0500
Date: Tue, 19 Nov 2013 10:31:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: error fetching the cifs tree
Message-Id: <20131119103128.101d045189ba64732d5d6640@canb.auug.org.au>
In-Reply-To: <CAH2r5mvZmGqXzuDX2G=WaWV-XD24dPEdwkS1SCSOO8EzB+=h3Q@mail.gmail.com>
References: <20131119102047.a103f012e381f64da3cd4c2d@canb.auug.org.au>
	<CAH2r5mvZmGqXzuDX2G=WaWV-XD24dPEdwkS1SCSOO8EzB+=h3Q@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Nov_2013_10_31_28_+1100_Y1MX6.mRAhJnvRsi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Nov_2013_10_31_28_+1100_Y1MX6.mRAhJnvRsi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Mon, 18 Nov 2013 17:26:56 -0600 Steve French <smfrench@gmail.com> wrote:
>
> It is there now.  I had just (very briefly) deleted it for a few
> minutes to update the branch with David Disseldorp's ack on an earlier
> patch so you might have tried in the very few minutes it was gone
> (Murphy's law?)

OK, thanks.  You do realise that you do not have to remove a branch to do
that, right?  You can just do a forced push.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Nov_2013_10_31_28_+1100_Y1MX6.mRAhJnvRsi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSiqNUAAoJEMDTa8Ir7ZwVxnoP/iFKmG6n8wU8ingYg00YLuQO
yPcOLLznO4zRrOw4w3mpPpBmlfhh/kg3t3aXAURQxgJ+Iyzpba/K3XKB/9UXCihZ
qrFbgU7+F8sGgQxYOTbeH9KOeDT+4m2UzrZOdhP7NebNdI2buV8gWf8+LNd+uzG0
E+ihUbTsxUzbBKnVeVe9K+jEHpDLaB0jD+bV2Dvz3za7s/+bU/O3dkZrPhay2GD5
EOT+Fe9uag0d+9Z2auGeWSkc3YDbgTg6+b0d9JpUYyXKGjr/QQ4UbmX5WHHPeP5H
a3wN5Bu/AvMeZMjWmEubJXswr64YtPS9eoYJkVs3Y9IYXb/r8XZhQa251FHYDvwG
CTU6S0s3KWdrDyK0KSXn1fvYtgW3OZfXplr4INqNBKitaxE/VyVwTYaThUIjIJep
Erd64Y63C/agZuiCQge30TrYWnFkkZgjHZVGfyldM8KKAzHBCTH8yAkZ+AubPP8s
Dyi10Cm18S69+yGnOrr5X2JGt4ZS7zGRF/shSq9O4BfQKGbGzgdwgwr2RFtrlrp4
qNOjR0+Q/CounUY0yNFPvyL4I2bH6FcvEtUIXpj6Kp+dV/xfLpBFC1TqaDWIIR2I
mqzMwcSZNXur5/9wVWeGJ/kTczHam02Rlgqi3oRYLvzH04NqLLWemJrRkySXcvhN
9KgnMsO9dEgnG/kQpH0+
=QGCj
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Nov_2013_10_31_28_+1100_Y1MX6.mRAhJnvRsi--
