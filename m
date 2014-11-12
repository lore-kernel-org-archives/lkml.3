Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaKLJkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:40:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57564 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751408AbaKLJkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:40:05 -0500
Date: Wed, 12 Nov 2014 10:39:12 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>, stable@vger.kernel.org
Subject: Re: [PATCH] dmaengine: sun6i: Fix memcpy operation
Message-ID: <20141112093912.GL14919@lukather>
References: <1415730952-1945-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141112092506.GA24582@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vJI8q/aziP9idhqk"
Content-Disposition: inline
In-Reply-To: <20141112092506.GA24582@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vJI8q/aziP9idhqk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 02:55:06PM +0530, Vinod Koul wrote:
> On Tue, Nov 11, 2014 at 07:35:52PM +0100, Maxime Ripard wrote:
> > The prep_memcpy call was not setting any meaningful burst and width bec=
ause it
> > was relying on the dma_slave_config was not set already.
> >=20
> > Rework the needed conversion functions, and hardcode the width and burs=
t to
> > use.
> >
>=20
> Applied, thanks.
>=20
> For memcpy, reying on dma_slave-config wasnt the right idea to start with.
> Memcoy is supposed to work even without that

Yeah, I learned that the "hard" way :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--vJI8q/aziP9idhqk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYyrAAAoJEBx+YmzsjxAg1oAP/jelqHutbRDyg+DRvl0PeFIp
L7ZX3xw/DeF0eHwg5L6AKwvq0f8xwHoVnwhfm8bw3ox7wNLpeEHNYllRQ6myHZZw
vWkPdT9ENRAU00pwJXmZ4v/mraJXgDTv0Qh/K1zYAdLWoW9buDr09ruT9AI+xlXw
a/VsiuMwCtbaez9kQFMg2q6cpVONsMhZx0E1lykl0jrLq4wkV4BXY2Senzh4Tjz4
6CbcfiXhN4//i0/oywDPElictBrZJqkf5dasRJoqp6P46B1bfAwUu1LGcMY9uw/j
lch7LGbjv5wpWi8di17DS812DztOb0/9HlqTLHdI3rFHidfxSyZ81oMeZLyQSgyn
Yh1PUUFle35VT7i7EanRKzOE878oItwoIJ6T68uIRiB70XG/mUooVy3jHNzJno0s
c5RqUUxskDWCgViFLba5cp48gN1R1E598fnNfOz6tXViXMRE1imWYwFQ6gnowbTy
5y2AZB4C7jNZaV+iEvWnvsrKZPqBjNY47yEofPeUQWGwoxPQc2c5EU+G1vXVMAKB
kJcQdhL/UHrI9ELjRzLfjHDQ6wcpHco/U3zFLRc4zBv1W2G+IqSFrB7xSIcspeny
eu7CPkasZrMiG+Y1WKv1H0Fw4T3h4GPldXmAFksFvmxWhD4LNoMY4JrNKQ6ug+ff
/eiGmsfwbKBpVXe3ykbQ
=YFKX
-----END PGP SIGNATURE-----

--vJI8q/aziP9idhqk--
