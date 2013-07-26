Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab3GZAgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:36:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502Ab3GZAgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:36:04 -0400
Date: Fri, 26 Jul 2013 10:35:49 +1000
From: NeilBrown <neilb@suse.de>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
Subject: Re: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x
 SSD)
Message-ID: <20130726103549.1e6b0b92@notabene.brown>
In-Reply-To: <009801ce898c$34b83fc0$9e28bf40$@lucidpixels.com>
References: <000501ce85fc$d3a60a10$7af21e30$@lucidpixels.com>
	<20130722090257.2faa0874@notabene.brown>
	<009801ce898c$34b83fc0$9e28bf40$@lucidpixels.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/byXCCVTfDFfjBjDaqQ+vmLC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/byXCCVTfDFfjBjDaqQ+vmLC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jul 2013 19:10:50 -0400 "Justin Piszcz" <jpiszcz@lucidpixels.com>
wrote:

>=20
>=20
> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]=20
> Sent: Sunday, July 21, 2013 7:03 PM
> To: Justin Piszcz
> Cc: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org
> Subject: Re: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x
> SSD)
>=20
> > Hi Justin,
> >  this is a known bug.  Fix has been accepted into mainline for 3.11-rc2.
> >  Hopefully it will get into 3.10.3 (too late for 3.10.2).
>=20
> > NeilBrown
>=20
>=20
> Hi Neil,
>=20
> Did the fix by chance make it into 3.10.3?

No, it looks like it missed again.  I gather there was a large inflow of
patches for -stable in the 3.11-rc1 merge window and Greg has been processi=
ng
them in batches.  Hopefully in 3.10.4.

The relevant patch is commit 30bc9b53878a9921b02e3 in mainline.

NeilBrown



>=20
> The same issue occurs with 3.10.3 for me as well:
>=20
> Every 1.0s: cat /proc/mdstat                            Thu Jul 25 19:09:=
46
> 2013
>=20
> Personalities : [raid1]
> md1 : active raid1 sdc2[0] sdb2[1]
>       233381376 blocks [2/2] [UU]
>       [>....................]  resync =3D  0.0% (151488/233381376)
> finish=3D32045.3m
> in speed=3D121K/sec
>=20
> md0 : active raid1 sdc1[0] sdb1[1]
>       1048512 blocks [2/2] [UU]
>=20
> unused devices: <none>
>=20
>=20
>=20
> Justin.


--Sig_/byXCCVTfDFfjBjDaqQ+vmLC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfHEZTnsnt1WYoG5AQI+KxAAtvfmsjEd5bUn2qiAywJxNiwG0gFpbj7i
dT/RcsTYkMo+DikBVM8GLzTJbttxAXYoQhSPOKn4G3SaeevYqvRSecpOELlh6d+M
bImNTDFVuTxHUQh8qhDmpzTd7/cw4WyD6l6tmkf08WrZ1gXOgAiaVpaNajjbTkhc
QSkcJU5FAunIup3iwYUrHkPFj/5mSq+n5FHUV11B6Yn7+mxa7CqD+6phByDG/ksS
VWAcKl3ahc9Q4hnT7odUGu7e69sHBShMYHRUX4imGDL8nH96PJGznOdo58a9mSdU
7hM0LrVvv0nCVpUe8f+sMKhzFxtSm7tBZD7AHQOIz8ZwaVqfgUhOHhww7PeM1aGN
IdHODvqaxuqq/xDkOlg22IMosU4+9lsvcs+aOew38KYepz+pwdS9bDVTngCQdn7I
u7vrBQj30VycEGKZGquT8eQAUYcCoixPGYh8jL7yRX3dMa5OAzp6SIqXG7320Ws4
XIYyGiUwo1OUuUMSKxQMf54lh6ygOF1Hw63rFM1H1MuoXXIx7evjYP8ffJwaTpvh
ImxwyD2pVlAUEZW+vhw6ld/2JktR5EGJYCg3cH6PuD2gLEqX2qQENGKmAdinB8ww
aFW/N749Tk24UMe0x4WHlqXNxcYKB4M7GaiHpTlppwxm8rgB80pbTvjjf81CPEQO
6M5/mXJZ4kQ=
=J/Qj
-----END PGP SIGNATURE-----

--Sig_/byXCCVTfDFfjBjDaqQ+vmLC--
