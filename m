Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaKLUaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:30:06 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33927 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753190AbaKLUaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:30:04 -0500
Date: Wed, 12 Nov 2014 21:29:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Roman Byshko <rbyshko@gmail.com>
Cc: linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 1/5] phy: sun4i: add support for USB phy0
Message-ID: <20141112202927.GB20972@lukather>
References: <cover.1415645258.git.rbyshko@gmail.com>
 <997f1e2744504f3461f9e94e2171180b5ce87aa2.1415645258.git.rbyshko@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <997f1e2744504f3461f9e94e2171180b5ce87aa2.1415645258.git.rbyshko@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2014 at 07:55:06PM +0100, Roman Byshko wrote:
> The driver for sun4i USB phys currently supports
> only phy1 and phy2 which are used for USB host
> controllers. This patch adds support for USB phy0,
> which is used by the musb hdrc USB controller.
>=20
> Signed-off-by: Roman Byshko <rbyshko@gmail.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY8MnAAoJEBx+YmzsjxAg0xsP/3tyScQX+ROwSlyxFeY8ERCC
nZ2yJIv6OCJ7qovOeR9SrfLsbsBGtrjXLvVk0lRaqCp6neIWHCmRM7E848jzSV0z
GBSRW6uAJpilzlg/HOsgsGkVdvtCTB9ZEzQNHt7013oT9PO/NRptBSXSdTpGvHhx
WQqxE56PWU+En45OEvjQXTOIf3cw0iHOfgp9Xby6azFy12wnThUak/jIwu6Zdiqy
9yohFOoDq1vj4pac5R/c5y2UDDS1M+UrhF2nJ9wlIJJXiIGllu7xi794TlpQmfJO
GxqD2xHZgKsHwVRd7Yp7HpDQelVJ1HC3po1UVx0MmPTx8hXsAQr5LBcH6UIsN1Wp
Rxmh6RM0jJsmXfLPDcEqY9UizuvgNFnfDjj/q4wQwWNVhtrQ8Qnsi+tSnyGgUOSe
WRRw2mF0FbUCxCsIf+v+xdSkk7HTwgPd3PHp2qo5QC/s0Ise2z4A+POBEd6Ij0qM
EA0TXtMtxDXlXq1h0KxF7vvLWaBoZ38G9aF4Ow9cg4fyG3slE/KpKolQOpLlYngo
P25ZVZL34V3QwpXWkizHOVU+1IL8ldRPlH7nzU4wu/QjAIA0l+oM4o8NDoMIpmw9
80ZyyiZLEknPhQky1VtrkH3RMPXkEfsbssHTD4SpDDHw/3MEKTNrwlHdC8K8eNFJ
w3LYMYssdI+UqF3SM+8j
=Hifw
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
