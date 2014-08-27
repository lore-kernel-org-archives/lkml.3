Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906AbaH0Tas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:30:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60007 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935182AbaH0Taq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:30:46 -0400
Date: Wed, 27 Aug 2014 14:30:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Michal Sojka <sojka@merica.cz>, <linux-usb@vger.kernel.org>,
        Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v3 2/2] usb: Add LED triggers for USB activity
Message-ID: <20140827193028.GK6347@saruman.home>
Reply-To: <balbi@ti.com>
References: <CAK5ve-Jz7=7uZ3_Qg2bAH9BiGRZ36k-Oj9TNZ-_nAvaq6LGbjA@mail.gmail.com>
 <1409144625-25274-1-git-send-email-sojka@merica.cz>
 <1409144625-25274-3-git-send-email-sojka@merica.cz>
 <20140827192751.GC9620@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vbzKE9fGfpHIBC6T"
Content-Disposition: inline
In-Reply-To: <20140827192751.GC9620@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vbzKE9fGfpHIBC6T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2014 at 12:27:51PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Aug 27, 2014 at 03:03:45PM +0200, Michal Sojka wrote:
> > With this patch, USB activity can be signaled by blinking a LED. There
> > are two triggers, one for activity on USB host and one for USB gadget.
> >=20
> > Both trigger should work with all host/device controllers. Tested only
> > with musb.
> >=20
> > Signed-off-by: Michal Sojka <sojka@merica.cz>
> > ---
> >  drivers/usb/Kconfig                           | 11 ++++++
> >  drivers/usb/common/Makefile                   |  5 ++-
> >  drivers/usb/common/{usb-common.c =3D> common.c} |  0
>=20
> I don't mind renaming files, but don't "hide" it in this patch, do it in
> a separate patch please, and then base your next patch on this one.

+1

yeah, this prevents us from reviewing the actual changes

--=20
balbi

--vbzKE9fGfpHIBC6T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/jHUAAoJEIaOsuA1yqRELvwP/2YWPd4SVfvcirFSpKgJDei4
zvqRKSqVPZjE9TKHsXTbIXIQHpGlfQLaa9aie5GJ8ccHHQoQttygG89aT7g7MVPm
8dAdJ20pnadEU2RFW+q0Kqq7c5mP0FiKq4OyxXetAjLV7QkR4HnCF6AUPtmccu6t
gVzbxXCh++toh/Ia3pO3GWZZQYwQrgLoVPhhI3KwsJ0xNOBLovNNWeDU9cLs79/b
pWT8MQECDqiqzYdSaq5+gTliVFMvP3xYnK5AKLMVwylKRxbqux2qXLmY6Z6bthA7
KFyd+7GkWbzhVIIKIidsCM3cWr9Zz3TKoZS/3Yw1WqN0VxmqcX7drPXlkp+VovEe
k/D8cLQrmiRdK6WnqR+qlfV50KgU4c1UEra1UnNaLLMqKnTmeMzBrrX8OSJjG0Ch
s1+EhtFSPK81vb7pIPMVKS8RjBRLDCnHseJa6/4YsazmcefTYko+rKClfN+oTPC2
P6EkKB2td7WQ96mG7nsfl9PhNs2no6sA0SmOQOcHxHXYg3X0QvmoBlb190ohlIeG
L1zM/Fqg8VbkA2Hs2fWrRZiPC4O3t+UrUoMge0RQkC656Sykw+yekICsn7x1OeQg
v48+B7aklBWxkNNFZ3GOPCn4BaQevle1DYNdkCeG1P9qU1Weou6F/8KHHJ09KLfV
I2DL0JTgzhOnATiVvjB5
=5L0W
-----END PGP SIGNATURE-----

--vbzKE9fGfpHIBC6T--
