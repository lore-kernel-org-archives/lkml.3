Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3C3WvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 18:51:13 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:41906 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3C3WvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 18:51:12 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Date: Sat, 30 Mar 2013 23:51:05 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
References: <19040462.WFXWijAIDd@pali> <20130330183526.GA21198@lizard> <20130330214229.GA4322@amd.pavel.ucw.cz>
In-Reply-To: <20130330214229.GA4322@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9163613.goIJd1fXvr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303302351.06611@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9163613.goIJd1fXvr
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 30 March 2013 22:42:29 Pavel Machek wrote:
> On Sat 2013-03-30 11:35:26, Anton Vorontsov wrote:
> > On Sat, Mar 30, 2013 at 07:07:05PM +0100, Pavel Machek wrote:
> > > On Wed 2012-10-31 10:48:40, Pali Roh=C3=A1r wrote:
> > > > Hello, I fixed style issues and added it to Makefile and
> > > > Kconfig.
> > > >=20
> > > > power_supply: Add Nokia RX-51 battery driver
> > > >=20
> > > > This driver exporting battery design capacity,
> > > > temperature and voltage for battery in Nokia RX-51.
> > > > This driver is needed for open source battery
> > > > management on Nokia RX-51 (N900).
> > > >=20
> > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > >=20
> > > Reviewed-by: Pavel Machek <pavel@ucw.cz>
> >=20
> > Thanks for the review, Pavel! Although, the patch is in
> > Linus' tree long ago. ;-)
>=20
> Yeah... I did a bit of history-digging ;-). Now, I should
> figure out how to put custom kernel on n900 _and_ keep it in
> working state at the same time.
>=20
> (I installed some kind of multiboot, then, apt decided to
> install some u-boot extension. Then it got interesting. I
> never got my own kernel to work, and u-boot magically
> disappeared, but I still have working phone :-).
>=20
> 									Pavel

Hello Pavel,

here are some hints for booting 3.8+ kernel on n900:

"multiboot" package from Maemo Extras is horrible hack which can=20
be used only for booting maemo 2.6.28 kernel. it flashing new=20
kernel to n900 nand, then reboot device, start maemo init and=20
mount/chroot into new os dir... after reboot it erasing kernel=20
nand area where is normaly uboot placed, so do not install it!

uboot in Maemo Extras cannot boot 3.x kernels because autobuilder=20
(Extras server app for buidling packages) has very old gcc which=20
produced semi-(non)working uboot (can boot some 2.6 kernels).

my uboot builds compiled by gcc 4.7 (which can boot 3.8 kernel):=20
http://atrey.karlin.mff.cuni.cz/~pali/u-boot/

info thread about uboot on n900:
http://talk.maemo.org/showthread.php?t=3D81613

kernel git repository with n900 patches (now based on v3.8-rc3):
https://gitorious.org/linux-n900/linux-n900

open source flasher 0xFFFF (working on x86-64 too) which can load=20
kernel and initfs via usb to n900 RAM without flashing nand:
https://gitorious.org/0xffff/0xffff

rescueOS - minimalistic n900 initrams distribution with usb mass=20
storage (eMMC and SD) and usb cdc ether for telnet console
http://206.253.166.96/N900/rescueOS/

If you need help with booting some upstream kernel on n900 join=20
to freenode #maemo-alternatives channel :-)

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart9163613.goIJd1fXvr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFXbFoACgkQi/DJPQPkQ1KCfQCdHaHVcqe8Opu0hs5Kht3Hmxzk
/hcAnjl3KJXtkYzUPZDaUgSz1qEZ9WxZ
=kSmo
-----END PGP SIGNATURE-----

--nextPart9163613.goIJd1fXvr--
