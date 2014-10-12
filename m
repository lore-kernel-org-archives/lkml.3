Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaJLRBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:01:55 -0400
Received: from sauhun.de ([89.238.76.85]:39270 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaJLRBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:01:53 -0400
Date: Sun, 12 Oct 2014 19:01:39 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [RFC] drop owner assignment from platform_drivers
Message-ID: <20141012170139.GA1389@katana>
References: <20141010072439.GA1741@katana>
 <20141010083627.GL5182@n2100.arm.linux.org.uk>
 <20141010182604.GC6075@katana>
 <2769473.KEN6DZKnT7@wuerfel>
 <20141011165650.GA1263@katana>
 <20141011205527.GA30877@kroah.com>
 <20141012055146.GA1310@katana>
 <20141012142455.GC21479@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20141012142455.GC21479@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > So, what is your opinion on the original cleanup series removing
> > unnecessary '.owner =3D THIS_MODULE' lines in drivers? Helpful? Noise?
>=20
> Helpful, please do it.  I can take it all through my driver-core tree if
> you want, that might make things easier for others.

Thanks, that might make sense this time.

So, I'll prepare the bugfixes, add the semantic patch, add this all to
my series and respin. It might take a few days because of ELCE in
D=C3=BCsseldorf, but I'll certainly do it.


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOrPzAAoJEBQN5MwUoCm2ufIP+wWbPAOAR062L5O/mbIMJZgH
ulvrC4Tw87l8wqw68usIhjTqk5wB8xHBYkhhEqFEcO0ba3qYUH7zpWhSlIGEnj4Z
qoVAepu27lTvCG8OwC+S0bqNchVjR47LrwND2rp2yPcZSVDLpmV0Phemkl2p4Z4F
etNG+P0nX3yMVNCOl/9BhH3DGXiGYV5bhviGwniO/joNqoNAR3BZ5hwEO8PSRWYb
HxL4n3rPjiZldLFEOyxgtd3xlf6kdJUkkVqhgbuS9bsGyEIvIRlsNIMZ5UYm99Fk
YUJ7IeSokPBFITswxHAHmCUnu+7CShivSnMQvVdeifO5pUU/Uncwq+BfmO0GHIN9
Sb4FRx+I8cDAVmhTknIAcZshYd64uTys7b0SyacteSRIxc/zrOS/gS/+GLBICDNY
jliz7nREUiOH6tUnUWbNPGVKFRsP/3I/XSfn4gW4fQrICUfHLMXc6+ZgIhpMqaCj
wwswiZMxZmWSSKzvrvdMqC5vF+W5KWHka5ARCRFk348VQO9wgM8EQpEsvZlzVUVD
UZyuCjK+xQ3KXlXws/3VzDfVJ7X15Q7bShqn7BdeiIE3UmtyGjs/1w0CQD6rr1k6
XeIf3+RoXc+fD6S67ASxL0pg52krw1AZHzdZIGPoW0VMsfOm+Yd9zvE2xzBH5pvr
67fXxpxwUtPisan4/s3Y
=LIxn
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
