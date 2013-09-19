Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3ISMHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:07:36 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:54961 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3ISMHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:07:30 -0400
Date: Thu, 19 Sep 2013 14:06:17 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] pwm: atmel-tcb: config fixes
Message-ID: <20130919120616.GG10852@ulmo>
References: <1379516720-23289-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="reI/iBAAp9kzkmX4"
Content-Disposition: inline
In-Reply-To: <1379516720-23289-1-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--reI/iBAAp9kzkmX4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 05:05:20PM +0200, Boris BREZILLON wrote:
> Hello,
>=20
> This patch series fix 2 bugs regarding the pwm configuration:
>  - the clock source of the timer channel is never applied
>  - the maximum time that can be represented when using the slow clock may=
 be
>    wrong if the tc block provide a 32 bits width counter
>=20
> Best Regards,
>=20
> Boris
>=20
> Boris BREZILLON (2):
>   pwm: atmel-tcb: add missing clk source config
>   pwm: atmel-tcb: fix max time computation for slow clk source
>=20
>  drivers/pwm/pwm-atmel-tcb.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Both applied, with Nicolas' Acked-by.

Thierry

--reI/iBAAp9kzkmX4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOui4AAoJEN0jrNd/PrOhdAYP/26c9eKSN1e/fXmDhtUdvAjM
/+b063GuqZzKuJOe2OauVhFG5GxoieHgChDC5ozlcF0tkWTU0d18czjZPJBFmE5Q
1HSx0oVtmfJNUhVBheUuln+ouuPL7m421Mqz9b7/uhxUdCGfLMbQqrKUVGtcb+tZ
MzjZ/7BM+l6D9xhWTeBkhh2tPfDjVw1AiTZ5zhO0xtSkKbHuj8/kaT1hgHZdivOG
pGVIAndVtloflPX405eZkqI/9toEguDukX6MJ2R4/JmEzAkb/MF5Pgb8woWT2GDJ
hxo3oFskWBC5Gk9StagQq8Cvr1SX8ehemK14MMdbK+S0wcV5p4NN1YK6ZdoUqN6z
fwy1v5kiUAxmm03fOAkmo5f5gqHRRhMFIUCpBQczmRK/k5Lo9m4YUWG5cV1BBqhq
0yN0dGFxpt8TQgGGpsrM9qFx5eqHLB0zlGZLBjBI6HkdFpm5CoiuUJU/6wyskVhI
WUWpC6262TeGLxX7sI8qjCIdrL52O8n+8LTNuOvZzqXsAbfZU6xFIEJmrXYfznLP
aEmQRUbs++is2H1x88P58AddWEXtgvmddbbFS0Vg7dX5G/EGqW7WZwDmRNR7gtsS
ZdnYFQBcuhXHEfFAuhBvIl43Yo6VjOUjprSWw4U8UzsIsYFKn2rR8pZ3aQdfHp8j
1Pffk8qreLvp+Cj8A3pw
=AM1m
-----END PGP SIGNATURE-----

--reI/iBAAp9kzkmX4--
