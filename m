Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbbA0PX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:23:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42503 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbbA0PX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:23:26 -0500
Date: Tue, 27 Jan 2015 09:22:50 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH v3 0/5] Add support for Fujitsu USB host controller
Message-ID: <20150127152250.GB13776@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422173608-24355-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <1422173608-24355-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jan 25, 2015 at 04:13:23PM +0800, Sneeker Yeh wrote:
> These patches add support for XHCI compliant Host controller found
> on Fujitsu Socs, and are based on http://lwn.net/Articles/629162/
> The first patch is to add Fujitsu glue layer of Synopsis DesignWare USB3 =
driver
> and last four patch is about quirk implementation of errata in Synopsis
> DesignWare USB3 IP.
>=20
> Patch 1 introduces a quirk with device disconnection management necessary
> Synopsys Designware USB3 IP with versions < 3.00a and hardware configurat=
ion
> DWC_USB3_SUSPEND_ON_DISCONNECT_EN=3D1. It solves a problem where without =
the
> quirk, that host controller will die after a usb device is disconnected f=
rom
> port of root hub.
>=20
> Patch 2 is to set Synopsis quirk in xhci platform driver based on xhci pl=
atform
> data.
>=20
> Patch 3 is to add a revison number 2.90a and 3.00a of Synopsis DesignWare=
 USB3
> IP core driver.
>=20
> Patch 4 introduces using a quirk based on a errata of Synopsis
> DesignWare USB3 IP which is versions < 3.00a and has hardware configurati=
on
> DWC_USB3_SUSPEND_ON_DISCONNECT_EN=3D1, which cannot be read from software=
=2E As a
> result this quirk has to be enabled via platform data or device tree.
>=20
> Patch 5 introduces Fujitsu Specific Glue layer in Synopsis DesignWare USB=
3 IP
> driver.=20
>=20

Mathias, let me know how you want to handle this. Either I take them
all, or you take them all. What do you prefer ?

--=20
balbi

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx61KAAoJEIaOsuA1yqREpJIP/0qd7l0DX4/2yFZ59RADw2D7
J6Z4lDVgJmgFrho04qp9Wax3ExF9VWlKUrP/uXVd9ud3YZTSGXOMtWCQmZiTOyzo
GH1ABqqoSPZq6ECt7GDEkwDe7LQEM4c1iRhvUPHwz6b8OPrZZs167VsbnOr831FA
i0uoUxejYYr74nvUPMw151G0DErby+fhX9lUiv/l6JdnYZjBA3945FDsAGguf6AU
DXfBz2eCBznupLuGI//BnEuLDUvzJdTUH19fu6PVTKdJbGlCmhP/wCRQ5fGDr0Rv
/+R1H8Lb5nRNzu4xaQ+FA0GRz4kCsUQTdrtNsrw5Uok5lBG2p1/eq/jejo8xmlNJ
pW+ID6ey4dcppW5eAyC0q0dMUw4Jz/EFUKjeH9+yYKKbgaFqT9HXT38uee5lCaFn
7Uf13TC+A5mBObl99PqwdOZC/1edX7wLNLao2Fcf7+kbCzxN3pXP/vI/6k+z2Ick
XZyU+4si9zeGzF2+7qADGgioSEp4BWCe19PIlCCejqywH2+w2MUd5vih+ArUpcQA
JojAwpZcuBi5AQNQQpCEVo7JAdpypxoXbbLymuyhK2c07kczRw/R6cmF50QCDy1i
8yRMkZEN9LyUXr+7aDHggr+s6wYWDsdSkryrLxNQaH0SomRc7Yi83AF8d40Yb6hB
QrtfgmJ6hFIaIHaDqhBI
=zZxd
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
