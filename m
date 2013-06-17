Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3FQHBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:01:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32976 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3FQHBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:01:22 -0400
Date: Mon, 17 Jun 2013 17:01:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Brown <davidb@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the msm tree with the arm-soc tree
Message-Id: <20130617170105.68c40901e9d43acea18752a7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_17_01_05_+1000_8g8APUsxvQBEN4En"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_17_01_05_+1000_8g8APUsxvQBEN4En
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the msm tree got a conflict in
arch/arm/boot/dts/msm8960-cdp.dts between commit e45600107b67 ("Merge tag
'msm-cleanup-for-3.11' of
git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm into
next/cleanup") from the arm-soc tree and commit 70f0aa52e090 ("Merge
branch 'msm-fix' into for-next") from the msm tree.

I fixed it up (the arm-soc merge used serial@19440000, the msm merge used
serial@19c40000, I used the arm-soc version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Jun_2013_17_01_05_+1000_8g8APUsxvQBEN4En
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvrQ1AAoJEECxmPOUX5FEdDUQAIwAF71XTxH553sFaUCtpvD7
9sTFXGGdUXgriktMaGqmsyrk7qqcRFwq81uBZ8wgAS4ZFNh2V7IF4Fm/9677o2qF
4LcICaxV9H5IwZ0k5qsgi3UnMrZOY5uR4KcQauDL+hUN2iKt5gzs1hvvkoguNMo4
QGKQivdG8Oc02DpV06mk8GvuoGGg52FLEaWvlL6WhK2j8gFXKV6M2M2VPwbTGcML
n2kuj7xM+bXSfkp2D8any/EaHCcCiNWp3V4zTXwvfVnBiMxed3MmHn4IHXaxsK6W
FMgPHpy+qagBO9SpKqqt2fuIFRE1q9ngpzBBko7vbdY6OctsbmCXe97eqXGllNVN
fmhMwju1nu5VSgR1YqUqLbzsrP611Z/vvN8zWbOMqR+xs7+gQWbidlDBfM+n511e
fy5UtTKFa9mvPZDRnFewxJCl/9w0pe7DPxqu6cpAaGAJ2/blkTCUiUpSS7S0Y9xS
DFIWc63dfS4hY3zs1yUk60FXKdbtgHYcfg7l5vOROW0ezZkImpG4UgPW9Y8G306C
SCDNj0qoss3kuiUaHhiWKP6BzUvNYeoUtxSNdKc1EmOeMJ6/xnIl4C5Gck8jzm8j
XXZ3JpiCRitAqglOsK0M4tF1qNDNeqWGydeVO8HDtHrz6lgsqJsjbK0ZK65mKufL
SuqFCNZloTDSr+9vybJh
=YRv4
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_17_01_05_+1000_8g8APUsxvQBEN4En--
