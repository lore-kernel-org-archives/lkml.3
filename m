Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbaKRPSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:18:15 -0500
Received: from sauhun.de ([89.238.76.85]:45817 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909AbaKRPSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:18:10 -0500
Date: Tue, 18 Nov 2014 16:19:27 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Carlo Caione <carlo@caione.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH v3 3/3] ARM: dts: meson: add I2C controller nodes
Message-ID: <20141118151927.GG30004@katana>
References: <1415907123-4318-1-git-send-email-b.galvani@gmail.com>
 <1415907123-4318-4-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7uYPyRQQ5N0D02nI"
Content-Disposition: inline
In-Reply-To: <1415907123-4318-4-git-send-email-b.galvani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7uYPyRQQ5N0D02nI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2014 at 08:32:03PM +0100, Beniamino Galvani wrote:
> Add nodes for I2C controllers A,B,AO, which are available in both
> Meson6 and Meson8.
>=20
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---

I usually don't take DTS patches. They should go via arm-soc. Please say
so if there are reasons I should take it.


--7uYPyRQQ5N0D02nI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa2N/AAoJEBQN5MwUoCm2dxMQALJV9jfj0AxVKMIKBOBhd+3Z
GHhiBCDE8OUG048ZA0UN10CK5oWuKH0cAjiPNkrVwNslljkb0h0OgDiotm52+Kop
hwiJUxJHevq6QkQfyYNTvc9qZxJhXT2DFGSgcSND6mjddvgxnC3JVrbyYokU4Swq
oizbF3Jcmd53SvioTH0YvgTG1+m6i3JOTFC8anfvjdRdxQZl7Jk3uPTSYj46IxcG
s/y7yjH1BK58Q8A5yKmNOPfoR/I48OLu0q+9gnP9AZ2wxiptBbAgWGMhm/cuEQv3
T9wneie6x+jBxRtHquSnfTcdkkccUthAzE24nq56FpepjvUnOkpucAsbAyKtMAC3
EFKwQbqfWh+C6Ij+Sxv6NhLVWZmzb28JYyO6yRJpnO7IyiE4FWWAweS0Wn2De+WU
4WHSN3wwq9eo3lCoS5wVFeUweVrhXOEFYsHjJfobuxKg5vW7L9uD0I3MPcaAqsU3
1i5L3cVOO8ZjBQdNf7+hvtNOa4CHFHFcZoVyzhfOQPsJZMMtlOyve//juXrd092p
iXfitCC6s/6UzOwBcBpX6X3oNalEoOicDQiK65BAhTfxthLiH3TjNIPG1U3KyY+/
kiZY9DuoAGBs2/QvXQUbCxf+czz9fJYkDvvECtWX14pxI79MkgpY84x32JvokJvX
T/0MLgi9KmSCfcX5ZjXg
=xGBb
-----END PGP SIGNATURE-----

--7uYPyRQQ5N0D02nI--
