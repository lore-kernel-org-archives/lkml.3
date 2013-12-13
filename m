Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3LMEGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 23:06:52 -0500
Received: from ozlabs.org ([203.10.76.45]:42601 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab3LMEGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 23:06:50 -0500
Date: Fri, 13 Dec 2013 15:06:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: linux-next: build warning after merge of the pinctrl tree
Message-Id: <20131213150643.51342b68314f2d6b201e54dd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__13_Dec_2013_15_06_43_+1100_7mf8rNDm2xtmEFgD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Dec_2013_15_06_43_+1100_7mf8rNDm2xtmEFgD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the pinctrl tree, today's linux-next build (x86_64
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

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__13_Dec_2013_15_06_43_+1100_7mf8rNDm2xtmEFgD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSqofXAAoJEMDTa8Ir7ZwVd4MP/iSe5h0+cigzf2eRRAUchx2a
SRBFEPLn22181kvlSqVGrhPiCdr5pE8RkB28hnsvrjUZNU2P7vssTpZV8ikqlUYg
1YuNT7CNrkrYJGJyg+jZVjJf7HCubzqMh3c4AQ60J0CbeNwBtA72noxRS657WnHE
4//O1NKGqp+hti9FGaBNuujDvMK0EKlQaEdQeUPTMvLBQKCLUyhHZEL+xQYuiA6Y
9eN0Zm30UY3Nco3y6CkkseAyNI14WZVXcMIyKP/6aq007TyIt53dJ8CrX4vN4lqE
MUJTbOkOxe+A5gguflutQ4HNreNC4MNI2+aRQVrAI7bHl4CWlEl5RNN6sog4c3L5
9fheNUDPdgfdAog4KGIEc+/3ZELwtfZUfH453W6qoyMybwIHjlsttdW+weGxi5x+
gn9+b8Hi/Dt7F/5QDrwE0f2ABhukzxm2+JnRSkdra+GBCjDntJmwL40M/8tajeDq
ibRj4hpE4fdABr4O+7SP7Ioc9ydL3gCmmrFE5kc1O1hxhYjdSlPIqqlnCa3hzU2I
Cfzg9SFcWjNm3NHzeooiwfhHF0H52gmJm/zp1RcM/jh/GmhhH3OqqwZ0JJ6vHK4j
bEtOuOCMaYKoXeUP/a5Gf/5Jl9JwkTuuMPjNbZUh78BVBORPhuXDhtLksMC9psue
bfX4Jr7efXWtizsaWoDL
=1+WF
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Dec_2013_15_06_43_+1100_7mf8rNDm2xtmEFgD--
