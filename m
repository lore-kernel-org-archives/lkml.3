Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbaEIJij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:38:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45837 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaEIJig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:38:36 -0400
Message-ID: <536CA1D4.6010605@ti.com>
Date: Fri, 9 May 2014 12:37:24 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <plagnioj@jcrosoft.com>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>, <hns@goldelico.com>
Subject: Re: [PATCH v3 0/3] Add display support for gta04 device
References: <1399580212-5183-1-git-send-email-marek@goldelico.com>
In-Reply-To: <1399580212-5183-1-git-send-email-marek@goldelico.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="edfPGatkwflS48KB5oIg0SrJaxCV8TVle"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--edfPGatkwflS48KB5oIg0SrJaxCV8TVle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/05/14 23:16, Marek Belisko wrote:
> This 3 patches adding display support for openmoko gta04 device.
> First patch add DT bindings for topolly td028 panel. Second add descrip=
tion for
> dss + panel and third fix panel probing when panel is compiled as modul=
e.
>=20
> Changes from v2:
> - add missing 'port' node for dpi_out endpoint (comment from Tomi Valke=
inen)
>=20
> Changes from v1:
> - extend panel compatible string by 'omapdss'
> - add tpo-td028 panel to dss_compat_conv_list
> - add MODULE_ALIAS macro to properly probe panel when is compiled as mo=
dule
>=20
> Marek Belisko (3):
>   omapdss: panel-tpo-td028ec1: Add DT support.
>   ARM: dts: oma3-gta04: Add display support
>   omapdss: panel-tpo-td028ec1: Add module alias
>=20
>  .../bindings/video/toppoly,td028ttec1.txt          | 30 ++++++++
>  arch/arm/boot/dts/omap3-gta04.dts                  | 87 ++++++++++++++=
++++++++
>  arch/arm/mach-omap2/display.c                      |  1 +
>  .../omap2/displays-new/panel-tpo-td028ttec1.c      | 33 +++++++-
>  4 files changed, 150 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/video/toppoly,td0=
28ttec1.txt
>=20

I think this series looks fine. I'll pick it up.

 Tomi



--edfPGatkwflS48KB5oIg0SrJaxCV8TVle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTbKHUAAoJEPo9qoy8lh71xSwP/31AJ6WQVmWybr+czhxNILov
A4aO8T+eHPG3mz8RqfwC8ibxPpSiqqJfbr+gz0Cykx5uXokU0R/1XRofpDbIorY8
cvG7kSf3mpFh6juYU3LlK6kA/BJMttf7ArxIr0Dutg1dESMSrH+LpN5OkmWRH7ef
fmbUBUndWc5m9vTD36IO2WQiqXBiaAMsUYHf5mbra3OOGivM+F91pj6jyEBUgHEG
1yxtSTahHbVl4Ztsyj5/aATW/knzZJXCGUtGizUn9HFqfH8USB42j2TroIIGzn71
BUma3MOGMusPmgG2MOvJuj8SKKElynbxR/uFfdnKTz+/3Ff2GRC+ZIyHNu1hTsNE
2Iu4ID4AFZgC/u9H1FAHgoAITzhz9w6YyruaZFFtqVtRrpAzfJmk1fFpVKVSxHDD
BhCtqRZS3+Ma9fxr2/ygRjW3V2cdRBUmVFN4HnfkMGXMNSZS/h3koCRSYnHjH49t
N88eS14y8yRxIJjEdWFAa4Z7jy1IqvpB2RGxMfJIN3w1Gz2qCma8RIx17veSj6Se
GxiEz9hhdqO0ERkrl5yliksCKD5/i+82MXVjrLWCRcht6HFQTNgdiC9PPV+cEQSy
2Dy+r6gO4HRBWY2CzL75J/A5neiVWO+eaLW2Vo9ZzNcXUwkJvuRJRWf9icPf7wBH
e9M9j8BAIvbkUO6xMkh6
=pUQ8
-----END PGP SIGNATURE-----

--edfPGatkwflS48KB5oIg0SrJaxCV8TVle--
