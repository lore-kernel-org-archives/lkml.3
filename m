Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaJQO4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:56:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37514 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbaJQO4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:56:47 -0400
Date: Fri, 17 Oct 2014 09:56:29 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 13/16] usb: dwc3: add lfps filter quirk
Message-ID: <20141017145629.GI26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-14-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h22Fi9ANawrtbNPX"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-14-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--h22Fi9ANawrtbNPX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2014 at 04:53:38PM +0800, Huang Rui wrote:
> AMD NL needs to enable lfps filter quirk.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/core.c          | 3 +++
>  drivers/usb/dwc3/core.h          | 1 +
>  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
>  drivers/usb/dwc3/platform_data.h | 1 +
>  4 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 920a8ab..a1ee586 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -386,6 +386,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
>  	if (dwc->quirks & DWC3_QUIRK_DEPOCHANGE)
>  		reg |=3D DWC3_GUSB3PIPECTL_DEPOCHANGE;
> =20
> +	if (dwc->quirks & DWC3_QUIRK_LFPSFILT)

	if (dwc->lfps_filter_quirk)

> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 0eb8b2a..d1f0901 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -154,7 +154,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  			| DWC3_QUIRK_U2SSINP3OK
>  			| DWC3_QUIRK_REQP1P2P3
>  			| DWC3_QUIRK_DEPP1P2P3
> -			| DWC3_QUIRK_DEPOCHANGE;
> +			| DWC3_QUIRK_DEPOCHANGE
> +			| DWC3_QUIRK_LFPSFILT;

last patch

--=20
balbi

--h22Fi9ANawrtbNPX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQS4dAAoJEIaOsuA1yqREfMUP/0B06LtcbgJJO9RpzEEaJQmh
yWdyHpF6jNLEfbKMaeZqaFKwlGpOphMtCxj1PIwWw44jz96eVEyECbW2AvXrW4rp
0nfzsDM8CR/466eK/U445HpA035LKIl9X9pCVgQPZUQrva1xeVEpz6/vL9MSJcGw
2fhco9PBUYDA4w9WUkAl8nnaEGPmkKBNdcmigJ38Da28PP9e1bp/8Yv30nqa+xtg
m5Gh5eqHevJcwE6tC9DiLGiMCgoiBNA2DyM3VX4rJNSTte8LtNLmefrsax9fWSfF
qGxtfzaL4GGpfsRbrF26EV+Hg7+6hZi/pzKImFUmFeakBxgN8h8OBtVcZec1Wwbn
OxzfaPD7kMdr1G/hVYT2jydXnP9Rnlx7FEOTjguF9QCqAz36wawTAbAE7kcNG5zs
AeE8qxQyLU0fHSeQPOgiFQmoBvZaz85lpOA+DxtA+Km4WQrvy097q4alHgdQKlts
5TIgAmI+SuYw47rzsmvJSx8dVk+jPajvUL1RzLpUkO/cPc2yhuxbr9WHVjwsf4X4
UiYOK2p7ESGRXHxbOHg0Pq6jYlFC59WR+Js/4I6bETEWAg/yvASsD1UwCWY7jRLU
cWJByqF72yrFmATeRbI7sVyY6iWblA12BnUi32aLP1S3N6JsmAjesQnzHyjuCLF8
fHezdL73JGdlmJ+ukAid
=F+PO
-----END PGP SIGNATURE-----

--h22Fi9ANawrtbNPX--
