Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaG2RhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:37:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33266 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaG2RhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:37:07 -0400
Date: Tue, 29 Jul 2014 18:36:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140729173631.GX17528@sirena.org.uk>
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
 <1406651339-28901-5-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zlZIUqJgAFTDhHLL"
Content-Disposition: inline
In-Reply-To: <1406651339-28901-5-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 4/5] regulator: tps65090: Set voltage for fixed regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zlZIUqJgAFTDhHLL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 29, 2014 at 06:28:58PM +0200, Javier Martinez Canillas wrote:

> +#define tps65090_REG_VAR(_id, _sname, en_reg, _en_bits, _ops) \
> +	tps65090_REG_DESC(_id, _sname, en_reg, _en_bits, 0, 0, _ops)

I'd expect this to describe a variable regulator when in fact it
seems it describes a switch with no regulation.  Better name please.

--zlZIUqJgAFTDhHLL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT19ucAAoJELSic+t+oim9efkP/jLMypjv2sfrlLFaC59Lb2HI
99kLoGVpaNqLYEhy2tQ1yGZ3eDVTXXJncprxKjAe1orQ9k1sRC/mztV/fJCWoYsa
fLfrUTJh+4YAxaFSXS5xE3CQwXvkcWHyR2ZViVyDZvJdmNHg1y7lQfhW/RlHWPmq
XUqWg66OkFz2u5y8Bymfo5DD3+5uWenT7gW/hGWohdsXWargj7FC3j60f0hutYJx
AycWkTQt1Dr61op5RWHxI7IZC5CLMvnW+cvzGvvN8biAcsTtry58BOdwFNuutZQj
mxwD4h40uaIwWZBEwKKSR4Cs+k0cOrKrYbiKg5uJXIYKrE6ySs8TfLuA1nVeOFfF
RTUv1bmZp1oY4CaKhWMB9rjcAF3gt8jcfq+tfq44OrtMAn23OSfvwuRy/suyetQh
m3SZNgp0naMBMItvRiVJG4oDWoCWZ+3SsmL817GVg+CJ5Maw7FZvgvp+uj+0YZNc
nQuf7fmglr9uk0xEYYFYPLM4Zt9KlZZxrQtS6bg++8WaUyPSenZzPQzUhUTB2Hbw
hb38W3xz/Yf3RPLIFErEHD6ASufKv/pgbn17KeqJ4uIHTMQIYs3Pc7dvdxDmYh8p
tKNNBsmQV6NYidUeEo7DiqBw+3RfarD+n22jG/2tdd0vVRmDVWEH0NkM7sC7A177
RmiS4xnPHdlg1OBalAR5
=9qdY
-----END PGP SIGNATURE-----

--zlZIUqJgAFTDhHLL--
