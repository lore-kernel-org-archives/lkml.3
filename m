Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3GVXzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:55:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38206 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3GVXzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:55:19 -0400
Date: Tue, 23 Jul 2013 09:55:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: status of various trees
Message-Id: <20130723095513.19b9638ab4a19157e9834dcf@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__23_Jul_2013_09_55_14_+1000_RuC90XG_zb2zFSEO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Jul_2013_09_55_14_+1000_RuC90XG_zb2zFSEO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Currently linux-next has the following gpio trees:

gpio-current	git://git.secretlab.ca/git/linux-2.6#gpio/merge
gpio		git://git.secretlab.ca/git/linux-2.6#gpio/next
gpio-lw		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.gi=
t#for-next

Given commit a0062d4e3a0a ("MAINTAINERS: Remove Grant Likely") in the
devicetree-current tree today, should I remove the first two and rename
the third to be just "gpio"?  (And does Linus have an alternative
"current" tree?)

I also have the irqdomain tree:

irqdomain	git://git.secretlab.ca/git/linux-2.6.git#irqdomain/next

Should I remove that?  And is there going to be an alternative?

And for spi, I have:

spi		git://git.secretlab.ca/git/linux-2.6#spi/next
spi-mb		git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git#for-n=
ext

again, should I remove the first and rename the second?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__23_Jul_2013_09_55_14_+1000_RuC90XG_zb2zFSEO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR7cZiAAoJEECxmPOUX5FEhRoQAIcG05nhIYWtgp0gfRVWgAQQ
9xW8yK05bo2TMHaMjWJmqA/b0mCzfcSSmSDdkiM57N0USx1gFKCU3avFjssxZsKO
RriBAmaazJQ41knnk0bsiOi+mEarE/NiQzGNvjvG7oqtzeVa2rBvRbACxyCDFi43
na9lMSbZNsK25AgTEDz4DHMScIRRwHgFX1Bv3dVoj77Y6EeN5lupCnv/F1l99IT/
N0BcWWSRg54Q/8wuzRoDapwZCvUsEs9dl+gV9+onYO72Lly1rLzZa6gjgPaKMyOZ
jkovaHkEZ/0k/TI6QLYTJHtaKfvyDFrsBsP2Vs94jAq1H5q09OI6yACcyvjcAsO7
Niq8r51Ss7xRzmR/i3Tzw4hSZADwfCHbRYsfevAK287RbdaMVZ5dyLGCvoRdp7ix
wntOYqBI/jn6VjKf+hyU9XGRUfRQ1HxCwS1pNDCAmFRtTo9F4XPDhucgJUnoSl0t
vlKMLQ5VRPvqMQkqE10od1t3py48WyPnRsJpMbB9D3VmZeyDR4OeqQCc1tipUHC3
nMEZEPKHGNt+ZRfh7+0O9PuL9QDJE54IzTkOh4vdeL4PfXAoFv6Cguoa8hrAmLk+
vS0vTA0d0nTQX7R2T9riR4Dl9WRNqCOak++DvFwB29zmtt1wDrcZUWj9KNDLpsK7
m/84dL7Lk3Ixk+8TQL9o
=snc7
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Jul_2013_09_55_14_+1000_RuC90XG_zb2zFSEO--
