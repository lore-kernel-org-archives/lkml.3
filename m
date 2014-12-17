Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaLQXTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:19:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaLQXTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:19:17 -0500
Date: Thu, 18 Dec 2014 10:19:06 +1100
From: NeilBrown <neilb@suse.de>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:md: Remove no longer needed fixme comment in
 raid5.c
Message-ID: <20141218101906.55b7772d@notabene.brown>
In-Reply-To: <1418831373-18415-1-git-send-email-xerofoify@gmail.com>
References: <1418831373-18415-1-git-send-email-xerofoify@gmail.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8N088tSaDk7hWDWj1k5nRVO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8N088tSaDk7hWDWj1k5nRVO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Dec 2014 10:49:33 -0500 Nicholas Krause <xerofoify@gmail.com>
wrote:

> Removes the no longer needed fix me comment related to not needing the ag=
rument faster for the function,
> sync_request. Due to getting warnings when building without the agrument =
it seems that this fix me was
> wrong and we must keep this agrument in order to avoid build warnings whe=
n building without it.
>=20
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/md/raid5.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c1b0d52..c0fde2a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4986,7 +4986,6 @@ ret:
>  	return reshape_sectors;
>  }
> =20
> -/* FIXME go_faster isn't used */
>  static inline sector_t sync_request(struct mddev *mddev, sector_t sector=
_nr, int *skipped, int go_faster)
>  {
>  	struct r5conf *conf =3D mddev->private;


Why do you think the comment is no longer needed.  Is "go_faster" being used
now?  Is there a clear explanation somewhere of why "go_faster" should not =
be
used?

NeilBrown

--Sig_/8N088tSaDk7hWDWj1k5nRVO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVJIPajnsnt1WYoG5AQIzOw//ZXuXWuCNFtt6bfbNMmeS7+/SENzOcDdt
4IWNIRJv+i29K0c2telwAOeE0a2LDftgEWUnNJs2l7Sg49q5ucMo02415ViIXqbK
oWOsYvvXGeZYqMR65EQ3gZbXo5Uh1ZrgB5+rQTffCBwYBqMaYKvQ9qKS6JGqNdXK
kYiBIvVeUr2ucXvWicavEVkR47Vi+oUxO4t/iYKOCbDkScmSMpazviiOIaclFk6o
k2Y7e+PipXVOWdcLF/qdMMIpFPZhR6lvADasYm/8OeMXBzZEKU4qVaarIDiLpw3z
Tlc9G0b3nNgbzNuxE+Y3FmnhQpPwTQklQ4QmckbuQXi7Q8tAwxRuW9Kx37bh6BSJ
ZU8+D6VZgbVJXyc9gdwA5zJvfqoyZU/rpC+6w1OJb5AN/oo2ILJfBVGB86XgWC8k
fQwbgfhX4+NHW9/yo0InGvOMDjnBPcOVEjYnimJC8iieGkB1DgS4cqTY4xduAxnk
+YlFAse7eN6hsF/6Pfmx0YB4ETrBYcYaCrhtOW7vqt/0bGmCYGGPi7f24K2meUp6
wgU7eXU322bQwSBtYoS1N5ZGEFcDRC/TkJpJbvxP/tpX6uxpnfmJgFjBnsi1QYdo
JHfXjhnqrGooFtLWKp6oASc70GZnVEh3RS1Yd2//cb3erEBM73CllZ+M2+hTJZDR
8Om/HFo0Mpc=
=w4pT
-----END PGP SIGNATURE-----

--Sig_/8N088tSaDk7hWDWj1k5nRVO--
