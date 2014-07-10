Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaGJNmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:42:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57405 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaGJNmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:42:43 -0400
Date: Thu, 10 Jul 2014 08:42:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <Peter.Chen@freescale.com>,
        <kishon@ti.com>, <stern@rowland.harvard.edu>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] usb: chipidea: add support to the PHY framework for
 ChipIdea
Message-ID: <20140710134227.GL15340@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404901036-27682-5-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VBq/nvTu32OVLBUP"
Content-Disposition: inline
In-Reply-To: <1404901036-27682-5-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VBq/nvTu32OVLBUP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 12:17:16PM +0200, Antoine T=E9nart wrote:
> This patch adds the support to the PHY framework for ChipIdea drivers
> while keeping the USB PHY compatibility. Changes are done in both the
> ChipIdea common code and in the drivers accessing the PHY. This is done
> by renaming 'phy' into 'usb_phy' and adding a new 'phy' member into the
> ci_hdrc structre.
>=20
> Signed-off-by: Antoine T=E9nart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/ci.h          |  4 ++-
>  drivers/usb/chipidea/ci_hdrc_imx.c |  2 +-
>  drivers/usb/chipidea/ci_hdrc_msm.c |  6 ++--
>  drivers/usb/chipidea/core.c        | 67 +++++++++++++++++++++++++++++++-=
------
>  drivers/usb/chipidea/debug.c       |  4 ++-
>  drivers/usb/chipidea/host.c        | 17 ++++++----
>  drivers/usb/chipidea/otg_fsm.c     |  6 ++--
>  drivers/usb/chipidea/udc.c         |  4 +--
>  include/linux/usb/chipidea.h       |  4 ++-
>  9 files changed, 86 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
> index 9563cb56d564..139589c8ab90 100644
> --- a/drivers/usb/chipidea/ci.h
> +++ b/drivers/usb/chipidea/ci.h
> @@ -201,7 +201,9 @@ struct ci_hdrc {
> =20
>  	struct ci_hdrc_platform_data	*platdata;
>  	int				vbus_active;
> -	struct usb_phy			*transceiver;
> +	struct phy			*transceiver;
> +	/* old usb_phy interface */
> +	struct usb_phy			*usb_transceiver;

while at that, do you mind calling all struct usb_phy pointers
'usb_phy' ?

--=20
balbi

--VBq/nvTu32OVLBUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvphDAAoJEIaOsuA1yqRE4mkQAJM1XlVl04i+o0eMHsvlkm4m
aNY3w9WLNfQpt5yfPYa+R7C+A4koF3qA6inu/lz9zegr4TqPAF+1Y5U5gVvIKKEL
4lb5zgcizWdXVuOV3VEfoWhbnsecuTRm1f6kdpnj/SxlyydmB7nXhAHFIZPL9OTc
bP+VeQs2r1i1wY58hx0OwB2IUNJiyRzLaHtIc+6saUZUE+/8iQaAdYMRo+hXv1tX
wAcGsYH6oQj/2gZ0d3Zs/NghdJST68wonq7OJnsYG+MQmzfZ3DgCJfODHEvKXDuU
bOhijPo2pxmuYZ0mqbGuXNH9kZDZ7HbJhFcztxpMAyQra4drQZwi8C2O1Mq0aWDR
NGCgCZjMEpayjq8dCdolewh8fx6XVlIT+xHekRJ/ZBHeU9ST9tPo/EdbZCyuRAv3
UKnzDM8MBIRaFsI9DC8opm0BrJ2o83qRW76NItcIPonfD9KDA9WpT6yLYMd69JxD
uBElLkUZTOdgql+3TeMG+1VWmLcz0YjwwLdLwBKxL3ZiS6qah6gO1Ru7j/EcJZ6w
lsm/zFBeOdzVWvqgvvLoOQGUR2C2dVKOyLxNnrRo3ILZy22doo3FGe5HQExYtXBo
Bfv4KC+2C/LwRA3ZfZzGJ3Bu6k6uqFYSeAAzuo3pNOuVtduAPJr4Y+WXav1auWZ4
37x4fgMBIgZ1B5ASH09U
=ltVS
-----END PGP SIGNATURE-----

--VBq/nvTu32OVLBUP--
