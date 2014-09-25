Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaIYHtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:49:53 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50188 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaIYHtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:49:51 -0400
Date: Thu, 25 Sep 2014 09:49:48 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Nikolaus Voss <n.voss@weinmann-emt.de>
Cc: Bo Shen <voice.shen@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: atmel-pwm: fix calculation of prescale value
Message-ID: <20140925074947.GA11843@ulmo>
References: <20140924055851.CE51140656@mail.steuer-voss.de>
 <20140925065229.GD12423@ulmo>
 <alpine.DEB.2.10.1409250934090.38376@fox.voss.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409250934090.38376@fox.voss.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2014 at 09:47:34AM +0200, Nikolaus Voss wrote:
> On Thu, 25 Sep 2014, Thierry Reding wrote:
[...]
> >>-		}
> >>+		div >>=3D 1;
> >>+		++pres;
> >
> >Unless you really need the prefix increment behaviour (you don't in this
> >case) I prefer using the postfix operator because it is slightly more
> >idiomatic.
>=20
> ok (as I mostly do C++ programming, I prefer the prefix as it is usually
> more efficient for user-defined types).

It is? That's intriguing...

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUI8kbAAoJEN0jrNd/PrOhMXcP/2QY/HxsceuEO2SgpfK2q7re
DhV/p3bi8zamhQnY8LrUHqbv7cWUZ2rZlCkwyMUgn9FabWXZaWNRFczTlrmVj6kH
2/iNialrQVPEeqTUSdjbEWzw7ZSMpHUch2pI0PBlVRfJBIC+RT9WWyV/U4r/qX8t
/rmWQmkqc1Fs97/c3j0n3Sczhc/XCBjrBmFx4Wys+lVKqA/QuDlNMhtx0KS0zazy
ydqTblUB7osShpAUli8sF5phiCn1lLYw/dKhYLOjeKxh83K0QkLiTXlamskjjxmn
mlSwLtvxICOjp7GHg8FRTBuBRZBaByM7bX5MfG8K8qpBghwx/744Dx6ba6cfv80G
wGi+Rv1Jl4tw+hMx4RaIgFrmhh3KZDsAanpYyRzFaBUn7ZALCeizKiKXZr3eeRFn
9AzXwAYM/HpEe+N39IN/EyPRhw5YYqGv6WzRXqisuLY4xNrwDB0latfuXp5d76GT
1JhhwKsKIW0EdmTpLXRddh5WfDSJN1dz/9R0EUSbP0XHfrbZY2YdRv9kpEO6ydE+
Lw8HZZ4ekVvyAYZ2Z3f54QyIGGFMJ3MQCzb4H7BCRILV4TQR4YeFYKx8xs6Tjb/R
POlBDd1Bp1GLI6Xgf8/8qyc8jT8kdcE//3op7LiRn4NF+BxaoShaVlxr6xESYBZp
W87fikyMUedf4nxgDNY3
=CdmC
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
