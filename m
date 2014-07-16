Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965572AbaGPRMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:12:15 -0400
Received: from sauhun.de ([89.238.76.85]:58072 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbaGPRMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:12:13 -0400
Date: Wed, 16 Jul 2014 19:12:11 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: scx200: drop GPIO based i2c driver
Message-ID: <20140716171211.GB2759@katana>
References: <1404916029-3319-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <1404916029-3319-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 04:27:09PM +0200, Wolfram Sang wrote:
> This driver is marked as deprecated since the pre-git era. Any user
> left(?) should really have switched to i2c-gpio meanwhile.
>=20
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Applied to for-next, thanks!


--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxrJrAAoJEBQN5MwUoCm2ukkP/iiV5ZNgJnwuALLm7OJy+quh
jn29BeXNisSvuaNv5WBZL0a5bMW3LrDDaksOqjDssZih5q6Sp1NIVPP0uYaxcwxE
+T+g/ac4NqPRu/bEcqO7LlygfwW+lL/kFERMg9ZS1t4CpCxwr+zm76FIgGriVDLm
VTPhh2ehBTQ6gHxknk5fCLgKQZBwpRONNK13LDEmAFQaozgI3oqb1Cod3X6H3T+O
hhf3Bz8lTSsycFEx7mz78ovVKg4o5ygazvdoYmh/Eg5y5fvda1YychJhIPsjoIrI
yF8q44tOV/owtplsIYMcMzz1y7f14uLc/6sCGpai5W2ByAn/Us6vAzbl5/8Cq6DU
3nH9/sfBPkbiSsdQDMohDhIYiCvdgItp2+0d9Vcg0WKQmrvv4hfUMe90NcHx1iCq
+NGUifz5Aef9TCTWqVB7oGeM4CUDGseKJuH6nK4ihWYLosy/X8uuu/lCmze4/dz4
PQDLQsiqBkDsi03zVPDQ6W2g4oS5YsG5Vr2q2/n3ISHnQGcSM2zCBOMBdTHqApuM
rrJ2K+pHOGlZGsV9fbYUqrrn6ZTSlDkshXySg6CSvDNLbzU0aDeIhSRzxThbRW3o
mniQsPencKL11Oip5DJsM0uDrtkCaDIm8KDDoJVt9jslKQUujiAYop6IFwKZDoPz
69z6ghw4RLMhv0z0aIpm
=KQrd
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
