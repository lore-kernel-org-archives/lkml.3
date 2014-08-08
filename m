Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbaHHQuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:50:52 -0400
Received: from sauhun.de ([89.238.76.85]:45900 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757513AbaHHQuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:50:50 -0400
Date: Fri, 8 Aug 2014 18:50:47 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/14] i2c: mpc: delete unneeded test before of_node_put
Message-ID: <20140808165047.GB2847@katana>
References: <1407492475-26283-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <1407492475-26283-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 12:07:42PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Of_node_put supports NULL as its argument, so the initial test is not
> necessary.
>=20
> Suggested by Uwe Kleine-K=C3=B6nig.
>=20
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> expression e;
> @@
>=20
> -if (e)
>    of_node_put(e);
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20

Applied to for-next, thanks!


--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT5P/mAAoJEBQN5MwUoCm23oEP/3xaDlEmZcHGxlguV81zvj3u
BWLPGXuz5/hZ055G25tTcHifj/GdJCKlx5cGRm8LiYmbmbOyto709UhlEGgYmP8B
1m9fOM2tHQRSb6IpaGfsHORC1RNLjZuUoZmiAvPk+TDEKuhOxXhq3tXBPuEDfZPO
uM7ceUeuZPHMaWc1jd20ol0umxEzMMwMJJNG6lZbqbbHrh0FwSyDOkGcrvbulZt7
q3gUO/ndxL6tx2ob2U6ysxUKQawys0PVG8LI/KGienthaG+d2nDQMm/9eDjv909g
v1RJqpSX1kf9tg0hG+loW6Lzqxrxm6pteFkFNRrj9IY78D4mWw/3Ur8QD7BJLvSA
3mAzKZSmcdqE5azxVzJkIRgRV0n9pSsz5Jr2rPo2evGg16+lB1Ok+LCfZ+KTMUpo
zXVKi+ntWEjj5LV3KbRVwkvPtwic9QznIigM6H3ILAAAFyMlWTAJG4lxyWqHb/Fk
pRWLakRT00stH698XozvCo9O036laXM2jIiZER0TYcWyN6fBgbde47sg17weYvrZ
gUTu1OyY5gKjzxCb5O1ekxnH6Ca9HoJoGo5yVa7oTH8O3Jo7oPnga5DPvSDbWDwa
eu3sgd4NKETNcfsV8JDqk1JmYWlARNL9HK03cjGTROG/+VRJE3wUangM11dDCbrD
uZs2GF+V8QHJn33NmHBi
=U1nD
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
