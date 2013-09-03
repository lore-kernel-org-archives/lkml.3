Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab3ICMY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:24:26 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:37734 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3ICMYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:24:24 -0400
Date: Tue, 3 Sep 2013 14:23:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] gpio: Use proper indentation
Message-ID: <20130903122337.GA3063@ulmo>
References: <1378204768-18013-1-git-send-email-treding@nvidia.com>
 <1378204768-18013-2-git-send-email-treding@nvidia.com>
 <CACRpkdZth+7FZbcSwTUSug9cCfw8xW3XVbaUv3dEA_cTuFX8Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <CACRpkdZth+7FZbcSwTUSug9cCfw8xW3XVbaUv3dEA_cTuFX8Jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 03, 2013 at 02:11:39PM +0200, Linus Walleij wrote:
> On Tue, Sep 3, 2013 at 12:39 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>=20
> > Indentation should be done using tabs, not a combination of tabs and
> > spaces.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> > Linus,
> >
> > Feel free to squash this into the commit that introduced these:
> >
> >         fc9bbfb: gpio: improve error path in gpiolib
>=20
> This part I actually fixed up properly yesterday, but thanks anyway.

Yes you did. I was impatient and couldn't wait for today's linux-next to
show up. Sorry for the noise.

Thierry

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJdTJAAoJEN0jrNd/PrOhE+sQAL52E4DetJVJBLuO+6w6FhIJ
9V+SvzavjeKAhmHw0ioJikeSupnKJyezuexbmuPb3YIkCwYU3slP7bJ9/2XNLRNN
lrykBKqgP8diH6LVmdu4+0E1Wk7HDdoceKKOZqZmjS5KE0fIHyOZQm0d06rcX6Cr
OGJRw6QJeeAOz1lEClWhGIA70/jtzhoeQnFiDpHbZmaIgOTGq7+uzSShyWqNcGyB
QjMeFrbqp2zwXL1SNQ8I/9JcRyfV01b43Y7IdPg+huisnhDQxJEXoDZT0PrPXgEY
44SWZW741gSpB+eUxTG8yG7FYxvCT3ujXqDr/F6TjfPZ2buYnkGya5pBMAfw0n7q
7vGKGGiOadjR6vChhJ8ctU5sNrSiFYgrasL95EKZ3SyrR+vknpCGaVBSQf6oWNO+
CPbcK/JV7idAbFFoiuGtc4MEtk1wxXCpS15j2GYyxCNNZFlOA3dp7mZxSkwWZUyJ
V8b+FifZxkcKwoLfzmiW0Zh8BJCsHL0yj9om/j90vW/kcIsQ4DCAEk+7dJCU/5WY
AiLTUYI384T5zWBgonvHBoMa1aw4KL7H2fkbTd8i4xjAsawRUR1bJP6ECPkw80SH
VjVQSYlK3Gjc6nDJ7++9obb9jVdz6h1oxYQlP6EjLjZWuHHdtn1TbzeFyAaGcNu8
D5v/6vM++VYZt9+hFMlg
=F6KB
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
