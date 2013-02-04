Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3BDEfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:35:08 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52944 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3BDEfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:35:06 -0500
Date: Mon, 4 Feb 2013 15:34:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: manual merge of the driver-core tree with the net-next
 tree
Message-Id: <20130204153458.47dbb75568ab3b184a1c4a9d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Feb_2013_15_34_58_+1100_qR.eIQpf8LEDQEg_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Feb_2013_15_34_58_+1100_qR.eIQpf8LEDQEg_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
net/wanrouter/Kconfig between commit 6fcdf4facb85 ("wanrouter: delete now
orphaned header content, files/drivers") from the net-next tree and
commit 1ed42403e764 ("net/wanrouter: remove depends on
CONFIG_EXPERIMENTAL") from the driver-core tree.

The former removed the file, so I did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Feb_2013_15_34_58_+1100_qR.eIQpf8LEDQEg_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDzpyAAoJEECxmPOUX5FEEsMQAKGHfrTNrgf1EQj/DfpMmRch
8h73v72l9X3xLlDysXPBJd+C/GxeAHusD2d/ml+7H8UPLJAO5DMGFCZ5czCHDP8q
IgZAP6RhWR7MvL37d0hVxtSGBVsyoPeqaaT7s6ojDqHzgaifkwI41SHeKKPcZ9J9
8SVvB2AQaEf+Jgaz/u1tUFEni7sRm+YDBDX9w9PnTD8WpKDyfijtT4UW9sSlTE9o
wYsTruatbfR+hG5QYfI1/GENW9AlmtoyPLNoN4UXKgz/urHEZIExsBAujjMhIkrr
x/NAipB2GM3Ct2ytBwFHa9BoWZ71ekcrqtOG/YCp1x61hccs07Rl2ITgnfLDVn4N
uEUsuTS5t3m65FG4G9sXvpajXHJkRzplKhsuDXw1UlLRxibh0l4CrPQhIGd+QIbb
FiOh2gIq68loERyP5ZAKg2YgRieaN3dpNV58s4CUJMi++hZCYH/15f8HqY/NFzXY
cXpAYpgbADVyXB+GVxJoVAna0qfpaeLLEdosIGZ+HaTXSfIpJEqbmCksS1rt28wA
YIfx56Iglficv24CgjkcVsVKQozy16ve0rXStM2Rt3/6yvTz0DyLnFsYdNz2WNcs
PRUScMu5MkyZh8K4AKa86G95HE1+Bu+H0VUt0vpFMNzyVcNxY//pgyU86mkyrypy
KMZW7hF6JvlYSrsW9F2N
=9R1B
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Feb_2013_15_34_58_+1100_qR.eIQpf8LEDQEg_--
