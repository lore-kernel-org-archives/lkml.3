Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbaDWOzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:55:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60200 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbaDWOza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:55:30 -0400
Date: Wed, 23 Apr 2014 09:53:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-serial@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <peter@hurleysoftware.com>,
        <m-karicheri2@ti.com>, <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] tty: serial: add missing braces
Message-ID: <20140423145305.GD9593@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
 <20140422142256.GC5524@saruman.home>
 <20140423002843.GC24603@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gE7i1rD7pdK0Ng3j"
Content-Disposition: inline
In-Reply-To: <20140423002843.GC24603@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gE7i1rD7pdK0Ng3j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 05:28:43PM -0700, Greg KH wrote:
> On Tue, Apr 22, 2014 at 09:22:56AM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Mar 20, 2014 at 02:29:57PM -0500, Felipe Balbi wrote:
> > > per CodingStyle we should have those braces, no
> > > functional changes.
> > >=20
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> >=20
> > Greg, do you want me to refresh and resend this series ?
>=20
> If there are conflicts with my current tree, sure, I'd love to have
> that.  I should be trying to dig out from my patch backlog for 3.16-rc1
> by the end of this week...

then I'll resend rebased on -rc2, should make your life a little easier,
hopefully.

cheers

--=20
balbi

--gE7i1rD7pdK0Ng3j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV9PRAAoJEIaOsuA1yqRED6AP+wR8JhJKuLpQHyzWQ/BmV30D
pO7rzivxYBmb6TVGVZ6DE1zlGlpblcI2p8Qgm3mYyJyk1stRui74YaZW1ZWX+mOT
nM6LZxP9cfGPT2csc9xMNofmDu4GgJ/cHCjHbxsTnH5GTIeDm1aNs62vl0/eDHv3
uGxcb6ReCfzjck3VNndqvC3icV3Li89H3bNSTVj2rbKqOfMhfhtFeR6z2o3GsOdD
bAs8B9cFgISjYB5nETV1m1H2T1gr8nPFZN3Lg7VqmyjDNPniVDiKBQgFCVdhdaat
1niKC5UroUoE1+cqG8d/zrIxOH1KwAvQRPGht3cd5pijz8PhPHcI9Ib46AXGQK8m
f+70qBibEwAnuA0uWvUD6FAqsVdLKqdOJrkUXFCnzhVSZL3Uy8mUKNyDaSme+yrl
Rv/FkMKFZsJ/K9umqb1Os0O4khq1bHy8snjUNuKjcNmPkk5f2ywf/vNfiYI/N74b
Gc97+hCLRFevVqTP15u2N2AslxPm4p54GLYxCDGHkuVt6KzoUON2CAvAB7E9ZZuI
KAzQwDPCVIuVGm3ejoEwKf0l5T7BTARQdDcy3xg7rdP7ogzqdGZjEDu6nESyegX8
kus+TefmtswIuaY5HuXMgStge4vnQaVy1XoS7yqN2ydtDxneOZKem6aK7Yr9Wgzi
4Ofo6GktXmU8oC1M88qq
=yBKc
-----END PGP SIGNATURE-----

--gE7i1rD7pdK0Ng3j--
