Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaJJSEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:04:07 -0400
Received: from sauhun.de ([89.238.76.85]:49361 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaJJSED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:04:03 -0400
Date: Fri, 10 Oct 2014 20:04:35 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, cocci@systeme.lip6.fr,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Cocci] [RFC] drop owner assignment from platform_drivers
Message-ID: <20141010180429.GA6075@katana>
References: <20141010072439.GA1741@katana>
 <alpine.DEB.2.10.1410100951250.2402@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410100951250.2402@hadrien>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> The semantic patch looks fine.

Wow, nothing to improve on the semantic patch? Now I am proud :) Thanks
Julia for your support, as always!

> If you think that it would be useful to have this in the Linux kernel, so
> people don't add the owner initializer back in the future, you can try
>=20
> coccinelle/tools/sgen/sgen

Will try later this weekend, thanks!


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOB+sAAoJEBQN5MwUoCm2fT8P/AiaifinQjgJ7WqD0QgD1RnT
OM0ncVgkXxtUflnrKU3qVHaCaHM3zHc/+2ok264TlzYUl8GLnZRbAP5oHst/3rTB
8Tei8xuuZb8jXiWamZQ39RUpa7TtCxF86OPmhuoJNGU5xqnzZJJRZ3D7W6za6U1a
9dbb+GwMWDI8t2Gqo0wPCiJcOTod3XognVplAVYNk8JaK/3jd5w098DJO3Tgxm1a
sVi9+aRuFk2wg7x+7IIpkY09OF0AXX6nOph3XEIHxvahTUnpGDqOcL3yijcwWQhy
sQdQSdIWXCHtmw//dHGAolktiw1Hxk7W47zyoI00IQQMbLUux6U/q+A1zHUfA0pF
8soVwWYOwrgwRViGpyuGsDiQhQ0is9Nv+SCQuZNCV1IR5PCinairG76lMN5HVeoX
x4oAZCp//3hBiHaaoqwueBSgDH/vYv/hKqPyFsxjfdRo/Eg783b0jXqyf+F6MXEV
RtumwPUrro1aOgJxCtdTqltxBFGnB6uMlQLmb9i+KBL83/m2LFc3UE9tpBiGlyF9
Aw491T4y0g7g0i/bE/jfhJ9ahlJRsQdj823foUwOmaVjL4nFkZs7khYpMrTyqL8o
VgZ1MDxasEoDkt1BoWnEQExbBvZRmfAhlqPVSmzk74/+jHDzvylOp2vniQCLgeBW
BmKJWoI6bQkcjYuCcWcz
=r1Ih
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
