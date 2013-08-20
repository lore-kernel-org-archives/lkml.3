Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3HTCqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:46:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3HTCqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:46:51 -0400
Date: Tue, 20 Aug 2013 12:46:39 +1000
From: NeilBrown <neilb@suse.de>
To: Dave Jones <davej@redhat.com>
Cc: linux-raid@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix apparent cut-and-paste error in super_90_validate
Message-ID: <20130820124639.5d75f837@notabene.brown>
In-Reply-To: <20130820022632.GA12899@redhat.com>
References: <20130820022632.GA12899@redhat.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+j+FPggmC36y+LoqKIbPxMs"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+j+FPggmC36y+LoqKIbPxMs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Aug 2013 22:26:32 -0400 Dave Jones <davej@redhat.com> wrote:

> Setting a variable to itself probably wasn't the intention here.

Probably not, no.

Applied, thanks.

NeilBrown


>=20
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9f13e13..b9cb9e4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1180,7 +1180,7 @@ static int super_90_validate(struct mddev *mddev, s=
truct md_rdev *rdev)
>  			mddev->bitmap_info.offset =3D
>  				mddev->bitmap_info.default_offset;
>  			mddev->bitmap_info.space =3D
> -				mddev->bitmap_info.space;
> +				mddev->bitmap_info.default_space;
>  		}
> =20
>  	} else if (mddev->pers =3D=3D NULL) {


--Sig_/+j+FPggmC36y+LoqKIbPxMs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhLYjznsnt1WYoG5AQJRvxAAs2mB7EXf+AbWh/PxnNhj1IjG9tQ1Ctqh
JFej6VlDaUjFByjGqBiBVh9ZAWxXAjDbiTFHNqyBkeEfM2ELmd995F6M+lr8EubL
JDOzRkBw2N48CkPnL3mQ+EPaKfIjMqQRe048rx07Z+Y8xFkupl4nBiVZRHBmzmkz
m0mjEb5YhMXx5dsZxNUuPe/kvjTZ+0WRBs2JT8MvBzG/f125KL3mnCz+9C6Fd4YE
BU2Qg9mu8k8fA8dwr+7QhHSaJooPeCiS/xV/+56Nc6wmjmGETIVZFQL7ImQupEGo
H5t17HifABnjzbnzQTFDfCWUi2rGtNaye3c3MEmj9LRBusMGkxnFDodvY4Ha1n62
Ete4/1+/qcp0/BPzjxfJdGhxaCB0HAWE1i6e/otLBKkMeziD6/z4w1MTpfa5IBC9
ukGvHgg8hd+lfJjeM6Wl7buk5Qwj4mgdNPGKSO2wb7sIDBqXpmLealsjnkB/IYEv
M5vnf1aP/NcI7A5XapyJy9bYodFk4N3cABb4DNAKrP/5PkI/8T2KMIPXx1Of9Nty
ewsk10nsgrArYAF6EOEvE6Gokh/Kw2DQFN1ODJJFTbBTMUiD1rUJjqSQW4IGIWVO
5W2F8dm3gdvhEsbth3F/peBXqYWFzqNsjjkcwmg+dBrhB3VUoyLQSlY/mhJw1g4P
Thr3YA1FF8o=
=yaVy
-----END PGP SIGNATURE-----

--Sig_/+j+FPggmC36y+LoqKIbPxMs--
