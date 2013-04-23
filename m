Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3DWPPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:15:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46516 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929Ab3DWPPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:15:15 -0400
Date: Tue, 23 Apr 2013 16:15:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Girish K S <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Subject: Re: [PATCH 1/3] spi: s3c64xx: added support for polling mode
Message-ID: <20130423151511.GR5019@opensource.wolfsonmicro.com>
References: <1366614565-3743-1-git-send-email-ks.giri@samsung.com>
 <1366614565-3743-2-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CPn8Wy5ME997YUMW"
Content-Disposition: inline
In-Reply-To: <1366614565-3743-2-git-send-email-ks.giri@samsung.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CPn8Wy5ME997YUMW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2013 at 12:39:23PM +0530, Girish K S wrote:
> From: Girish K S <girishks2000@gmail.com>
>=20
> The 64xx spi driver supports partial polling mode.
> Only the last chunk of the transfer length is transferred
> or recieved in polling mode.

This appears to have a very noticable negative impact on SPI performance
on my S3C6410 based system.  Not delved into it to test why but are you
sure it's not mistakenly selecting polling?

--CPn8Wy5ME997YUMW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdqU0AAoJELSic+t+oim9j0AP/2LSgiYibWqYsCJ2WrIZDmIT
P41YOwSxixxvigSChfLHivoP8nUrhbXGjQDL+2ZWBV1dX+JA0YTOqsVCxRY/LCMR
wa0PJJzL22AJ5cEd4LdEX5Ejwq2HJplTn1i6C0q2X0hy5zFxfR+wxXKwNCxy4t7w
uqKAwBwC52wQSm1Q67ASzYmPufxsAaNj90ikeFvxVT8ggwXhRN5dECnNZl11hUcy
w8E6DVEcNcVzj+gxJLxBpqzgki/iGemhp7FLGZ1/SdGV5QjGJyak3CxVbwb/dk/Y
rNhASRAFaV7bWE4xj6CyNDhmjc6l/cCcsKwKs41hXBfsTtM1pVauBuknFfu1j1vE
NinclKNCpiu3UrP/bU7HZWVzV+cIZVrqOFIgP+x/MP8WHJalLXi2U7hM3iZPnElH
o8SMGp1t/PqAtd/sw7WnAsG7mQ1mH8WQZitReyluMKwxs2khBNORFDIHpgnvPJML
Ek44rzsp6CEd1sqFRyhVW8VaOMPdofoYRG6sfP5yuDMj4/TgByaNnhmTLFr1rxnm
EGtTaDOwAX2QIzgsl+Az0MHPqu/GEWzOm8xE1HMccD8wcSwyMaMHUttbCh1Qzj7k
iHHgGyzocp45+DCGXkvERSovVrZ1q1Yr6hoqyr/bVB4+baNuSkTin+eYSXQyft0C
i7ikPoMuPzUUy64qtrKT
=EGxO
-----END PGP SIGNATURE-----

--CPn8Wy5ME997YUMW--
