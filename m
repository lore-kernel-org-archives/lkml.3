Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaIZAnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 20:43:42 -0400
Received: from ozlabs.org ([103.22.144.67]:41242 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbaIZAnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 20:43:41 -0400
Date: Fri, 26 Sep 2014 10:43:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: "Kukjin Kim" <kgene@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
Subject: Re: linux-next: build failure after merge of the samsung tree
Message-ID: <20140926104334.5252e513@canb.auug.org.au>
In-Reply-To: <20140925230124.19023.33551@quantum>
References: <20140924110836.209bc8e2@canb.auug.org.au>
	<00fb01cfd7a4$45eb4a50$d1c1def0$@kernel.org>
	<20140924155336.6e64b952@canb.auug.org.au>
	<20140925230124.19023.33551@quantum>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Ir1Ne.yFFw2Cc0L_UJ2IsyT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ir1Ne.yFFw2Cc0L_UJ2IsyT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Thu, 25 Sep 2014 16:01:24 -0700 Mike Turquette <mturquette@linaro.org> w=
rote:
>
>=20
> I saw in another thread that Kukjin merged the clk tree into his -next
> branch. Is there anything left to do on this one?

No, that fixed it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Ir1Ne.yFFw2Cc0L_UJ2IsyT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJLa6AAoJEMDTa8Ir7ZwV71cP/AtqV1XdraAPUWSEvLZlds26
8V33kMecdAevjkYi74HbJnnps8vLeLWBUcuNIGWKz56xb9PgFtv1pBvC63M/HPPc
rWPNG/Bi5Fgc9N/XlF768BqsN9jOs5h8lIgRKBzNce+gW6d14VhYmdPd+1hFsfCC
D+C+/hM5EMV7/WCnzSgHpbEN4UJxTFC89mQs9tuJbW8rPR1LIGWsgwki9z6q+vES
xSQ1mHiZG+XlKRksh5KipN4ymoNWNMU2436LQ9ktTlKOxl/jbSQtlmsfpiOkBjZX
aDb0zLSkyk0+A6RMAMJS+76/2TXrxjI6/p7RNh42zp07gdOCEpBcVU9qb+jhunhI
bi9nSUDZZtNsxPA4cABlSnRDaj6WJf6EmkiwXjuQ+n4/ZxOMp1YlxNOheHobnNrX
YLs4NffrEcfit47KNDEOozlimQnDFic/v5sgRVlQBUMcJk1z9a9zdwbbd3MJnkqY
4LAApTH0IO8ZBEDvCRbL2Ez1w8QbJV/y8pnSGZZYDi4EvsO5b21K5FSBOczzt2PA
JKjJPxq3KIC9qPHLoMOD3ibqBVRtzKkEfh4kcPvlzVMhSH15ZRT9kDTFAekHZy6Q
RRgjGL/CdOJ7xVMC4d4VzhG+/mn52+TQ9DgJzoSxaQ98lQRINLC/lkY6i5c3vDGV
3xkXKuqFKcKXlC3IeH2L
=G73R
-----END PGP SIGNATURE-----

--Sig_/Ir1Ne.yFFw2Cc0L_UJ2IsyT--
