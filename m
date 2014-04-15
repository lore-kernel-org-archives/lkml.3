Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaDOBrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:47:53 -0400
Received: from ozlabs.org ([103.22.144.67]:34820 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbaDOBrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:47:52 -0400
Date: Tue, 15 Apr 2014 11:47:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20140415114745.d1b7997d0271566e38af45f7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__15_Apr_2014_11_47_45_+1000_CRR1SPOPF5mbRs1t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Apr_2014_11_47_45_+1000_CRR1SPOPF5mbRs1t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build
(x86_64_allmodconfig) failed like this:

sound/soc/codecs/wm8997.c:248:1: error: implicit declaration of function 'S=
OC_VALUE' [-Werror=3Dimplicit-function-declaration]
 SOC_VALUE("ISRC1 FSL", arizona_isrc_fsl[0]),
 ^

Caused by commit e13dd8ce39a8 ("ASoC: wm8997: Replace usage deprecated
MUX/ENUM macros").

I have used the version of the sound-asoc tree from next-20140414 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__15_Apr_2014_11_47_45_+1000_CRR1SPOPF5mbRs1t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTTI/GAAoJEMDTa8Ir7ZwVfxAP/1K+MVjJerADjT93tH6d1mUA
jK6WvlhU0+X62GAhHZesCtCH4kw0F46T5cLLviym5EHbKoVvWFrUnFitf3X0RkS9
zUxaV6QMKIol46zES/zA33rcHZs2iC69+HY8e7FvMXyP12HjWk0vLjF/z93GBcRu
f15nHMrL/K20h0ufq1i1kyGaFE/wcq9fM8QoSOIG7ahuDAx2xiG19I+ZDifoA1Ix
895CBSf07NiOP1zc8VO3izCWtIis3w+XG3AsvItWyZvAg9/ZN4llcKo/yM4fU3HE
j5BR0I67FXAfFo6yA/Vf02wustNF7NqxcnCAIxYtMMOT/2JzMOb+dExWZ3lpsEAA
MdSrwzTis5Q6Gq6BGj9ZAU75ovJDvpn6n990FMpdcHeP1nt8h66KDhB9wzL+i3C7
ZFs9f5QwjPJg44OHjRanIDczkWqyhaIjXl8YzAKdyln78oVLskec2sDv1VFT9Bqd
0NM6bvlb4ZHAdYfcQqF6cQWdAF2kMfDYiQg2dEugpTKaw5K3RW2gQE/hG1QgVGUG
6Fx56tijGEzylQ0MAL+3KzyxILVgcwpz8k61DnDEu2ZgZ0qGmgxFGB4u2uioQTcm
eBvgWHsQ2Wwj/hEAeuoLMgZVD4LWycx1QKtcowY2ltigdxQZjLWd4cQlFqiVBsUz
d/ncWHIOlHtXmD+Dye9N
=INsZ
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Apr_2014_11_47_45_+1000_CRR1SPOPF5mbRs1t--
