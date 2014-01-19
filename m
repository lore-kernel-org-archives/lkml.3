Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaASXkC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 18:40:02 -0500
Received: from ozlabs.org ([203.10.76.45]:57284 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbaASXj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 18:39:59 -0500
Date: Mon, 20 Jan 2014 10:39:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: build warning after merge of the arm-soc tree
Message-Id: <20140120103953.329bd64dd540d547956ff46c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Jan_2014_10_39_53_+1100_Jk3Egyvm8+Ez3E0k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Jan_2014_10_39_53_+1100_Jk3Egyvm8+Ez3E0k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the arm-soc tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/pinctrl/pinconf.c: In function 'pinconf_pins_show':
drivers/pinctrl/pinconf.c:299:28: warning: unused variable 'ops' [-Wunused-=
variable]
  const struct pinconf_ops *ops =3D pctldev->desc->confops;
                            ^
drivers/pinctrl/pinconf.c: In function 'pinconf_groups_show':
drivers/pinctrl/pinconf.c:346:28: warning: unused variable 'ops' [-Wunused-=
variable]
  const struct pinconf_ops *ops =3D pctldev->desc->confops;
                            ^

Introduced by commit c420619d5177 ("pinctrl: pinconf: remove checks on
ops->pin_config_get").

Sorry, that I did not notice this earlier.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__20_Jan_2014_10_39_53_+1100_Jk3Egyvm8+Ez3E0k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3GJNAAoJEMDTa8Ir7ZwVe4AP/2oBSWAwuyQfwAj4e7vCh6US
cFVsHmTEvhwIUd0f4NZHquuRcG5X0mBJyc3NLRwHEgc0SrmVs/ZWi1Exx9ZmhJuN
7KDR3a5Hdf4xw0s3iS2iPUm3xi6dBcUDlo+AJdGHeKS9I+OFREbYaJ9r+n2GDXHJ
G8JaoRX0a2Y9paO3n9aSCRgvRcbkZGuq9HJG2l05Ixvos4eo8HuyqYWLnXzkBogm
GKvlg3xNQFgyLbSzTWbo1XFqNROzb2KEy0noiPOVuCX/kmASI2WOZ7cDUCd5zsI0
EwJjbg+dh4Ar2p1Pb3d3vVFQ1sGgDTe4zTrpLt3e/ww2+7p8Q2r2So/0zwBCZAQU
R0o8aLopzpG6tR0QMQhb+6Njbbuafn2/elCILE/Y7Rerw+KHnbxBpodyrw3gJbEh
TOGdBquKr5iO4t9OGgWFFJ0ROGkl5OlMc7zu2Oi5o5kTPTFTq075BVBPJam6BvDl
i3PXUmjDJuO6iqtAd+K8iuPQbxNtZj1+mb0WFxbd1F9kue/TFXTX8vdNIh41avKi
7xt2NPO0LZYDDtX8wmIGJc9vYfVWV+SxvLNnij+FBJK43UKuqr1ExiuVoJwtB3Xe
DPFK3ANRwKS1iCLXYheF5jqLLvQsd2tgavJTVEnWg7oY2r2jC26Sf0u0rUM7tzX8
c/M0ky92a4fqu4OL28Lc
=R4iP
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Jan_2014_10_39_53_+1100_Jk3Egyvm8+Ez3E0k--
