Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab3JLPke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 11:40:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46775 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3JLPkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 11:40:33 -0400
Date: Sat, 12 Oct 2013 16:40:05 +0100
From: Mark Brown <broonie@kernel.org>
To: yi zhang <yizhang.mrvl@gmail.com>
Cc: Yi Zhang <yizhang@marvell.com>, zhouqiao@marvell.com, zhangwm@marvell.com,
        linux-kernel@vger.kernel.org
Message-ID: <20131012154005.GM2443@sirena.org.uk>
References: <CAK=oMXetPxaQ-MeL9L9+182X220ivu2G5+i-42kqtAUjbfvg2w@mail.gmail.com>
 <20131012123217.GK2443@sirena.org.uk>
 <CAK=oMXeyqGcQOOnCmZBfg3GhdmO+uREiGut-L9yk53aQ3p7FZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5fECsWged6836Ycf"
Content-Disposition: inline
In-Reply-To: <CAK=oMXeyqGcQOOnCmZBfg3GhdmO+uREiGut-L9yk53aQ3p7FZQ@mail.gmail.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Question]should we not ignore the masked interrupt in regmap?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5fECsWged6836Ycf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 12, 2013 at 08:50:57PM +0800, yi zhang wrote:

> As I understand it, this "init_ack_masked" is used in initialization
> (please correct me if I'm wrong);
> but if the sequence above happens not in the initialization, then what
> should we do to handle this?
> could you please give us advice?

Just do the same thing during masking.

--5fECsWged6836Ycf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSWW1SAAoJELSic+t+oim9m2YP/3SJ6rWPTP/hFR5Wjg2DX1Kn
cPomadJhfxktaDthvAXjqO7glwSE/jxlp2FjYMsGdPFYXxgwePXLUdgG8XlwzHOr
Il2jVUq5gLUwEdIWKoSlS6/qvKHCdD+gmfH9p59Fk2RrQSO4k8CEu1mpq4FrLQgf
tAbaNZ9+J/XSoStFIrbqHJq/DHCX0WKSQEs3/snw1a1RtELdj4Ai62IaEpecucxY
1U0lQOkj3Flpe34jGzfESDQkkwBXywR0lM/Tea+iKejwXMfsJ6Efsc/Gkvei0C6v
yZecdnTvQIz0/DBDiYduhU7/+GaSo2JVRxyojPMVpCnNkfCD0AItHQVvukUVoyZ7
2yF44z6hyjacNtnXSZcSJttEYoLsmPPweJ9CLyyz3tHDVUgwFhGeNhUcSZC0rfzw
gjbSfqZKj7DUWWemfWkEiDFUl1a43k/8u1kc/GKp6X43Uhebs35eCWoGFhsoR0gK
sCckFuPo+3RyPgwPxn3d16PU08EuVFA5gzBzpbVvHBRl1EJQ/bW9vROwkjtn06Ph
mEMuABjlXoRvdqDhy7Xyf8zr5VkaSesjDVM5ip6j0MTtpyjQdYvBYKOuo3MAxRoO
4fEO4uJ3FRPF+nDG8i0tpE/gjWA14hLRO5dc9SHCJuSlVcwwm3+bwvOtTbv/tA8T
DuLHEMaYLcu9OsmijDFS
=KLpN
-----END PGP SIGNATURE-----

--5fECsWged6836Ycf--
