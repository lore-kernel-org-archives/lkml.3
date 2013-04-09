Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936989Ab3DIHrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:47:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47675 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935420Ab3DIHrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:47:49 -0400
Date: Tue, 9 Apr 2013 17:47:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: linux-next: manual merge of the arm-soc tree with the gpio-lw tree
Message-Id: <20130409174747.873a9c9cad1cd6a4dbe4014f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Apr_2013_17_47_47_+1000_+hGXl1Dk1xb7.JKv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Apr_2013_17_47_47_+1000_+hGXl1Dk1xb7.JKv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/gpio/gpio-vt8500.c between commit 808c513ee64b ("gpio/vt8500:
Convert to devm_ioremap_resource()") from the gpio-lw tree and commit
dc1010860b03 ("gpio: vt8500: Remove arch-vt8500 gpio driver") from the
arm-soc tree.

The latter removed the file, so I did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__9_Apr_2013_17_47_47_+1000_+hGXl1Dk1xb7.JKv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRY8ejAAoJEECxmPOUX5FETQsP/0yCMz3aX41hnjlJlzYT+Yl+
5D6+qvHKN/BWh8rRkMg+4AeTUQTes0Kgt6nkN4zl0WQGgxe4Iix25fZIcadq/QRl
nKMYidWYbSrpKOlu09N0NUUD8GWUjCqSJj6ACqLLfSZpmH6IE6AjONPtR19bXtlA
+iT84G53ufQi4zTTInjPfn4VDfKwjICoo3SKYL0m4H/VvlBMUj5w5AhzRY1CGS7l
Z9a30HkINzCe2zQ9tvL5fh2XleQMJQb9h2Ozq+J+XZSXlwHCSBEE61lPzy89ZKqp
rFHIyx64NBfxtAvR11YYcAwyaJR1I9Dvyp6ohNdC/HKo4XnhDe+99KIL9O7iEaX+
6Cbs/8KH52HLaKQ4DaMMYSZvTKteG8SJzcjurKo9tDbDcL7EasFPef2X/ywaxzz+
tvQUkj/KZlM3mOyUzpNFMWTuV4lv2xHJ6BhYlfwHcBUtAxdgM2wQNKa3WITPbnWp
Ip+KDo2JbRtSM+JtbQbZ0kwoSb/pBF/XY/rVSQqUFsR/4gziYCjKak6Fam0mCLMt
s2Ktyqaj4AY9QR/ChgWk5nCe8aNcJBvefoT5ubCN+lLwAv7Xa7+IWWo2l+y5FFwQ
dkDOrK6CWm45bIDBWdzc2j6pxKMabkdYoHoa++eHUQ71I4RP9Zo1zlCs3LeusxJN
IbFTQGhK02dXJyVX+/uk
=m3YC
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Apr_2013_17_47_47_+1000_+hGXl1Dk1xb7.JKv--
