Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab3CVG27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 02:28:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51617 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab3CVG25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 02:28:57 -0400
Date: Fri, 22 Mar 2013 08:28:29 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Bolle <pebolle@tiscali.nl>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-ID: <20130322062829.GA21346@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130322142811.41c24edf17de8c6809da5224@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20130322142811.41c24edf17de8c6809da5224@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 22, 2013 at 02:28:11PM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> Today's linux-next merge of the usb-gadget tree got a conflict in
> drivers/usb/gadget/net2272.c between commit eda81bea894e ("usb: gadget:
> net2272: finally convert "CONFIG_USB_GADGET_NET2272_DMA"") from the
> usb.current tree and commit c36cbfc045bf ("usb: gadget: net2272: remove
> unused DMA_ADDR_INVALID") from the usb-gadget tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc drivers/usb/gadget/net2272.c
> index 32524b63,03e4104..0000000
> --- a/drivers/usb/gadget/net2272.c
> +++ b/drivers/usb/gadget/net2272.c
> @@@ -58,8 -58,7 +58,7 @@@ static const char * const ep_name[] =3D=20
>   	"ep-a", "ep-b", "ep-c",
>   };
>  =20
> - #define DMA_ADDR_INVALID	(~(dma_addr_t)0)
>  -#ifdef CONFIG_USB_GADGET_NET2272_DMA
>  +#ifdef CONFIG_USB_NET2272_DMA

Resolution is correct, thanks Stephen.

--=20
balbi

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRS/oNAAoJEIaOsuA1yqREHwUP/ROI4Wddo1wwPoDRvhbkFJe/
bkjRonnTL13bSIjZzBLJ69dE+HwTvSNkaI23wMmbcHEN7aLRlTdY54k8s2T5ToX3
LhZW6fMBSPOaMFbDJSnWZjsLjSiIyOSbfdwaJRuyoQpQDn8IvW20EX+IzNJvR0nr
x3HzfNcHj7r0LcyL9OuAdCzJh37OyWChk/UpkBMBp1HVc3v1qBmmJLRZv4b0dHGG
ORdYQd2faIypBA1xGqqJfO5dB5Zy1ymBJuBmgZ3JOgnu3aHem0DkUl6Gc740EWto
uLaJi9JIP7af8vud62THPysnJhliidWjNMHJ16offABrFlCv9QvTTLYX2lHAUyC7
qzVikOW5WiTfnqg8s/CH9NUVNNmh7s9aeXI2RThYmjfV5ztwyMnT0oGiuRyPK/3B
c7a5lzH7zUlo1X4qAVohvUgSoChLNy5xfyKPF8+oCjJdbP1sFPnipvcoN0c/jS4h
RuihxkbHGGoC2V0moBnL/no1BmHFi8VSMnLqBeDFv/tXs2PjWQZqFSyAalxJWMnX
SkMMaS5cqpdxxY2iWGoWcg9LhZpfIhdY/on23+H/c3oRl+dB0K0ktMJgjd88A5Ep
IakOd31IgsT2SYZ3om4r4pNMciNwS9m+BSR/9GP8OnPdfdfLFl+gNplHnJLSLqZW
mPVPuoNoZ6lllJSs7M/i
=8B+v
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
