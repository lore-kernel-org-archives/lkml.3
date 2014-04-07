Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaDGESX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 00:18:23 -0400
Received: from ozlabs.org ([203.10.76.45]:43762 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaDGEST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 00:18:19 -0400
Date: Mon, 7 Apr 2014 14:18:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the akpm-current tree with Linus' tree
Message-Id: <20140407141811.bab860490915219f94464446@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Apr_2014_14_18_11_+1000_k9z=Su4Wz.9J/2D5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Apr_2014_14_18_11_+1000_k9z=Su4Wz.9J/2D5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got lots of conflicts
with Linus' tree.  I tried to fix things up, but it was a real mess and
in the end I have just dropped your patch series until you can clean out
what went to Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_Apr_2014_14_18_11_+1000_k9z=Su4Wz.9J/2D5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTQicHAAoJEMDTa8Ir7ZwV48AQAIeYu+7JQSEY+ZU5rfpNTPlv
cd8ooOOMiTSL2YUPcUwFMKLI4suxzpLVWdhXesTetwG72cYvd/6qjK670Dqb7Mbh
miWqU09WuHYcgACX1Ot9erV/9ElClpxT1RhQy6OeXT+/mWxnPzZ8jzKOc7Ouky94
HsTcx/BqglEsmle5/be46+4q0CDNhACApC4GZ911xO7Pcn8rCI23EgWE+uv+4hxl
/CnJvxGESV3p3dPd/cwphcqbwWGyPDUAnWtcONe8+o9t++mqLxe3NjSDChuEIfZ9
GuTB/YTpBM1apl8y2e5n5aCzTUgW9mOCWNNEOiuH9XQmoLL/ZyM6TEjQRnQTGfPs
FD+CR/FnljNjCpjB7jOyVB225XPTqFBzI84v/D+xtayOpjvnGacbfp2BUfLG9Dur
yolXH+kMd63pkxnXDx966TRY9njXsCVZNPQnQTFs6gNaSnsp7kztnXz6UjbNsUxr
us2fDqZ7G8OejBUo4jCWE0KNV6z3Hz2hiVhfz2Kcb1mKIUIVyGzlWN3vazw3rHfK
K8A/BsRJ7TI2HNnjEJmGRwuoEAFu3sh8Gqkpq7VE3Nsmjo7DDJnWEBLrKbPZnIYE
rVl1RLV9SoE0C+ubGIehdgMdU33eW7UpIyMzElKEKh3KHIqYjHWGxerBonFRYcjY
ImtSxWYDtzvrgB+tI1iL
=U8Ri
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Apr_2014_14_18_11_+1000_k9z=Su4Wz.9J/2D5--
