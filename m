Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaDGAVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 20:21:14 -0400
Received: from ozlabs.org ([203.10.76.45]:46242 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbaDGAVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 20:21:12 -0400
Date: Mon, 7 Apr 2014 10:21:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the arm-soc tree with the  tree
Message-Id: <20140407102102.97ad7dcaab69324efa8d897a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Apr_2014_10_21_02_+1000_aTLV=OV6ftiY/tqB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Apr_2014_10_21_02_+1000_aTLV=OV6ftiY/tqB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
arch/arm/boot/dts/qcom-msm8960.dtsi, arch/arm/boot/dts/qcom-msm8974.dtsi,
arch/arm/mach-omap2/pdata-quirks.c, arch/arm/mach-zynq/Kconfig,
drivers/watchdog/Kconfig and sound/soc/kirkwood/Kconfig between various
merge commits from Linus' tree and various merge commits from the arm-soc
tree.

I used the versions from Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_Apr_2014_10_21_02_+1000_aTLV=OV6ftiY/tqB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTQe9yAAoJEMDTa8Ir7ZwVWjwP/0t01hBnQHcHgthyv4WNolRt
SceHDG1ikfghygYjWGoRDF08LgEcp9i88GTIyHO7vDnoDx1/ai2UwUvzBytREW0G
UpCMEDq30sTRUytwXcthFgZ5sTp26iK1BtZeiON8U8LJu0omFRQrvvHqbbyP+Kd9
hbLNatffsu5bgIeGxOJNZDuoeYeLnQ+8Q7QEQ9GypWrVXbWfnvDaAHcw+dheZk09
yzphhVk5FLPOIIqUhwtrkpB4c7vyzdWO6L6UPI6gZm8zhX9PsIESAts1M+L7tEQG
6h/hX8JYouVxsdYl7JYdjCkmpQrLMEg2pzFiE6QroVsNSQCNts5L29bekBD7EJn8
ZkUD6H/2GTvWL5CZZeksTBuDCaIsZ5niBoblsJbVhOk/Q26XwCySuYh2ACKVkGVJ
s37FI+irWndTqKcG0Cz6FUg6jZd6RS+tJJtqGJHaRX5se+AB9XDbwzysAQrXzquT
NJ5oStjisv0CD/khd8X92iwgEfh7zYBofm8mfpGLwRBNiRr7qLiEG+TajuiRzabs
N3yGMZMBmk3IdgnZ9D08KFkKU7hvzFaDHhbfg6yZq2TtSi1pwgpXB/LslOcaCFQX
eW2SUjnhIBPe9obE4knhKE6mbDO56erN3Nit1myDuvuRC7toZ6fPnhMKL1Ej4cBc
upmAnR46JYkW1DalaT1U
=R1U+
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Apr_2014_10_21_02_+1000_aTLV=OV6ftiY/tqB--
