Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3LSCvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:51:11 -0500
Received: from ozlabs.org ([203.10.76.45]:55515 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3LSCvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:51:09 -0500
Date: Thu, 19 Dec 2013 13:51:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Solner <solner@alcatel-lucent.com>,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the modules tree with Linus' tree
Message-Id: <20131219135103.a679236c1c4ec0f614fe3357@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Dec_2013_13_51_03_+1100_EoeSjd=9ulGg2wFv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Dec_2013_13_51_03_+1100_EoeSjd=9ulGg2wFv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the modules tree got a conflict in Documentatio=
n/module-signing.txt between commit 3cafea307642 ("Add Documentation/module=
-signing.txt file") from the  tree and commit 160e01aca3da ("Add Documentat=
ion/module-signing.txt file") from the modules tree.

I fixed it up (I arbitrarily chose the version from Linus' tree) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__19_Dec_2013_13_51_03_+1100_EoeSjd=9ulGg2wFv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSsl8bAAoJEMDTa8Ir7ZwV4o8P/1dbX9cQkuJ4hW4HEoyrBpQe
ztRAhthKb6RD41r5wxz48FBlZIGVJmHq/3YDL3ARX06kSBmrkZGXqYSBN/MP/l+g
I7PsTOgwKh0ZudjG3js30ISJSSKrO5uEb4sP3vmwbWu5Iffwe5BqixM2Qij0lhd6
gkmI5XctFLLkhAb5Y0/u5pRGzCYoxpabZWgBMfIRrwkZMUk46ini34iVgvizlBdN
m4g2B54aOZUM7dFglXvC4EPYGR7i0r7mQebf1o5RpVYOQDXmtoUvDPzldBVWzlSZ
OCw0VtFa1omFZwIEUD+TY5bUBfK8FQOIZeNHVO4qKrdS/Du7DYbslJ8K8QS4A/Cc
hoQJNOOOyWdtkM85puaAdBuifBrbaT4X+U20z4vUo7j75akcXiIdnr0gzYT2oB4X
kPo7m1LYt73XHK3dBSFQbxAyOIk3zLjidt1y5nEEUevISmg5GxGPXbQ2osJYUrw2
Yidxni1anXo4xxl/6zNUO0aRYVns1L1NwcE7EJMwa8Lh7acgVFRpg4PEzUy5dJ2Y
6XE2tsIce/FaMfESkDJMc2wUMVRr28Y1SjdMEVFAocQdjMF1QWeo+joAH6GlaIgs
pPOC/UytqEMAzTDiMJO5xA3XocBRrwfLRX2V1ddmES20NfVf3xbX3uc+UtQVLb7V
ucdFzBly6cMHgHbe+csj
=7CiP
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Dec_2013_13_51_03_+1100_EoeSjd=9ulGg2wFv--
