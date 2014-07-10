Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaGJVsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:48:16 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:43334 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaGJVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:48:13 -0400
X-Originating-IP: 81.184.215.10
From: Leopold Palomo-Avellaneda <leo@alaxarxa.net>
To: linux-parport@lists.infradead.org
Cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Greg KH <gregkh@linuxfoundation.org>,
        Heiko Andreas Sommer <hsommer@eso.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-parport] [PATCHv3 2/2] Add force_epp module option for parport_pc.
Date: Thu, 10 Jul 2014 23:48:01 +0200
Message-ID: <20385712.vl9ZPHu7Ll@indiana>
User-Agent: KMail/4.12.4 (Linux/3.14-1-amd64; KDE/4.13.1; x86_64; ; )
In-Reply-To: <CAJs94Eao-ujjZevjptf5hhmkS742HdUVafP4avHR3gx0WzuSTw@mail.gmail.com>
References: <alpine.LRH.2.00.1407071101060.3492@lnfm1.sai.msu.ru> <20140710170954.GB23544@kroah.com> <CAJs94Eao-ujjZevjptf5hhmkS742HdUVafP4avHR3gx0WzuSTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4918546.uMSOVz3Bgf"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4918546.uMSOVz3Bgf
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi,

this thread has been very interesting. I feel that I'm one of the=20
"instigators" to solve this f... bug in the kernel. But, it seems that =
it's=20
quiet difficult, more because the kernel developers than the bug itself=
.=20

But well, to be honest, the kernel developers do a great and complex jo=
b, so=20
probably they have good reasons to react in that way. Think that it's t=
he=20
second time that a patch to solve this bug is rejected.

Thanks Matwey for the patch and the afford to solve this bug. I have se=
veral=20
boxes in the lab where I work (Dell 745) that suffer that false positiv=
es.

Also, there's some pci card that also suffer that. I think that we have=
 one.=20
But, I'm not sure.

So, I can check whatever could be necessary.

Best regards,

Leopold




=2D-=20
=2D-
Linux User 152692     PGP: 05F4A7A949A2D9AA
Catalonia
=2D------------------------------------
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--nextPart4918546.uMSOVz3Bgf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJTvwoWAAoJEAX0p6lJotmqzYAP/2Vz8LATcFqUXYvdpadCxFaL
LXSUYYE2nXZFW/Wo2SDPnCdDBE0drDFhB9ydyZLvttQaqPKscNwuoraGMb+Vpc1s
IO3J5XJhWiK6dfutR2bl02TKA0NmB2ZIjm0M5/C7KJ5gQdkBHbWsuMJmkvFLNK4z
p+PIS6j2k/MoK5BElq0eltqy9sqZbmvTro/BDyhxLzKRKleCV6Nwa076cQl+HNhR
enrWPnCl+u8UvE6CCU343g4bFX589Lk8LfH5TcAKHNbRKSohaUkr7OhBoXlzWyVO
lajI6ihJDn6il7bZ11upbIpLjLSTQFM5IkaemFAP+es0aJTKWPQeBUd8LUxordZL
H7b6n/sW8oygqqKJT3QZtOvGzDbE+1ljLXt4OmIV4kaPNQgge63WX2YuTOyh8VTH
hK4Gauj5/H0PrB/I5MBXUkaot4UObALYufqP0CeY/XW9r64yQcjsY5PrTz1bNKDr
XNjrxx7zxN8mtU2G9Mfv2yDtve7yrl8bPb3cLyKjy2bgLcKy7BCAcIpx9QnamGxA
rknlH/8KY6RSUBc0hI2wcb2MIkVWMUjQ+hsHJJncj3gHOSvdZ7qjgsdNA1+VY+L+
URfj8tO8UaY/AowfNBGI9CwX7ybPeCMdzJ282Zk9ZfFO6GLvHEZf77a9kq6oqWQx
ZALHiz0o6753NRrmjhYo
=PaCD
-----END PGP SIGNATURE-----

--nextPart4918546.uMSOVz3Bgf--

