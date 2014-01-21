Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaAUCnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 21:43:42 -0500
Received: from ozlabs.org ([203.10.76.45]:43953 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaAUCnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 21:43:33 -0500
Date: Tue, 21 Jan 2014 13:43:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the sound-asoc tree with the  tree
Message-Id: <20140121134326.5b0d0d08c8b718e6fa635be6@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_Jan_2014_13_43_26_+1100_Q85K2_XDFeuyGZP9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Jan_2014_13_43_26_+1100_Q85K2_XDFeuyGZP9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
sound/soc/soc-compress.c between commit 2a99ef0fdb35 ("ASoC: compress:
Add suport for DPCM into compressed audio") from the sound tree and
commit 76063d340520 ("ASoC: compress: Add suport for DPCM into compressed
audio") from the sound-asoc tree.

The sound tree version had a later Author date, so I just used that
version - let me know if something else should be done.  Otherwise, the
sound-asoc tree needs to be cleaned up as this is the only change left in
it (relative to the sound tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__21_Jan_2014_13_43_26_+1100_Q85K2_XDFeuyGZP9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3d7SAAoJEMDTa8Ir7ZwV880QAI7ka0Oaina1DmZROk2i6f/J
yYlU4kxl4CSAfeeClnO+0ou6L+T6ZgUNuenoSd7oNu0BP5VGsdShaNCY0g5BoirO
FdQtMYpOWXp1lorQqHmjlfdRSJSqLvGJKbNAsJ8uN16JEUbygYplJ6rXNxMf7Ok7
azYf+xdjwquMJZ5m3IF+/Y5+b0CycSmQE8HllGBwzlCgKFwCe5gb8BF1Z1ImsDX/
7T85Mo5EEkyecnxMiKEDrC0V0/+o8/vAV1RH7AIhbBo6QM2O3lWBHM1Ew1CjPDMC
/+tnfa+Cz97jADXfC3C60OUY4jTbVtIy+mq1QoXQXEboGRtmnkqc27WGwG4Matv9
BmnP+Ns5AcqKysrFwRFHTXhhfPga+IvFqvCHsHYr/74snFpWucBWkGS2n0vbdX8C
aV6+C3Ck6oUYPHd6aLeV49+D4+kgcF7eOalTOfr1AyTkVJcO+rJSP+N9m7n67cTe
Os1bz8M4crnu+CG/+GiA5D2E8+9L4kNa58MNZu3+ruC4SyrkiEcRrJvCWsEYnzYT
87p+ZGUEVNYODmojQ3izKO0z8VcsBuhr4EAh7sXp5f1Z89rEfMUU+sszDcAhlUsM
NFiw4kKkkPf+/yA3ZYOtlpdWg5hCh7ydAdZFHDjWccgywkAfkhYw5cBLAq84kQIP
jS7woVvwIupA5bW0EPbE
=tEZO
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Jan_2014_13_43_26_+1100_Q85K2_XDFeuyGZP9--
