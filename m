Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaENMfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:35:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46094 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310AbaENMfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:35:05 -0400
Date: Wed, 14 May 2014 14:34:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Boris Brezillon <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH RESEND v4 0/8] Add Allwinner A31 USB support
Message-ID: <20140514123419.GK29258@lukather>
References: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O8/n5iBOhiUtMkxf"
Content-Disposition: inline
In-Reply-To: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O8/n5iBOhiUtMkxf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 05:44:14PM +0200, Maxime Ripard wrote:
> Hi everyone,
>=20
> This patchset adds support for the USB controllers found in the
> Allwinner A31.
>=20
> While the design is similar to the earlier Allwinner SoCs that are
> already supported, a few details here and there change, like the fact
> that the PHYs now have one clock per phy, while it used to be only one
> for all the PHYs.
>=20
> Resent adding Alan Stern's Acked-by and puting Greg KH in the
> recipients this time...

Applied patches 2, 7 and 8.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--O8/n5iBOhiUtMkxf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTc2LLAAoJEBx+YmzsjxAgVpcQAJgPMxLYvZbaoF58pa1oHZve
jxdMWCHz3Xx3hzuJ+XRTfJuT77B1WiJT9EQpCmN82EbrsjgVpCS87lthzSV6gGni
CJcHbebWyTQHCJp7hGeo7LIt8NK8rXwl/wNPUUaIRYaOH7yxXNZ40S/efFec3TCO
9S0My7+B14KKlvbncllYruLZgXhRSkPaYt19JNm+EG/XNiab93k1VbsGPcmVV/RS
OEA+pBqQDt7CBO70Nh8YHyNithPkqdNGaaeBbscrVeOodXoyr5NhAfAldulOG+L5
uRxcabqDdLEf6scJUwT4NRhS7jwJN8oBcCBzZf6iGI700H2Peoz/xZ5Q8RX0V1VE
TXmRKsId3dEFFj3HAlP2DdLZZOUH/qwNfRuun1iA9X9/irDRh/xWbTlCKywq2WqX
CbIWOGcYDNiJqNgqCtnAeMoN2u7ZRmTLl35snWLoMTCHnk8fzeAgnJk1Q3FVvs/z
b45CyQxq1T/KI7Pz9PH+jHVs/6VaGqUzpVLxABCCMm7rVH7Im0tl7nd4+Yl2B+LU
z5vQqefBxac53yJC3ZmIAeSV0Le6m9hRLMnM3v8ZV1U9xE99dEt0xQbLJQfNoBwf
FGejHd8pZxHgpxnyJjmDAxXsYkYgWIzbsKns2ogLWsi4VGXu0xnaSFuXlthwzTKr
6Q+Ei4HV3Q1SJe2l8v/a
=ZNex
-----END PGP SIGNATURE-----

--O8/n5iBOhiUtMkxf--
