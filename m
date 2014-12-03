Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaLCBYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:24:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51140 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750884AbaLCBYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:24:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <linux@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: linux-next: manual merge of the pm tree with the arm tree
Date: Wed, 03 Dec 2014 02:45:35 +0100
Message-ID: <2220221.lsImPz8V5G@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141203121235.3eabd77b@canb.auug.org.au>
References: <20141203121235.3eabd77b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4808115.MsWV0D8ghN"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4808115.MsWV0D8ghN
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Wednesday, December 03, 2014 12:12:35 PM Stephen Rothwell wrote:
> Hi Rafael,

Hi,

> Today's linux-next merge of the pm tree got a conflict in
> include/linux/pm_runtime.h between commit 3fb1581ea1ab ("ARM: 8199/1:
> PM / Runtime: Add getter for querying the IRQ safe option v12") from
> the arm tree and commit 6d14dd40f550 ("PM: Drop CONFIG_PM_RUNTIME from
> the driver core") from the pm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks OK to me, thanks!

--nextPart4808115.MsWV0D8ghN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJUfmtJAAoJEILEb/54YlRxr0sP/ipBaAFeOR9SmnFwTD0p2hgL
ZKH/qy+MmisU9pFRjTQ24fznCJTfQuJi/lc6QczuKFDZhyTgKEngeD4Z5io3jfbD
crTnlF/6Bx5NxDJtJfio2Gwzssj0tueaNPkUz9EQVg/bwCVykmx7UKLnP1D42h74
dRioncG2fgiZ/0tkj8x9t2pD9WLlz/2lDYPQEcU4KTMNljT/t2+iFsjAj5uCoI2h
fKr2NzGDU2srrFFRw/Ipe/Svmzm00SZAcrTDtqWhA0EnYgcxHWluprKUh/Wn02xd
ng6hYkaW2X3RIvK34Avpz7/M3SGwcNIJV4CB7UXh7HdxHJZ3/H2Rb7rp2lu8OWSL
8Q7/WpRzkh2wktPVD/cmTU7F5H09Px2DQTs58Q7rXMlMqSKpsH61jInoCwkUikT1
WUlKzPNe02lNQu9TfgfjF/D0FgXIfcaf3inPhXrJMWcpGJ9mYzzmiArNMpYt3P5d
s7Jt+E554gdYgaC/IQMaG/nF++BUtyroO+RHBwMV182JHWE3Ox1PkMwNBzZDcSBl
eoirxygBHIAHd3RpXh7rkzkmJz5oXjA+jlN+ltnCEcFNGirCVUVnSkcbJnEJZRej
joeF+02gsZhQpD4e/D/8QGPKcN9JydIO1MUy90StUlR2N04f68Nqyy7DP5aw8LOs
oawwJE9sSQ/IBQ6tO3qM
=Ew2c
-----END PGP SIGNATURE-----

--nextPart4808115.MsWV0D8ghN--

