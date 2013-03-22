Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab3CVG3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 02:29:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51643 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab3CVG3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 02:29:17 -0400
Date: Fri, 22 Mar 2013 08:28:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-ID: <20130322062851.GB21346@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130322143135.8f9c42c298fd86e4084ca397@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <20130322143135.8f9c42c298fd86e4084ca397@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 22, 2013 at 02:31:35PM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> Today's linux-next merge of the usb-gadget tree got a conflict in
> drivers/usb/gadget/net2280.c between commit 8119b55aed81 ("USB: gadget:
> net2280: remove leftover driver->unbind call in error pathway") from the
> usb.current tree and commit 68abc94f8de8 ("usb: gadget: net2280: don't=20
> touch gadget.dev.driver") from the usb-gadget tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc drivers/usb/gadget/net2280.c
> index 3bd0f99,691cc65..0000000
> --- a/drivers/usb/gadget/net2280.c
> +++ b/drivers/usb/gadget/net2280.c
> @@@ -1924,7 -1920,7 +1920,6 @@@ static int net2280_start(struct usb_gad
>   err_func:
>   	device_remove_file (&dev->pdev->dev, &dev_attr_function);
>   err_unbind:
> - 	dev->gadget.dev.driver =3D NULL;
>  -	driver->unbind (&dev->gadget);

This also looks correct. Thank you

--=20
balbi

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRS/ojAAoJEIaOsuA1yqREKwcP/iqAIpFvwWG2gXyfEH0jZoK8
IQ3JY+wbTben3jrDUrv2uL2r/Hcjz+yLjqDeF4j4AMViH6QmlnRLEKqjWp7DtI0K
G7Vjhu2849K7FMuC/tAFe26w/8yNuMjdIZuffxgihoLVzMnjALwamZz81hO+1uUQ
wE74dgDJoWpjohFWHEImEWsAKMhruTx9XApY/HRAVFRBqEaaUvEpSE3XrOe9+Xeh
w1jgKmAUmE4neth7Dio29BQl9k20jSbw/zO6s6eC3vIQ+ZvYzo5VJm+FydRBQ+m5
61+CpKHGynilln9cZ9cLw+eGIPY4H7gUwxmpZnAsTIXJ9m/jSOA13MbShy1a8ASR
ynxllek/7X2/gi5mfzwci2SwawR4A1WgHm8eRLVNM0jKZs5umPBnsV+Ansezm2Iy
aKmo2f5efcVpGmh4twiC6kPOTVCxKNyJgJZw5eT5y/9CZsAM+uXCj6jhK2DMvHAL
y5T6IoyJ6OUnXV2ht8XoEMUT8bX4OoDiNGVPNbcYjnx5WmgH3QUf/ctybvYnmeyL
jajwFf8UomObfWO70dTm8bUfuxt9srd0FagyuD6TBx9tFG1TWwj/9bhAgGi8YZBj
6FQl60qETb0oOiEXpwtwureuGGsPB1vc6HgCHhUOUXicreeUjFFzGID6e4EAdUPw
jYsB3W/+cM1EuyEkOzWU
=gxX6
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
