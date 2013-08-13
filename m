Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab3HMKLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:11:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56392 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab3HMKLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:11:38 -0400
Date: Tue, 13 Aug 2013 11:11:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Eric Miao <eric.y.miao@gmail.com>, robert.jarzmik@free.fr,
        kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130813101123.GP6427@sirena.org.uk>
References: <1376340564-7975-1-git-send-email-Julia.Lawall@lip6.fr>
 <20130812214050.GI6427@sirena.org.uk>
 <alpine.DEB.2.02.1308130652080.1997@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oA7V6t2EmJH400al"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308130652080.1997@localhost6.localdomain6>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/16 v2] sound/soc/pxa/mioa701_wm9713.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oA7V6t2EmJH400al
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 06:52:56AM +0200, Julia Lawall wrote:
> On Mon, 12 Aug 2013, Mark Brown wrote:

> > What is the difference between this and the patch I applied the other
> > day?

> Sorry, it should have also removed the local definition of ARRAY_AND_SIZE=
? =20
> I thought that was in the commit message.

It was, sorry - to be hoenst I didn't read beyond the first paragraph
since I'd already applied the patch.  If a patch has been applied you
should really send incremental updates rather than resending the patch.

--oA7V6t2EmJH400al
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCgZHAAoJELSic+t+oim9cTQP/jCxprT9aMttrviAYQSAkiPc
s3zDcmhYAormPLohaRpjD8PX19cpnEGX+760Ot+ymU6cSIpMCy/deXhpiZ679LE2
ikNUd0nd6ek8fBxqtLQTbQ7LSLUf5Sn+sIBT4Nerz5ha0W9qWfqWdSx2K73mck7p
0jWCff+RMXPjC43ISJ58JZpRZWlPU6ZygxaK7+JF2ewqCar2deYcvc5/A+RGu2eh
oi0ED3Y6EgE9woS693KyFVkR6DhrVgPs1n5g9NelFCE7AXeX0MbFoXzmIObybcUI
p/IsUw1AdqySElgz4anWP/FpIOfxcOvg7qZY2WdYLABx7I6nY2WMtQrjwWMIAqLL
b2D4IBASUU67+4a/jMSZ3/I37/ozMLAFOwKFqdYD6J1ZBPC8MDylKI3LmZ3I0W+A
nF0M2F7QlP8UbzUf08gi4xNRRilole6AVTlpH+33+INSO+5Yvx8I+YRbq2MA0U9r
SKnlTGAzmPYb4L9zvOkZfXsIHpYhf/etiaNFpqOjyQsan8477LYORel1augjRek5
yx1csEwWALR4h5zVtkyEBOAuwaysKSTXT3n1TpwB1nLgNx34KRE6rvtfeiKy45uY
1Kk4tgwPJW2tJOaC6/VUZuyiyo2Fw4DzeyJwYx5tTei2JCVRlv2T/v26zRXBTlT8
VrSCy6p0IFxIKsrTYwsW
=DhoH
-----END PGP SIGNATURE-----

--oA7V6t2EmJH400al--
