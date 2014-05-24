Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbaEXPKJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 11:10:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59568 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168AbaEXPKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 11:10:07 -0400
Date: Sat, 24 May 2014 17:09:41 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RESEND v4 0/8] Add Allwinner A31 USB support
Message-ID: <20140524150941.GG10768@lukather>
References: <20140514160520.GA4679@kroah.com>
 <20140523183339.GC10768@lukather>
 <20140523221940.GB18106@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E69HUUNAyIJqGpVn"
Content-Disposition: inline
In-Reply-To: <20140523221940.GB18106@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E69HUUNAyIJqGpVn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 24, 2014 at 07:19:40AM +0900, Greg Kroah-Hartman wrote:
> On Fri, May 23, 2014 at 08:33:39PM +0200, Maxime Ripard wrote:
> > Hi Greg,
> >=20
> > On Wed, May 14, 2014 at 06:05:20PM +0200, Greg Kroah-Hartman wrote:
> > > On Wed, May 14, 2014 at 02:34:19PM +0200, Maxime Ripard wrote:
> > > > On Tue, May 13, 2014 at 05:44:14PM +0200, Maxime Ripard wrote:
> > > > > Hi everyone,
> > > > >=20
> > > > > This patchset adds support for the USB controllers found in the
> > > > > Allwinner A31.
> > > > >=20
> > > > > While the design is similar to the earlier Allwinner SoCs that are
> > > > > already supported, a few details here and there change, like the =
fact
> > > > > that the PHYs now have one clock per phy, while it used to be onl=
y one
> > > > > for all the PHYs.
> > > > >=20
> > > > > Resent adding Alan Stern's Acked-by and puting Greg KH in the
> > > > > recipients this time...
> > > >=20
> > > > Applied patches 2, 7 and 8.
> > >=20
> > > Feel free to apply patches 5 and 6 to your tree, as your branch needs
> > > these, with my:
> > >=20
> > > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >=20
> > > Or, if you want me to take them, just let me know and I will.
> >=20
> > It looks like it's still not in your tree (or at least, I haven't
> > received the usual mail notifications).
> >=20
> > Is this expected?
>=20
> Given that I haven't applied any USB patches in a week or so, yes, it is
> expected...
>=20
> Give me a week or so to catch up, I've been on the road for a month
> now, and am finally home.

Ok, thanks, I was just trying to make sure they weren't
lost/forgotten.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--E69HUUNAyIJqGpVn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgLY1AAoJEBx+YmzsjxAgLt4P/0xxEAuDKE5UStyFpJN1UiHw
SM2cpqhQUDRZ03IX2OhrrGWlMuesEGxYOp2mCN7SrnuAoIqZo7XD7Tr5vNx3J0SB
CADMFcMmqf5cG5ES2fFSQC/lgppzvaBk3IdnQBvniqdmKa+gWcC/55tI3/QTkVXb
tPrQ5wRCrtZc0cqmK3zAlAKba32lUkLmWa+31NrXCRzFFOyIZr9XoYuNq74fk0Gc
HbHXphqxa5+WeihoOV971RTUnVjX/EZOwmJXvMzZPQFkA/Zrcvw0y2ZoAoSSJ4tp
JZ/571Wg9heGR4FB7F6N6xJ0PPpTSKeZ2kFodp6pEtvO82NU+7d8/PLhMwl4iSId
N8zO5A00xsw4v16V0q2tRSg4OYhcV3jFB0Skfyqjbp1YF53PrVVUfi417B90JSlU
m+Wc+RjP6GzRXiOFJ6ZqFjgTA0ExMb9RAqHg9XJhtL/dgsxl0wstZoN+dClMPma/
IgNQ4TqzsQpa2YjnRpa6S9+cCp7OpiN3bFHyb3+AmwiozLBfinCY3m/JNK8Um7v+
9TCjqwO9jX6tFXOgHAeFM+gEiy+CKxfhhJAmMGL7swoPbvRvbUzpsGJynvbqrwqL
/YKdYEsLsDEbdOfNWT+nM3WlzECUXC549Il7Bsi+mxZzMw7VrtTdsUaXiXLGDD7X
ju3JHa/qO1CeftxEjFcN
=Hqzc
-----END PGP SIGNATURE-----

--E69HUUNAyIJqGpVn--
