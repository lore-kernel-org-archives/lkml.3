Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbaGPD3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:29:01 -0400
Received: from ozlabs.org ([103.22.144.67]:34111 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759199AbaGPD26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:28:58 -0400
Date: Wed, 16 Jul 2014 13:28:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Raphael Silva <rapphil@gmail.com>
Subject: linux-next: build failure after merge of the wireless-next tree
Message-ID: <20140716132851.5b974707@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/n9D+SMf1hjfo5ju.as/a=P4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/n9D+SMf1hjfo5ju.as/a=P4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/rtl8723au/core/rtw_sta_mgt.c: In function 'rtw_free_stainfo=
23a':
drivers/staging/rtl8723au/core/rtw_sta_mgt.c:254:27: error: expected expres=
sion before ';' token
  pstapriv->asoc_sta_count-;
                           ^

Caused by commit 3dd51964026e ("rtl8723au: Corrections in the coding
style") (its always the cleanup patches that cause problems :-))
Please unit test *all* patches.

I have used the wireless-next tree from next-20140715 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/n9D+SMf1hjfo5ju.as/a=P4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxfF4AAoJEMDTa8Ir7ZwVgxkP/j6d6vLFUOFOMJCxW8zo3QlO
58dd4KcP4BCrqWaSHKPcC1Ih5kzVNH1VXTRaNcL8mk6OFra3UXVpJ89b4qxksFvW
+htqDluHEz5VnIXK02XFCzDRvaLqkkuo7kGRWo2gYVSbqSKqAlb/eX5pi0EAwVed
YChAc+Efr1EM5HQ1mhHH9XsP2nxGbm94dO2XKlEL/i0qnzPRaAdNwnZcDtglLM7L
86yApQTT2HhQeOdv8thJFWcMOgRGzob884O98/m8m5Yx/tmXgCVddsNFzM26X78n
heCqoEpbpy4MVlf3zAZUdp9O9BPJbnFcfw/ua4/tN/BmdoVZUcTmz9boC1qkqhfy
K9ihFHebvXGZ+I8POBMztzb2toBuZiSjRGJpGNCW6KolXDzy9rXo+KzTcd5vDSQl
w8j9QU9FtSx2ux07+6BoDGt4iR7lYFYvtg3Ad5/uI20Xbh6hGbagovl3tntahTcP
wFnLL17xWuTtjvqatWvUNQoPG/0x30PaX9YT/RiHYliLpvz+klo4+Pw3eBuunQW+
yNorZfWQ0oMGXFHn3NzvKn1IyfGmEFWT11o9EzTw3NE/7XI4G19O+KCi+3jxLK38
NAJchHGYWswRCZiwLiIwjPhHOpEbox1Sipr+1MiQntCgwewFe5tnWDzU343Px15K
3hfsP8VZt7hbXZ4KrzDa
=ptH7
-----END PGP SIGNATURE-----

--Sig_/n9D+SMf1hjfo5ju.as/a=P4--
