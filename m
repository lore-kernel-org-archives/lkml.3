Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbbAUNcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:32:32 -0500
Received: from mail.kernel.org ([198.145.29.136]:38739 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbbAUNcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:32:25 -0500
Date: Wed, 21 Jan 2015 14:32:15 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] power: ab8500_fg.c:  Remove unused function
Message-ID: <20150121133214.GC13715@earth.universe>
References: <1420131892-31486-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Content-Disposition: inline
In-Reply-To: <1420131892-31486-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 01, 2015 at 06:04:52PM +0100, Rickard Strandqvist wrote:
> Remove the function ab8500_fg_reinit() that is not used anywhere.
>=20
> This was partially found by using a static code analysis program called c=
ppcheck.
>=20
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.s=
e>

Thanks, applied with Acked-By from Arnd.

-- Sebastian

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUv6pbAAoJENju1/PIO/qajXoP/jPELH5fzUsSDUS8kb7N++4V
3izCH/kVR/9oumc/LFXID5NfsCLLdbaUGDxyaLqxQeLsEp2D46lvUCbknZMtvbIH
KuYbZDWyh41gl+LHThJdyyy2eHpOjumyq9aMyovRp6d+QaEBcQpJxPwO9TRmc3cS
79Zu9atH2AjwjHzIdVRQqec4khd07/m2VphMRg6fqK7Y+RL3rYZ6fko7AHB+nnwX
nzmtId2b1m1rMMR8L9DVgs8gTs9gCtieovee2CpvemkImUVqLpOIqdlSDjNDoAMr
duobqXYH71dvNhOWiLDdrWQrnzPhBSRTurJrQvdyDJopMMgbivQkGReQQP/19pKS
RJBHPegfXS6KnnADruJVZGGGbPhrISC5V0er/PfS9myLbxSpEOhFldRSXfv2tY4b
I9k4kFQnRg5Xxvol8uL7ZIvP1Q9NSdTjc4ZK2erKct0nywvVKIUYVm+cH9rzdphB
vH2/g7iAN3dkPXLgJzJkAlrViSsgYUsBHyfEonxALWizTJK8mCdZZHQnWUn8wKQO
J3jpVNFpHwKW20QjUL4aYDcLFzJ4nerGWduhfUdtU5p38gBOWjf6cDR/L/80QKan
Fj355KFyJxmizTuUnK25A82t7Z4zgbYCJb/ZO1SAIAs9q/K5H+rZD0oz4XV/Af67
Q3xKfzK0UV7gBmdcQtlW
=sxc2
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
