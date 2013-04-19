Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3DSH4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:56:24 -0400
Received: from diserzione.investici.org ([82.221.99.153]:60971 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab3DSH4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:56:22 -0400
X-Greylist: delayed 1244 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Apr 2013 03:56:22 EDT
X-DKIM: Sendmail DKIM Filter v2.8.2 diserzione.investici.org 81C75180B1B
Date: Fri, 19 Apr 2013 09:34:09 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin =?utf-8?Q?Hundeb=C3=B8ll?= <martin@hundeboll.net>,
        Marek Lindner <lindner_marek@yahoo.de>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20130419073409.GH20819@ritirata.org>
References: <20130419132127.05ea53adec329ca794d62be7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nYySOmuH/HDX6pKp"
Content-Disposition: inline
In-Reply-To: <20130419132127.05ea53adec329ca794d62be7@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nYySOmuH/HDX6pKp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Fri, Apr 19, 2013 at 01:21:27PM +1000, Stephen Rothwell wrote:
>=20
> Caused by commits 612d2b4fe0a1 ("batman-adv: network coding - save
> overheard and tx packets for decoding") and 2df5278b0267 ("batman-adv:
> network coding - receive coded packets and decode them") from the
> net-next tree interacting with commit fe8a93b95145 ("batman-adv: make
> is_my_mac() check for the current mesh only") from the net tree.
>=20
> I added the following merge fix patch and can carry it as necessary:


thank you very much for taking care of this.
However, as I wrote to David in the pull request which generated this noise
(http://patchwork.ozlabs.org/patch/237363/), I am now going to send a second
pull request which fixes this problem properly and adds the related kernel =
doc.

Your patch looks good, but I'd prefer to send my already prepared pull requ=
est.

Is it ok with you?

Cheers,




--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--nYySOmuH/HDX6pKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRcPNxAAoJEADl0hg6qKeOimIP/1OQBmOUOAtmC2ysu94YCdNk
pBuo+0D7b7UtbdsIfYVQoj3EienZBWKB7DTPbWW3dV91/zWt7jG3YJuseVFqSDzs
XYehdFZ1xXkz1VBSj/EBmQcNeyEHRQm2UDYcYvkQxaGIH6lOQ1ChFusyBD+UMQ8q
Ke4N/fsAHbnsHdhv/qrtxg7qom7ZUxiKvXfyzeW/6l5Lc5x6dtYhU7/8mP/wzaKx
iiastd8h5NHhnxGrBQl26SzKiyryS9xInINQWU+ZBeNddnqGo5AHjuACxbpt5z1A
jn8eyGTzL5GyG+ylBKwMoCJPmuzvQ5b6CUIKrY5iFY2iz4h96Ja7srQIdBjeHNYH
o99KAQrFF7pNN9FF0nFMnz3ngA7rh8cHYndgVBANZWyQl0mWCMmbIfnR2w2YSfQG
tGI1I1WujcHs670DQZsIMadg8EWCIASQNfu17efH2QogHqikjjw3MPKeiTkr+JZM
kwYSHvntfK0aY6AkLzUsUlWWMC57EVdHoSgr/RWoRtc6TNcV8C+z4rqfiHdycA27
5G38FdED2KBILvbUSfneE8Za4XSc9gDCVq0D2d3rzhnGDyrvJ6B5q0C7+DH8FTI5
GCJBfzbcOmn/zyw+UHfHQiV/ucF2Msd8/uWVuDjKeHKbm5emHKVeDGns7iAgYe3x
GSRNU2fPoGviSa9pUts7
=GfXY
-----END PGP SIGNATURE-----

--nYySOmuH/HDX6pKp--
