Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3CMK0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:26:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56853 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3CMK0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:26:47 -0400
Date: Wed, 13 Mar 2013 12:26:35 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <kgene.kim@samsung.com>, <p.paneri@samsung.com>,
        <gregkh@linuxfoundation.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 0/2] Adding USB 3.0 DRD-phy support for exynos5250
Message-ID: <20130313102635.GG6270@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1361976229-16024-1-git-send-email-gautam.vivek@samsung.com>
 <CAFp+6iGon4sD4=qKpAVG-OGm9brwnz1O6sdCKmh8o9Wy1e_6ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XRI2XbIfl/05pQwm"
Content-Disposition: inline
In-Reply-To: <CAFp+6iGon4sD4=qKpAVG-OGm9brwnz1O6sdCKmh8o9Wy1e_6ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XRI2XbIfl/05pQwm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2013 at 03:41:15PM +0530, Vivek Gautam wrote:
> Hi Felipe,
>=20
>=20
> On Wed, Feb 27, 2013 at 8:13 PM, Vivek Gautam <gautam.vivek@samsung.com> =
wrote:
> > Based on 'usb-next'
> >
> > Changes from v5:
> >  - Squashed the following change from Felipe in this patch-set:
> >    [PATCH] usb: phy: samsung: let it be built as a module
> >  - Using EXPORT_SYMBOL_GPL() to export symbols in "samsung-usbphy.c"
> >    to allow module builds of these samsung PHY drivers.
> >
> > Vivek Gautam (2):
> >   usb: phy: samsung: Common out the generic stuff
> >   usb: phy: samsung: Add PHY support for USB 3.0 controller
> >
>=20
> I am rebasing this pach-set on top of your PHY driver changes in
> 'testing' branch of your tree.
> I took first 194 patches ;) from top of testing branch (i could find
> these on top of 3.9 rc2 merge),
> and applied the same on 'usb-next' branch in my development tree in
> order to test further.
>=20
> I shall be posting these rebased patch-set, so that it will be easier
> for you to merge the changes in.
> Is there something you want to point out to me while i do this ?

nothing to point out as of now :-)

Thanks a lot.

--=20
balbi

--XRI2XbIfl/05pQwm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQFRbAAoJEIaOsuA1yqREZRkQAI8z6M6Ms30CCHV+3x+cS8d3
CHcO5lYTl4dwTbAtvjN2RELbtGFdVdsKiOCYqFKQQaMGk2Ui+wSbwf4XhUyRNcF7
tqgsVAPxEMFaquAdzx7s1etxsRgDcKlyrWlI9re55d043qslkA4kpLlbsY7AjbII
JFjA1yCAdpqJFcwrt0/14LWo8kheKJhc1intPJ4/XpuagDZdvT5ACJ0RVTMImgEz
Q9bCyex+IEN1+FaB8CP/Zi9286NK2MzROQZJEr9RyqUjf/iihe6Pq3YhZw9AIoVp
1/Cjo/HxzLKkLclF3Vgp3lv/qxd/TfSijvJ90Dybv3tpqUCmdPJWtt5O9OsKKM/+
sBqlhG79OLWjQZ7X9qPurFvasvh8LXRvPqabeQLua2q6K/uC5Ia/K2/QfChQoVrl
Z+J/D0BdE2RrJM7BK6YyFi6Y4AOc6h/3HNFmf1POujfa/8Cplv5/4FUH7QuJRsl5
fqC48Kp3/3ka8iL7ZLqrQvOw5siBKD5ZWB6cbEJh1XV0/ACIY/zT6/F7ZQUCVZyY
1EPN6eTMkD3Bgqys5KeZaR3HebKvTB5hI5YFvCbo6ffsQ3vb7QIyqs6LFpaBRH8i
517Fx1G+8eqC9aGl8EyKJgHSAkUl1VQYBde5NhtTkfhXS5lXpFgnAaFu4rGrQrii
SJLMlFd2LGEkojxdEYHt
=Roi7
-----END PGP SIGNATURE-----

--XRI2XbIfl/05pQwm--
