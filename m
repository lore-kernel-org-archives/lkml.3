Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934704Ab3E2RkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:40:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56817 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab3E2RkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:40:13 -0400
Date: Wed, 29 May 2013 20:38:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>,
        <george.cherian@ti.com>, <sameo@linux.intel.com>
Subject: Re: [PATCH 0/3] palmas usb driver
Message-ID: <20130529173851.GC21290@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369405896-30246-1-git-send-email-kishon@ti.com>
 <20130528173554.GD15794@arwen.pp.htv.fi>
 <51A59AC9.9000908@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <51A59AC9.9000908@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 29, 2013 at 11:36:01AM +0530, Kishon Vijay Abraham I wrote:
> Hi Felipe,
>=20
> On Tuesday 28 May 2013 11:05 PM, Felipe Balbi wrote:
> >On Fri, May 24, 2013 at 08:01:33PM +0530, Kishon Vijay Abraham I wrote:
> >>This patch series adds driver for palmas usb which is used to detect
> >>attach/detach events of usb device and usb host.
> >>
> >>[PATCH v5 2/3] extcon: Palmas Extcon Driver which was sent previously
> >>is added in this patch series itself. The revision history is added
> >>in the patch comments section.
> >>
> >>A checkpatch warning "WARNING: static const char * array should
> >>probably be static const char * const"is ignored since it introduces a
> >>compilation warning.
> >>
> >>Graeme Gregory (2):
> >>   drivers: regulator: palmas: add an API to set/clear the switch bit on
> >>     SMPS10
> >>   extcon: Palmas Extcon Driver
> >>
> >>Kishon Vijay Abraham I (1):
> >>   usb: dwc3: use extcon fwrk to receive connect/disconnect notification
> >
> >
> >There were some comments to this series, what will happen with it ? Any
> >new versions coming ?
>=20
> I've already sent new versions. Palmas Extcon Driver is already
> queued in extcon-next.
> Chanwoo can take this patch in his tree after your ACK. [PATCH v2]
> usb: dwc3: use extcon fwrk to receive connect/disconnect
> notification.

alright, thanks for the note, here it is:


Acked-by: Felipe Balbi <balbi@ti.com>


--=20
balbi

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRpj0rAAoJEIaOsuA1yqREIzsP/1dko3amHbyWlLC9XjqFG2Wl
KSyuIRF9U7Povtu907ASTNCCWhuE92SaO5oKfxw/5s8sRnXMLHyav7wBU8HHKYw7
EJtSx2d8UiS1sj+0QHBOKQ3kKdlaSpS/9XOeRC93sLcP76iBBtsY9QAsGn5Xn1M5
BmR3hczmHZSpGvdrLjPMZXo2hUa6/4uWz8IbWd70x7AmFAStaTn38Ej9KjhcWb+R
ASvz039o74ViSEEgPfi214xxjlebV6btva/pn8jkhzf6VvwM6dcttR1wDHFBQonQ
1ReNhukufB/s8SIgghUS5dG9FJidJsEQXO8aHxNPv1CY4MIlfBA63jTp4gHawGid
4+eq72bXPO+9mSsOhd2cq7fCkrU7woRT3rlpKwByfdMI8yTEsHaRMKZvYZ3Yld3A
gQgzJX+m/rG6ZwZN4NdDG1e6r93KIl5VQrXu8VXV6A1NkyqaEl6MylW+PUDJq1hz
xlMg0+d20HFk/J6H8u55afvQIOcKWmW19ANBttv97ep3xjYiRMZUU0Vixvk1g2q/
MTEy47eBiwxZvGzojdxqTknhwOOAudXcTwwPQpEMVXJjHwLu++IbzF22bTSS5eL+
c96v483jTPrkx8OOwgZQ3ysAJrXVnbzNuR6IWkjeAqFB1PuuJF4/HZcNdstOX+B3
O7OMZlJt24X2LWS5Jhg/
=/KLz
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
