Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3I0Qct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:32:49 -0400
Received: from sauhun.de ([89.238.76.85]:47004 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab3I0Qcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:32:47 -0400
Date: Fri, 27 Sep 2013 18:32:42 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH] misc: (at24) move header to linux/platform_data/
Message-ID: <20130927163242.GB3094@katana>
References: <169123028.921974.1377290733515.JavaMail.root@mail>
 <1414767040.1054326.1380226152008.JavaMail.root@mail>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <1414767040.1054326.1380226152008.JavaMail.root@mail>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2013 at 04:09:12PM -0400, Vivien Didelot wrote:
> Hi Wolfram,
>=20
> > Wolfram wrote:
> >=20
> > > > IMHO it makes sense. Why wouldn't we want all platform_data in
> > > > include/linux/platform_data/?
> > >=20
> > > For the same reason we don't want all driver source files in one
> > > directory? It's a mess.
> >=20
> > Well, that's different. Not all drivers expose platform data, but
> > many subsystems have drivers with platform data. A common include
> > directory for the *_platform_data structure definitions makes sense.
>=20
> Also IMO having such header file in include/linux/i2c/ for a driver
> declared in drivers/misc/eeprom/ is not very consistent.
> So this is the purpose of this include directory. What do you think?

Well, yes, I will apply it if you could rebase it onto v3.12-rc2. I am
unsure about the platform_data dir in general, though. For example, I'd
prefer to have the i2c-* files in the i2c-dir, but this is another
question.

Thanks,

   Wolfram


--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSRbMqAAoJEBQN5MwUoCm2moAP/RGKnijixsOQcvVnXc/JfH6h
XZzn98hoRxTKAPeGzN7bXqdvtWMjgsIhHo0QSk/EtTKlXmXWKKEIJeH3/8Ukdksc
+f9yC09sjZLmkf1q3XsjfX9Sy92DqYF8Q7jtDRk0lSWLJjR5JYlbZRobQNRlXGUF
XLI9BzIj1709vnwyIw8u2HexnsXdzuv6fHlbqsr8Q+hwAVv8VLxRpQ4oXdUhayI/
yo3avlK4PBBsCYYyb7MGztxJu2f4IMM0NjugKhCrQbaEtoUBt+t/MuESGQvHxJOV
GiXM5N93iqC8uDVuQ2ToCrVnF5YJnTQO6x6y8qqccqHbpLPW8z2zG8B/YdCNYS2t
tmFw86slTnQGuVumvz7RA7bbXZwaQHwTArYAjYIKDo1eVp4N33Mg0C8inWE98RHF
Un0W9EYMwuMLBSb4BTzvBr5jW/jeZe1QXsYabty5IFBdd680TOxVNMvv2rWIl0tL
xctXoaM9ZT/FeRDW9C8QWPATOhYk/uhx1WzHjTXvEOwpOPAwAkDC5my3xguK1uFA
MJXncYysSSlA8g8sH6/0oLb4GurW1ywFq94y9OkrjLDDpJxtQzdB3TqPOvrVAmzM
qy47t2/5bYTAorqj+U5WEXiLEVqI6UFSn+jqS54C3QzFR/M3tQjZPslpXNoYilDc
Cre+bI8LStPv7By6uZYu
=DxcC
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
