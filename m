Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021AbaLOUaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:30:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaLOUav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:30:51 -0500
Date: Tue, 16 Dec 2014 07:30:37 +1100
From: NeilBrown <neilb@suse.de>
To: Loic Pefferkorn <loic@loicp.eu>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update CONFIG_DM_CRYPT help-text link
Message-ID: <20141216073037.75ec447b@notabene.brown>
In-Reply-To: <81c1a7329d2146d37b22d7efa96b3a449cb66d14.1418674665.git.loic@loicp.eu>
References: <81c1a7329d2146d37b22d7efa96b3a449cb66d14.1418674665.git.loic@loicp.eu>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/PSNNyqS95fGcNo.RmLegE32"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PSNNyqS95fGcNo.RmLegE32
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Dec 2014 21:23:35 +0100 Loic Pefferkorn <loic@loicp.eu> wrote:

> Hello,
>=20
> This patch fixes the obsolete help-text link of CONFIG_DM_CRYPT.
> Applies against next-20141215.

Please direct this according to:

DEVICE-MAPPER  (LVM)
M:	Alasdair Kergon <agk@redhat.com>
M:	Mike Snitzer <snitzer@redhat.com>
M:	dm-devel@redhat.com
L:	dm-devel@redhat.com
W:	http://sources.redhat.com/dm
Q:	http://patchwork.kernel.org/project/dm-devel/list/
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm=
.git
T:	quilt http://people.redhat.com/agk/patches/linux/editing/
S:	Maintained
F:	Documentation/device-mapper/
F:	drivers/md/dm*
F:	drivers/md/persistent-data/
F:	include/linux/device-mapper.h
F:	include/linux/dm-*.h
F:	include/uapi/linux/dm-*.h

I guess get-maintainer.pl doesn't cope when when on file has separate parts
which are separately maintained.

Thanks,
NeilBrown


>=20
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=3D75111
>=20
> Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
> ---
>  drivers/md/Kconfig | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 5bdedf6..09c89a4b 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -230,9 +230,8 @@ config DM_CRYPT
>  	  transparently encrypts the data on it. You'll need to activate
>  	  the ciphers you're going to use in the cryptoapi configuration.
> =20
> -	  Information on how to use dm-crypt can be found on
> -
> -	  <http://www.saout.de/misc/dm-crypt/>
> +	  For further information on dm-crypt and userspace tools see:
> +	  <http://code.google.com/p/cryptsetup/wiki/DMCrypt>
> =20
>  	  To compile this code as a module, choose M here: the module will
>  	  be called dm-crypt.


--Sig_/PSNNyqS95fGcNo.RmLegE32
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVI9E7jnsnt1WYoG5AQIxwg//W+tyRJc+PWN6C0W5/GN1BcriN2aVxtat
UGhPUGRPTQmxfIbWGwIEjZCAX1ZqQKBbUJOlhJ45E0UFcoPLAWqDYC7ffcJ55xu+
MaSXvqfsEgtkfgOHrdy97jtJHTFHy6HoSFIILHZoeNfWwhHnSdS2gQncWelpDSHB
Ehom4/x2EPY1w9YaY47BKj3j6rLIkM1hLdU2+Nv/p285MjJ1LVDY78PToWhcn+4e
LsewtLWYJCA1aisy6Iam3Ymt3uds0TJ9I1Stgjx4SEvJMCv0znyWgyKAMI+VsDv3
SfIiMV+GxW7KaxHxaPa6Yfy7rW/8vahaa/Sts1I884VGAOdWWj7Gq4OPfmSi1l68
HgdEmREIngC9ldngN6Az6UcIjVgi+xGUbZhc8MBCv507d5dVNrJSGAzWlcqzKuGe
41QTE7ZNU16LPyVWxAdfCqTrxiJVKDH6KnF2rUcSJ+s1p4FtaoEVYiKOwhHaxCPb
yp1Ut9ShOLBVRAeJfeMiJJsF7gCMhV8oJme3y21nn23hD56In+xWw8s3dUAuFAXt
QeFguqrRDutzLv6sT5GGWCUmS+UzW7P6v22Ueb0N2JmDZfBuwJvr/DqPRsUf0HH5
zlkJWZ020KFgobFrpNgQJbT8HGPBjgJOAnna8lI1e/0GChXTMJMzp5vLv46oX1b1
z0Spt64PsqY=
=XoF6
-----END PGP SIGNATURE-----

--Sig_/PSNNyqS95fGcNo.RmLegE32--
