Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625Ab3BSXV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 18:21:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40740 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab3BSXVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 18:21:55 -0500
Date: Wed, 20 Feb 2013 10:21:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-next@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: ARC Port's linux-next URL update
Message-Id: <20130220102147.dc301eef8d32f0a88d066794@canb.auug.org.au>
In-Reply-To: <5123C036.2020202@synopsys.com>
References: <5123C036.2020202@synopsys.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Feb_2013_10_21_47_+1100_AS2nMu1irSXBgkAf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2013_10_21_47_+1100_AS2nMu1irSXBgkAf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vineet,

On Tue, 19 Feb 2013 23:41:02 +0530 Vineet Gupta <Vineet.Gupta1@synopsys.com=
> wrote:
>
> Can you please point ARC's next tree to following:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git for-next

Done.

> This is an exact copy of what I had in github (based off 3.8-rc5)

Not just a copy, but you did the right thing and it is the same commits.
Thanks.

> I suppose a week's worth of cooking should be enough to send a pull reque=
st to Linus.

Well, you have not rebased it so just moving sites should not affect
you.  However, even what is there has only been in -next for 2 days, so
maybe a couple of days wait wouldn't hurt.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Feb_2013_10_21_47_+1100_AS2nMu1irSXBgkAf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJAkLAAoJEECxmPOUX5FEpnYQAJPpAaOHbhNrvvqR+p33gHbd
mzOkHPyrdMZ6UVRJ13lV23M1z6kKEi4iINpzw5W0kAPVcIFQJMWekuzWE1lou+Ut
tEZ5SQakKFz7uDmevwXXipcAdbEaQEUZs6u37P+OHYk6uiHDi1kIxbBVj5khk07h
M4GtGE3P9Sm6hO6TN0ogj97bncCcH7hz0P26P3nWuPxmdUx5UqCJ948J8NDk6B48
3YL72PapO33MBkEF6ce5k5Nt7/K3xTu4Wn49v7dg9+04TECtnGLdySoxbBEB+0q/
ttYU0GTQGMFkWJ+LvaU5TEs8vibNa9+0gpcdEeN9lKs4vUB1++b2cWGdK0bbMQV+
WYADFGOyuaFtFIdMGzQ36eCOMHu6QLnujJ1VikVWevwJvhnGVvKgDlaVDpfWGcTe
ipfdrVLbJ6UTj8VLa3DcVZZxFNKBp8EBnHeIjhjaCF0yZqzjpgI7sX3Byu0UJQ1l
JNUKh9EEF9REUJ8VQm7kO3XmK2nVpoT+G5wYqYLMe9C53twfC/uoxdAIcuJtVpLK
+Zcbc5M2uINkgfzPgTD+Ka1h4ad+DwWKv0QLhLgupZGFLJeq6nc7apGiYdfDmyq0
g7+zeV84On2UrTg1ZqQzv77o7gTP0mSIU4a9JbOatYCZ6z/wV0ygQhe7GjRXVLqu
QasS71GO4QOzbAUhGYyR
=CtoP
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2013_10_21_47_+1100_AS2nMu1irSXBgkAf--
