Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaJQO5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:57:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49158 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbaJQO5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:57:52 -0400
Date: Fri, 17 Oct 2014 09:57:36 -0500
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
Subject: Re: [PATCH v2 15/16] usb: dwc3: add tx demphasis quirk
Message-ID: <20141017145736.GK26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-16-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rnP2AJ7yb1j09OW/"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-16-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rnP2AJ7yb1j09OW/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Fri, Oct 17, 2014 at 04:53:40PM +0800, Huang Rui wrote:
> AMD NL needs to enable Tx Deemphasis quirk.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/core.c          | 3 +++
>  drivers/usb/dwc3/core.h          | 2 ++
>  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
>  drivers/usb/dwc3/platform_data.h | 1 +
>  4 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index f3c9699..3ccfe41 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -392,6 +392,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
>  	if (dwc->quirks & DWC3_QUIRK_RX_DETOPOLL)
>  		reg |=3D DWC3_GUSB3PIPECTL_RX_DETOPOLL;
> =20
> +	if (dwc->quirks & DWC3_QUIRK_TX_DEEPH)

	if (dwc->tx_deemphasis_quirk)

> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 6f789fd..146eb2f 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -156,7 +156,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  			| DWC3_QUIRK_DEPP1P2P3
>  			| DWC3_QUIRK_DEPOCHANGE
>  			| DWC3_QUIRK_LFPSFILT
> -			| DWC3_QUIRK_RX_DETOPOLL;
> +			| DWC3_QUIRK_RX_DETOPOLL
> +			| DWC3_QUIRK_TX_DEEPH;

last patch.

--=20
balbi

--rnP2AJ7yb1j09OW/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQS5gAAoJEIaOsuA1yqREokQP/R4facH82NaXtCVnrMejIxrs
R2jI0TzhYgxOeqAOJRzXMcxZlTqPXhMxd+NEtbmiGmyjfqGJLrXTXh6knsLdwaUC
fV5D0wIkMrL+0srshdqpGb89gyVYzKmeSqqjzKE7nEJzJK2AsbA9TdvBbY0op8r8
ganwom7MO3/2SVQ4NRX2v/yWWQNKFiyy8eCqOLj1FacuS5EKqpyHg/BryxcLxDhp
K/uZ3jby8HAB8xb4tDi2yWc3CIwU6t8SXCAYFcnUm4fp+fbjtGba1ODQgXV7EM3x
M9z8IyKLilj90sYEeMR365jMnulzKmg0fSHPaxDELDsdKkfjfWyydVZlAZibcH8H
7h3d/ltUIpisszVVMBVXZwuWztvn7jnPk0tkyYdbvcSrlx7N2GAE+fp2bGW8Wpcl
jzznkIlQTL42ryWae9hFtehFIGyNmz1CbxFfOJAMdwcPrm5tjpHI623kBRICIslo
n0qGsbTCgk2oHjScZL4s127LSEpmiKafx+8szaCEro8My4L+CuAw71Je/6Pqo36X
5CGfuaQCKMNuCdmKj49FO+9KbB/TsGgS8ghAEK36jHPL2obCnixt28BUXXAF9FsH
dS7ZL++bEUJJMtcnkVkA3GiJThfYaYfVrRMSvQHcj+5GHQcdR3QVfUoK7X/6iuT8
spJquNo5b0+ICuIvborm
=nsaP
-----END PGP SIGNATURE-----

--rnP2AJ7yb1j09OW/--
