Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaKCN7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:59:54 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53397 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750816AbaKCN7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:59:53 -0500
Message-ID: <545789F8.1060401@free-electrons.com>
Date: Mon, 03 Nov 2014 10:58:16 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, Richard Weinberger <richard@nod.at>
CC: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>,
        dedekind1@gmail.com, David Woodhouse <dwmw2@infradead.org>,
        computersforpeace@gmail.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
References: <1414933255-3795-1-git-send-email-richard@nod.at> <CACVXFVP9K6t-u-sjBQ57r_9kzu-yGdLLGYyX2d+ryJBSxMkAJQ@mail.gmail.com>
In-Reply-To: <CACVXFVP9K6t-u-sjBQ57r_9kzu-yGdLLGYyX2d+ryJBSxMkAJQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="apvQTqiwOnmGu06cdmoU2InxUt3hFq4Mk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--apvQTqiwOnmGu06cdmoU2InxUt3hFq4Mk
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/03/2014 02:03 AM, Ming Lei wrote:
> On Sun, Nov 2, 2014 at 9:00 PM, Richard Weinberger <richard@nod.at> wro=
te:
>> Convert the driver to blk-mq.
>=20
> It is always helpful to include some performance comparison data(
> randrw, rw) between blk-mq and non-mq.
>=20

UBI block support is read-only for now so you'll be able to run read
tests only.

Richard: If at all possible, it would be interested to so some
performance tests on *real* devices, not only RAM-based ones.

Thanks for working on this!
--=20
Ezequiel Garc=C3=ADa, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com


--apvQTqiwOnmGu06cdmoU2InxUt3hFq4Mk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUV4n4AAoJEIOKbhOEIHKiO4oQAKvV9tWbZ1rwwELxNwSBhu/L
YaWDjMBP8eD4+O3vZzMmg5Yr+xg2pwWPpsZbquRUElHcQcfcZDN4PvNYJI44hoyK
6lXMnQObwHAccVhbyYLcMJDHH/C+cbmfXSHWApwCp9wKPHfkct2IG7UF9h3nYq6f
IPjyjtH5FgYN628MqsWJVvubEUhsMTmwkLdwHIwO1cGRXT38CoEtD7aLmHGuigKh
1h82DwsxgejZXtnOaXy33Z1H5QtnkJntnheSoUeI4Qj4fA6x+roRgEpaeHXlGvgg
rFjNL06UAZ6c3egbqgabMciPng/1Grdy7FmYJjATC+IefJdsorcsrLhs3RdaLT0r
LcfTiEBCx0dhw4HyGIRg8N1uLsqimXgKJ+/N2IMBpQ3s4iqyYFwHmiTU1IG4rB5j
LghkkhHQqMKnjIAq8l3/IyNLj0h95IHkYunvygHhvkdeGxjUg0W19PFIigOd96K3
8qsd1W3JLA1T3Krz7TFBH/1di0LneqeFjTSZ+Mz3ciXgtAiP6rqx6ocQ4YgtMtX5
BLkbQefOQ30kUlqI34akOk+jPaRS7W0nLHyhYslw7Xb4y/ff7xo1atdUeNUp3HZH
i6ExKwHRbqe4e0tlBgOF1yQWejKdWmfbOGUyP4kKt8hyzVcqvAMSUHQY7/IJbQQx
RJSXSYPBX6DIl4fVR/d3
=ZhFn
-----END PGP SIGNATURE-----

--apvQTqiwOnmGu06cdmoU2InxUt3hFq4Mk--
