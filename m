Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3EVDhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 23:37:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55633 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3EVDhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 23:37:36 -0400
Date: Wed, 22 May 2013 13:37:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: linux-next: build warning after merge of the tty.current tree
Message-Id: <20130522133722.d52b827e455275dfdecf12dd@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_May_2013_13_37_22_+1000_BFaMl2Ucmj63I.Ua"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_May_2013_13_37_22_+1000_BFaMl2Ucmj63I.Ua
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty.current tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/tty/mxser.c: In function 'mxser_ioctl':
drivers/tty/mxser.c:1680:3: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]
   int p;
   ^

Introduced by commit dfc7b837c7f9 ("tty: mxser: fix usage of
opmode_ioaddr").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__22_May_2013_13_37_22_+1000_BFaMl2Ucmj63I.Ua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRnD13AAoJEECxmPOUX5FEfUIP/3oymXPQmV10zj1Cj0aiOI+4
bO+xVjvJXRoauegBSaBDE+sDMhUMbYEPOOGR/uTjYF/Pd/THCdnGmi7f5GFlIhlH
BzAFBP7QQiYbwl8Yy4JJHMPmYAKqxmN86qCtNo4cglr6K8RHUMD8T2I5HHlTwiey
O5gZopdOLwRdxysWIrlqloH08MNemuQ74aQ5H8dszVERKRZQa8fVB71Q3RvO3gQN
mA4ndd4TGn3b2E6589lgE/Je7K6Z8qp4KjyuI2SqFPUc3ITmR5Sf2xGsLGk/uhWQ
mWuSKBd6GOfWpVJYGA8w29JgVGuAlqfZ0OUl1zngiyfHISdcIOdFkV3FAtTi81CJ
KSo1XdHp4wPDXI8SK9udeC/0PpOuc9lA6W1a+lk+BSpRYB4lWdSeM87wWhhOOeyr
bye4W3yYn02jV5kr7w3Upe6noPnL65aracGg2PoqII5vNPE/xBmX/PPYbxYKsbpp
ptS72stf6QLlGaUBfw5cqIzT+cMMA/P8DVIUSwagz3+mH3h6J+oyawPB/t132QDc
X12LbzK24f0deBxv+GxU1Da5/iAyzYC9FA/flVgpeCQz4Uu+sqKP8wwKDNqvBKAX
GPzQW1L+I8OipTMqNbFHFjWxd3/gfdMkj8GV+5rjhGm4nGHbUE9m6kkon5Shi63j
klSLm7UNf3m5liRxH1KX
=Kj9U
-----END PGP SIGNATURE-----

--Signature=_Wed__22_May_2013_13_37_22_+1000_BFaMl2Ucmj63I.Ua--
