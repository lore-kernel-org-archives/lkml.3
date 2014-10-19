Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaJSVA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 17:00:27 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38439 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaJSVAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 17:00:24 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: USB Ethernet gadget on Nokia n900
Date: Sun, 19 Oct 2014 23:00:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: sre@debian.org, sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
References: <20141019090107.GA19132@amd> <201410191658.45851@pali> <20141019205033.GA4738@amd>
In-Reply-To: <20141019205033.GA4738@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2279378.N2pT41Piqy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410192300.20625@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2279378.N2pT41Piqy
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 19 October 2014 22:50:36 Pavel Machek wrote:
> On Sun 2014-10-19 16:58:45, Pali Roh=C3=A1r wrote:
> > On Sunday 19 October 2014 12:07:39 Pavel Machek wrote:
> > > On Sun 2014-10-19 11:01:07, Pavel Machek wrote:
> > > > Hi!
> > > >=20
> > > > From 3.6 to 3.10, USB networking works on Nokia N900.
> > > > With 3.11, it fails with messages on the host. I also
> > > > tried to get it to work on 3.14 and 3.17, with no luck.
> > > >=20
> > > > Any ideas? Does it work for you? Any config options to
> > > > watch for?
> > >=20
> > > With 3.17, I get
> > >=20
> > > omap_musb_mailbox: musb core is not yet ready
> > >=20
> > > message. It looks related...?
> >=20
> > Can you try tree
> > https://gitorious.org/linux-n900/linux-n900/ ?
> >=20
> > I think with rx51_defconfig from above tree it worked fine
> > for 3.10 - 3.13 versions.
>=20
> From your tree, I am trying
> 815039686baffff6432b45028dd405b1981a9112 (3.16 based). I
> attempted to make gadget drivers build-in and enabled
> nfsroot. I could not detect nokia on USB after bootup.
>=20
> Are you sure about defconfig? AFAICT defconfig will always be
> unsuitable for nfsroot, as it will not contain nfs support
> built-in...
>=20
> I am trying c089e5f8ba2d44afd2db2c2042d43ca70205c536 (3.13
> based). Same result :-(.
>=20
> Do you have any tree where usb gadget works for you?
>=20
> Thanks,
> 									Pavel

My N900 can boot kernel from v3.12-rc5-n900 branch compiled with=20
arch/arm/configs/rx51_defconfig. Also it can boot full Maemo5=20
system (with CSSU and some minor system changes) and usb network=20
via g_nokia.ko gadget working fine...

So if it does not working for you then kernel usb subsystem could=20
have problems with using gadgets directly from zimage.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2279378.N2pT41Piqy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlREJmQACgkQi/DJPQPkQ1K7AQCfY3cT6Uznh5eIx+8Tc0kpDMXp
jkIAoKoLhdiOsZF6DjDMNAfZRuCN/Zhh
=EB8t
-----END PGP SIGNATURE-----

--nextPart2279378.N2pT41Piqy--
