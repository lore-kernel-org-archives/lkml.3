Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaJQO5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:57:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49147 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbaJQO5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:57:40 -0400
Date: Fri, 17 Oct 2014 09:57:08 -0500
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
Subject: Re: [PATCH v2 14/16] usb: dwc3: enable rx_detect to polling lfps
 quirk
Message-ID: <20141017145708.GJ26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-15-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cN519qCC4CN1mUcX"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-15-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cN519qCC4CN1mUcX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2014 at 04:53:39PM +0800, Huang Rui wrote:
> AMD NL needs to enable RX_DETECT to Polling.LFPS control quirk.
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
> index a1ee586..f3c9699 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -389,6 +389,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
>  	if (dwc->quirks & DWC3_QUIRK_LFPSFILT)
>  		reg |=3D DWC3_GUSB3PIPECTL_LFPSFILT;
> =20
> +	if (dwc->quirks & DWC3_QUIRK_RX_DETOPOLL)

	if (dwc->rx_detect_to_polling_quirk)

> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index d1f0901..6f789fd 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -155,7 +155,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  			| DWC3_QUIRK_REQP1P2P3
>  			| DWC3_QUIRK_DEPP1P2P3
>  			| DWC3_QUIRK_DEPOCHANGE
> -			| DWC3_QUIRK_LFPSFILT;
> +			| DWC3_QUIRK_LFPSFILT
> +			| DWC3_QUIRK_RX_DETOPOLL;

last patch.

--=20
balbi

--cN519qCC4CN1mUcX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQS5EAAoJEIaOsuA1yqREuOYP/3s0CJovqUG5aRj/0kmOWI1l
gLSYG+G6u6GZLBW1Gk4wXoWHb6a00doW0QZXGwiLrxEnhu6HKB4Js657WddjskQf
gFd+ieMWDQp7SgEqOql8pCstYhVzfDjU7wFEEJWp5ZdC9r3SAzTVRaob3S6ogLZk
IEdVmF2C9PWbLImkENRqBaVODFpNWkXRr/dEPsvB/kLyw/s2+8Xm1XyfGmJdh/Ya
hHD97E0khZ3SLA5+YPHKgkS+DGVTAOhnCLJDYxmXdVhNrIEKsNPMWjJ0y/BDUqr6
LBjHGEH4BbWHbnB6O/Yhe3P4LoB9nzDBOBoRt8sfRAkOa+f8o30P1yFE4rxGg8/C
dJKW4lmCECQ9UrMakLmGPQ/hxmjBES/lQZbZzTkIRP8VQQC3pyY3ciWLcZKJm0cc
/M7hmXjReAWT0VhltYoe7yTepPoALkrm75i7teqPegGqucvDZ2a2QnhBvTyJU9K3
GnxeFES2PsUbq3iG/+AZ50aIKjwnPZGNyhccqB2356jGrfiREcTWWQP+Dnx+dWf8
WHPCigVpl42qzbtNoJDPHUAv1UHuRTGF1z6JrniLUqnvAG9eNy5BNxaPo81MdGui
rjjlXA94Pmb2gmFDe+3NcYMBDRtGcSInu2HAloIi6HMhd4mrUcKfrVs4GWlg1xEB
dHo3RO+AfkaUPMx5Y2Pm
=I+gS
-----END PGP SIGNATURE-----

--cN519qCC4CN1mUcX--
