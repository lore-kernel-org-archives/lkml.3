Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaKVVMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 16:12:05 -0500
Received: from sauhun.de ([89.238.76.85]:35734 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaKVVMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 16:12:03 -0500
Date: Sat, 22 Nov 2014 22:13:24 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] i2c: omap: fix i207 errata handling
Message-ID: <20141122211324.GC1275@katana>
References: <1416529011-21803-1-git-send-email-al.kochet@gmail.com>
 <20141121160828.GP7508@saruman>
 <B174E67D-9CCF-48B6-A5E5-911668161823@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Content-Disposition: inline
In-Reply-To: <B174E67D-9CCF-48B6-A5E5-911668161823@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Guys, I really appreciate you help.
> So much testing and review.
> I could not have done one.
> Thank you!

Well, thank YOU, for your hard work in verifying this controller at
low-level and in corner-cases. This is very much appreciated. Plus, you
have been very responsive to comments. Really good work! Hope you'll be
around for more :)


--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcPx0AAoJEBQN5MwUoCm21oUP/RFIRB2F2KTchjzowvNmQpx+
Rjd47jsBRH9kDHPdjJ0FMpxDXXfy3MziI79xkmB1nN6O2tVoo1hEUXi5qLcReKhD
dMsL1dpaG/tvMluf4rQH8V7gL0I1kbRVoXtu6zgobwNsLnRWawbS4kY7vuxou70y
TqazsdXKCCETLNzkrDOO0DmByZyW4imR8q3Zg9ouFribhR/k5D0fJErGKINJy1Mc
G51m+yXg0YjH6qYmsK/99Qa4RywrkaoLNfedScrow0P4j0inNFWhl5soZNbW+WSE
ikfg2D4VTouxwYqAfX1ew2X/Cd2MrwV8uMlJW2L0Ad6lrPEofNs0aqZDQ71tQVf8
bb7dNz5ZjP2Ty9e40lOUO2p9OgLDTVWiKG2OpDMn+DK7we9hxMQnJHUqOowa1a2z
vIVemzrihl+yRXSv75u5SpOfTbNZBXfxyulsT+96Ma62hjtpqF7d1T0Gnvhnuj2E
4pVU4zaKKfTnaNuAa3bqqK26JpglucvtAmr51Y/VmOmFnu/EPlYM2bJ9vKT0DSoE
m/Kuj5xouuf4+W/3w7bYmGnuBpFjTPL/tBGWML5VtU6QLdWRccz/qTPusLHrThCT
j8xNBkipenTzbNGOulDJVCSF6TfFKnX55AxKWQL+SRRonBIhZc5VUAjJ+cFkpmm7
Kl2U1nVnzmv3qmGY9fH7
=sylc
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
