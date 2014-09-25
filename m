Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaIYNaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:30:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58142 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752262AbaIYNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:30:13 -0400
Date: Thu, 25 Sep 2014 15:27:25 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuge <shuge@allwinnertech.com>,
        Meng Zhang <kevin@allwinnertech.com>, ctl@merrii.com,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 2/7] ARM: sunxi: Add debug uart used by sun9i
 (Allwinner A80)
Message-ID: <20140925132725.GG15315@lukather>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
 <1411570141-29960-3-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wQkw7DhpL9hyPo7K"
Content-Disposition: inline
In-Reply-To: <1411570141-29960-3-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wQkw7DhpL9hyPo7K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 10:48:56PM +0800, Chen-Yu Tsai wrote:
> The uarts on sun9i are still compatible with the dw_8250, but are
> located at different addresses.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Queued for 3.19, thanks.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wQkw7DhpL9hyPo7K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJBg9AAoJEBx+YmzsjxAg+QEP/AtTa3/QBVwNArQSpRZ6de2Z
WISnNAU0+diBe07Cqteaj8V0lBs5FzRbItZFEsxXpA4GQ3JUqyFwiv6gBTt4YryB
QDww+eDeprRwAqpPSCeXepwGow0zXNw5aBu/lWEwWVizJmbUIANINbGx7nqKIoHT
L907EzI3RteVh4khd4YA0vQjIoQz0oH2ydmZcMoBCegbLcGA7s74YB37XEVRhG0b
jlds4YwkePOMxvjxjYu6gkQBxez0D55Vfj2TV/27BV7ou3K0GefcPb4oijrUKWBp
/HNik5OcfuKtmPxzwNTDFbfFhTCBikVvNf7cxsMHSNJeIJ+KYUOLmg1G9G0KS7BU
dXtBW9aGgeiMWCVO706yXIj8vJyN4wcczyNGRenGWiU//fo6zP74elsWKvw+SXnj
HPLzK7iAn9q3QZ8M7iB2o3k0KLGS/Qo1/6egAb/CmMwY/cd2VfvNjtYgcZ8EsDeI
0TR7I2/v20xbdt2l5hGNecpvJuz2fxd6hzv1dE7qbD/HaKRGBcDweoBXXCuq5zsN
XbkuRr8UKZzCDksj1eQXsOBS78iT36h3ZJhbrBJV40vCMDGKkgng1E7g/alhnQKk
Re63PrF5n2KO7yXpWKkFkiOqD/TvFt3ymwBQ80x+zKeyBJXjyN3obv+Z8p7Q96IQ
YbSyhQ62PcN4LE+dEaM5
=0jW+
-----END PGP SIGNATURE-----

--wQkw7DhpL9hyPo7K--
