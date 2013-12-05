Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3LEOuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:50:03 -0500
Received: from mail.kernelconcepts.de ([212.60.202.196]:34858 "EHLO
	mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3LEOt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:49:59 -0500
X-Greylist: delayed 2800 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 09:49:59 EST
Message-ID: <52A08795.3010809@kernelconcepts.de>
Date: Thu, 05 Dec 2013 15:03:01 +0100
From: Nils Faerber <nils.faerber@kernelconcepts.de>
Organization: kernel concepts GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        =?UTF-8?B?0JjQstCw0LnQu9C+IA==?=
	 =?UTF-8?B?0JTQuNC80LjRgtGA0L7Qsg==?= <freemangordon@abv.bg>,
        Pavel Machek <pavel@ucw.cz>, aaro.koskinen@iki.fi
Subject: Re: [PATCH] media: Add BCM2048 radio driver
References: <1381847218-8408-1-git-send-email-pali.rohar@gmail.com> <201312022151.07599@pali> <52A030BE.7040709@xs4all.nl> <201312051420.56852@pali> <20131205135705.GA3969@earth.universe>
In-Reply-To: <20131205135705.GA3969@earth.universe>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="x1fdQqOBHN9aK9MPn22bu4c2GblVcxiHl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x1fdQqOBHN9aK9MPn22bu4c2GblVcxiHl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 05.12.2013 14:57, schrieb Sebastian Reichel:
> On Thu, Dec 05, 2013 at 02:20:56PM +0100, Pali Roh=C3=A1r wrote:
>>> Anyway, I've posted the pull request. Please note, if you want
>>> to avoid having this driver be removed again in the future,
>>> then you (or someone else) should work on addressing the
>>> issues in the TODO file I added.
>>
>> Ok. CCing other people who works with n900 kernel.
>=20
> Does the bcm2048's radio part work without the bluetooth driver?

At least I do not know.
I just added the RDS data interface, I have no idea of about the
hardware and the other parts of it, sorry.

> -- Sebastian
Cheers
  nils

--=20
kernel concepts GmbH       Tel: +49-271-771091-12
Sieghuetter Hauptweg 48
D-57072 Siegen             Mob: +49-176-21024535
http://www.kernelconcepts.de


--x1fdQqOBHN9aK9MPn22bu4c2GblVcxiHl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlKgh5UACgkQJXeIURG1qHiMQACcDhooAQilsBFxHQaxTdq9/KJs
jzQAn0HKW+OllXU44DT7W73cWYWUHw9f
=R6Hj
-----END PGP SIGNATURE-----

--x1fdQqOBHN9aK9MPn22bu4c2GblVcxiHl--
