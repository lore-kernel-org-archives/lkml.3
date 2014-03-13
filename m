Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaCMAui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 20:50:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39681 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaCMAug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 20:50:36 -0400
Date: Thu, 13 Mar 2014 00:50:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <greg@kroah.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140313005026.95bb2222270ded24b0a5deff@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Mar_2014_00_50_26_+0000_=8aNZ=IHkcGFwuRJ"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the staging tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Mar_2014_00_50_26_+0000_=8aNZ=IHkcGFwuRJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/media/v4l2-core/v4l2-of.c between commit b9db140c1e4644d
("[media] v4l: of: Support empty port nodes") from the v4l tree and
commit fd9fdb78a9bf ("[media] of: move graph helpers from
drivers/media/v4l2-core to drivers/of") from the staging tree.

I fixed it up by essentially dropping the support for empty port nodes
since there were more context differences than I was comfortable with
in the changes in the new code.

--Signature=_Thu__13_Mar_2014_00_50_26_+0000_=8aNZ=IHkcGFwuRJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIQDSAAoJELSic+t+oim99d4QAIdPM9BTZzdS5xNiaQk/z+0G
cHrTnDABRpYQRj+iFjYmAJ9HF7KHFgPJ7GtVSgKuHEgmTtI0xHByp/16TUSbfKgn
OVcBB+JmVvS8l14sWacDcx8fjEblxYm0FeOnzJe2J/4v4w4P8eH8Fkd+ekcw+BCB
C5PDfYms7TmCJJm+qBMf1zPKiz98S/wEcU0XWEecuSYjIzGhq+xNOBMpM/l5IZcD
LU07M5jrk5TlywdfU8FXLdK9UQAGcQVYALNP3+30E7y68mT2JFNlSn53muDop9TX
bRdlJjCK50Pjo6x9Ge9Q5ZCaj5fqDRtROXcRjMrobvfJQ/eaVkfFBmjB8s8i4vQ4
hJg8cBlb3Kw/5h87Qxv1g+bdKH62CSIGxHg4AvSY8CsOCJPfna+lOwMB/ZYvotXm
JwrkSFpJb3Qg9mTHXpfumRRd+eKqSgTVhpXltnzXRIvEwfxIecB36h3B5M6FQ2PD
Dlb1Hb6mAGnfjPiLlu8x1XYnN7F6kTH86ZAtRG+8l4ttbiofFSdCtj6fW+WmNFy0
KCFEI0OSE2pNuC2M9CkcV90SV9agyOYS5PftUW7QXiNGqjNJCsbQlOwa4hj+xZFC
tR6JqjYtNCkWqGfvBKvQxgfxMXtZEvTTTSeHXEQtg3l+d3Ah0yIdoI2WeMi6yNl7
PReJZRuU2Ms16WZxclFL
=2FH+
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Mar_2014_00_50_26_+0000_=8aNZ=IHkcGFwuRJ--
