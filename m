Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaCKPti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:49:38 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59013 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaCKPtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:49:36 -0400
Date: Tue, 11 Mar 2014 11:49:30 -0400
From: Matt Porter <mporter@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] mfd: add bcm590xx pmu DT binding
Message-ID: <20140311154930.GJ25092@beef>
References: <1392765432-9111-1-git-send-email-mporter@linaro.org>
 <1392765432-9111-2-git-send-email-mporter@linaro.org>
 <20140219044726.GC2669@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <20140219044726.GC2669@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2014 at 01:47:26PM +0900, Mark Brown wrote:
> On Tue, Feb 18, 2014 at 06:17:08PM -0500, Matt Porter wrote:
>=20
> > +
> > +				rfldo_reg: regulator@0 {
> > +					reg =3D <0>;
>=20
> What do these reg values mean, they don't seem to be documented in the
> binding?

Dropped this and the deprecated regulator-compatible property in v3 in
favor of using node name matching.

-Matt

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTHzCKAAoJEOfTILNwq7R4Pq4QAOgn9SRakbL1zULbyZYH8ucG
ozn7PKiHYzYls/RTxkv+hWIUzwWl6M8bk8UIhfmMulb4xiqzmss82R6VvXGYRFy/
WPNyym4Qz5v4pF1RUWAGph3ApC50NaCdZ9JgkdckIHl/8TF9jOM8T3Jh81RZibEB
KiRqLOxvKCmdkCGFf0eaHmK8pbIbD28UeRg0wFalKbJAIiyfXfG7nbv+CK2519aj
nfykd0U3i+l8LzZvjr1v01Xn7uR+9c7qvqAfS+OCv54okMh4arhx+S8h9IgqEUr9
2sfQRsHnDy3f3+KbCR8+sto1ZIrCTXioX9QdlfI1jp3yFhULLkpAXEuYEk15I/VN
K9W8K9kwt559ziyMoZZIV2zQ1+w/aiamsNV1JQ4Lq2fknANF/fAOitQ8fjnFbo16
k2hQgTI5/eLKs6Sa7R7kjCtoaLj0BKSb8SMyPLH806FbWjJzwMzzK/aBNQPon38v
NuBrh4vvx22pLhOTG3XFTKXjurL2r63V6fsa1r5XT5u5xW3zM0B/XplR5aTKJknl
n0GySjy9dCqrm8f429TVKC08STvmXUdceOMvzhrmTN4FnLc/eALNBjVpG07zlQXN
YCIpV6cFrag0VbuDbRk1dn2SqP8MBvnzch8QSrDyXNmpQOSc93t1wDeweQHkYnFU
m/364ITsSAfvdS2TEEwQ
=2mUN
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
