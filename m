Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab3DDBAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 21:00:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47855 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab3DDBAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 21:00:51 -0400
Date: Thu, 4 Apr 2013 12:00:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the wireless-next tree
Message-Id: <20130404120043.794afc7dd061dcd3adac0fdb@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_12_00_43_+1100_qiCBU7KbX69M9Pr9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_12_00_43_+1100_qiCBU7KbX69M9Pr9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done
x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done
x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done
x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done
x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done
x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done
x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done
x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done
x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done
x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done
x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file =
unused because linking not done

I have no idea what caused that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_12_00_43_+1100_qiCBU7KbX69M9Pr9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXNC7AAoJEECxmPOUX5FEhdsP/3hIFdcL8uvNNd/9QTblY3N+
iEleK2+15iAKbboYgLpd9xTSzcUH9McInwhLiYEcdLvxTQC4ZBo/C+tZwETQ2yU3
IhCz1clbOv/dy/d4tVwU4aIaNTozgEirCrSZ3nq1KzTthl8qA+blSaj6GSJ7iTLY
AWBOk9SPGJcHeYqj1KhrZoPJfxMeDw7FaJVixPsXGg8/lwj5kMvzxNMzafNI5QNm
M+U2Qfn1JMKx5qFJCZcjZkv48jcSkm7aHOhB6Mk2iogx6vB+0grlCrPi4xclntCa
BoEMIBEW9KghYCZlW54OPDLLCsFxRLURaMgbHnPtHEWHfVkDHjv+W16RGisVYLyx
8a8jkLuCMoIfCSOifVIVIkIZJXO6ss4hPXvatCpub0G6ci+AvsC11+I3YxPqCmnl
BjpIhEZkjHk8wQ6SPfuaP4jr0CbtDJXsS9ekrYJNh4wLrGhTN4R8CHOAqw/R1m2c
UZDm5jnOu5rIxYSoc8vhxN7sRBjpISMZzPEPEZ93mlR/cHSKP0IItkbZK9/vaVAA
Hwkh5t55p6PzEyuEIJ/gajhqDbARk+BU5+yejLkR09uqCZ9yB1rUjpS80vjKpeAi
fzHo9CD0v3yX5opGmftGj+eSUYSFkN9UxAGdo1esLTZWoKcGYqm6i08Z+RGssId5
JF1SOLoW+AirUhyjZUwx
=E5K9
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_12_00_43_+1100_qiCBU7KbX69M9Pr9--
