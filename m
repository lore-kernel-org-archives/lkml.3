Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbbABUeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:34:22 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45230 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbbABUeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:34:19 -0500
Date: Fri, 2 Jan 2015 14:33:20 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Dave Gerlach <d-gerlach@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Benoit Cousson <bcousson@baylibre.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2/3] soc: ti: Add wkup_m3_ipc driver
Message-ID: <20150102203320.GF4920@saruman>
Reply-To: <balbi@ti.com>
References: <1420228817-41310-1-git-send-email-d-gerlach@ti.com>
 <1420228817-41310-3-git-send-email-d-gerlach@ti.com>
 <20150102201643.GE4920@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ULyIDA2m8JTe+TiX"
Content-Disposition: inline
In-Reply-To: <20150102201643.GE4920@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ULyIDA2m8JTe+TiX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 02, 2015 at 02:16:43PM -0600, Felipe Balbi wrote:
> On Fri, Jan 02, 2015 at 02:00:16PM -0600, Dave Gerlach wrote:
> > Introduce a wkup_m3_ipc driver to handle communication between the MPU
> > and Cortex M3 wkup_m3 present on am335x.
> >=20
> > This driver is responsible for actually booting the wkup_m3_rproc and
> > also handling all IPC which is done using the IPC registers in the cont=
rol
> > module, a mailbox, and a separate interrupt back from the wkup_m3. A sm=
all
> > API is exposed for executing specific power commands, which include
> > configuring for low power mode, request a transition to a low power mod=
e,
> > and status info on a previous transition.

another comment is that no user of such API is provided, so it's very
difficult to verify that there's no other way of implementing this.

--=20
balbi

--ULyIDA2m8JTe+TiX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUpwCQAAoJEIaOsuA1yqREvggP/1asB6h3YrByu8+OGhCJyXEc
xTx38v1xEuQ+OKdU2+NXW+/PBOfFe6riiJxYbK2Lk7ylq8Wu9lFFpzqQanGXNWJY
Gec7hCkOMmy0MrNBHDVlMvwzL+O5V/Om4VdtEP/6z0cFRMq3IlmJHPBMkpqTlJ72
8ICsljnEwH2d5xjYJ/JrXApG/8bNQdoGeVR6zt6Wm9lezd1MlVANQPTd/HRYyQFU
Mk8P+ALBZb6oc4CKMKgxNBW85ufr2IQw3Z/I75mPoWl/KjgWa6tSaSH1iuiwlXcl
SL1B/P6IS0FiJZ48HHgIAJWC2fgQSMGDQWEaqU3pn0DZ4ZJOqpYlGSQpSUH0e6oj
cyFXrZL+qOgSmN4FfR3zpoWykgOV09+BHTj+o/7n/QFRjOpvY79juSKr8IpxKe5h
wRsl39m964sCItaYAWzUGL8ITgbclZ14j59CX2OuHKW7xNYvWxYfUz400NWuRzew
SjhwaBB3Ob31KWmhyrfl8w7Krelpve2D/mf5HXebiylUVDEV4f13xcP4pp3/X0iP
i0dNLI5PX5JhUNVPwslGM/w+AXcGDUM4hdFudXWmnSAHwfSXwnDfxVI79ON9qASi
DnuDIE+P14xbPIIpaXyXwejKEwOl6gt07Isla0UFqK1ctm+j5t8LNxbcRXE3EOfE
AHFQoWO3U40MGkvrwMIy
=3hJe
-----END PGP SIGNATURE-----

--ULyIDA2m8JTe+TiX--
