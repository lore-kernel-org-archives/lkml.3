Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995AbaH2UkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:40:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36234 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaH2UkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:40:12 -0400
Date: Fri, 29 Aug 2014 15:40:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Shea Levy <shea@shealevy.com>
CC: Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: gadget: Remove use of PWD in Makefiles
Message-ID: <20140829204005.GA16391@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409203846-11007-1-git-send-email-shea@shealevy.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <1409203846-11007-1-git-send-email-shea@shealevy.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2014 at 01:30:46AM -0400, Shea Levy wrote:
> Using PWD breaks out-of-tree builds in certain circumstances [1], and
> other kernel Makefiles use relative paths just fine.
>=20
> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=3D83251
>=20
> Signed-off-by: Shea Levy <shea@shealevy.com>

There is already another version for this patch which is in my
testing/fixes branch

--=20
balbi

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUAOUlAAoJEIaOsuA1yqRE2+kP/3C7zpTFbgDfFfKdVbhu8XVS
wOWZBaWVM7FmOIcZDU7Y3NzqSrnvGNvK3n2AscJKCqftyNik7AOheLeqnn4jpzlR
pgvQ7rOAH3g34Iw/axjLOo3kizxQ9Ejeh+/144aoTKbnjzottYwNcjv2X/TNHaPv
KsNzWZU+hChEhriTeTgrcD+kRkWz/TH2VagGrXLay8cXoJNJ98vtt9nn4vfE3tEu
K5hz6DhuR8o1weQZO4UWMQ268yeL8ROYCnlubFslSORwsVPtTw2AVWM9X/OM8gS7
5Ey7tWUdjOEQZTiEyavS54ZyLqwQ8c5svL5ygTEXb+pOu2Jjq3wqm0fyFNJxxo2f
MuQrFLdZtWwvhKQFh0kms8v4sERJ0FfKJZFLjVb2B8Wv2vhTLcU7AFRP2K4iIhEQ
35ya/zqGK+LilWMIlFgaxiysLNBIGYPzF9+8a/Qortf13xjAVnTz3IpwogVcTmSP
4CXKtEy72F4/Gn7Q3GXuEpgdQsb9SspyWsyAbSVp1G7EYUUoCYFLntBkGJSpqHOX
wpEmtifrZ+R761z0PGRv7CeVuJ+Fu+jVqCnMG0LCegnJmEzx0r97Mh+VigpLbTu+
d68Q7rEJBqv4r3HPrO2MPQZl3oIYEPhiRccDOkv8XNDxuFehw4AEAJHKzTHxI8/2
g/9v7WD9BYKexX6+t3+/
=KkRf
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
