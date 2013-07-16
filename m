Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3GPIJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:09:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53818 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab3GPIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:09:16 -0400
Date: Tue, 16 Jul 2013 11:08:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Daniel Mack <zonque@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: v3.11-rc1 USB regressions
Message-ID: <20130716080836.GC8880@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi>
 <51E4E922.2040707@gmail.com>
 <51E4EF70.3040502@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Content-Disposition: inline
In-Reply-To: <51E4EF70.3040502@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 16, 2013 at 12:30:00PM +0530, Kishon Vijay Abraham I wrote:
> On Tuesday 16 July 2013 12:03 PM, Daniel Mack wrote:
> > Hi Aaro,
> >=20
> > On 16.07.2013 00:56, Aaro Koskinen wrote:
> >> Hi,
> >>
> >> I think USB tree introduced regressions in v3.11-rc1, at least for some
> >> OMAP devices using legacy boot.
> >=20
> > Thanks for checking the tree so early.
> >=20
> >> I have only bisected these; I have no
> >> idea what the real fixes are but the following reverts make Nokia OMAP=
2+
> >> boards again usable for kernel development work (they need working USB
> >> connection for interacting with the device):
> >>
> >> 1) USB peripheral mode (g_ether) is broken on Nokia N900, N950 and N9
> >>    (USB_MUSB_OMAP2PLUS). To make it it work, I need to revert three
> >>    commits:
> >>
> >> 	09fc7d22b024692b2fe8a943b246de1af307132b
> >> 	usb: musb: fix incorrect usage of resource pointer
> >> 	(Reverting this fixes the g_ether probe failure "couldn't find
> >> 	 an available UDC")
>=20
> I've posted a patch fixing the issue
> http://comments.gmane.org/gmane.linux.usb.general/89541
> There were some comments on it. I'll be posting a new version for it.

hmm, n8x0 used tusb6010, so perhaps a similar patch needs to be cooked
for that too. Right now, let's to the minimum fix, which is just to
increment the array size to 3 and for v3.12 we do the changes that I
suggested.

--=20
balbi

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5P+EAAoJEIaOsuA1yqREYYsP/15GxT+OeOLofHgSB1UckWj8
26gZ77SQxITikC7+wBJ0275ns/Oq29Zd2f33rVfw/b4ql1wXakSAYX8JM71V+hA4
Epb39NZBHdyzgMOrmCVKGzf4iW9xm/pzA6z1ucQteB/I8h9wqpc0ZQA6JFcK1ItG
33Qir7Yln41kmKmF7LTshfkSAXisiaP5p2K8RIpoRRinobgHYRVs70Qc2arAJSoF
EMslNzEqo2KsxMPFOnImwZPhqAarWIsrrKVKNxXyG674LvMOBUoQPGoXsN6a7HXz
D1xrgQCE1PE4Uzsl7Xt/B5zKCDo/BKTPh2ECURWFRuNYuhuTrTPhLllW1mtTVjsF
gcwsTLL+Ei2nJbj0XKetl+THXjWhRR7dqPkkMfhn4bvZTT2hH4qeHW2z++f08qXQ
DZzhY/53tkoAie01ELUUa8MDvDqpFEa30fPw72uPk5y/CGhfziRK8ZQRDLDTl+aB
R20Bul+k2cHjWJ6dD5xXqMOWv/bC+zhkn8s2qc1Lf8NAFFTNQBWtNnzW4vCZ4UIO
dMUBL32lxHbfskjADjXk6lgPMHysGdgyh/smZeUJZ+G9+x1nlGMQNgQtnfuq1NlO
SqcPw93S661WBnbzpHlC4laOgkY98yfBJW0GTKOivQWpGL6rKaUV4JBnJi+rZ5zx
VEi6nOvDN0nIq+sQ8i15
=v0Ay
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--
