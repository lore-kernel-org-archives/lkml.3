Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaJMRDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:03:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42299 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbaJMRDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:03:41 -0400
Date: Mon, 13 Oct 2014 12:03:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <mina86@mina86.com>, <r.baldyga@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH v2] usb: ffs: fix regression when
 quirk_ep_out_aligned_size flag is set
Message-ID: <20141013170324.GJ21709@saruman>
Reply-To: <balbi@ti.com>
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
 <1412802738-28839-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141013153212.GE21709@saruman>
 <20141013165556.GA4034@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lildS9pRFgpM/xzO"
Content-Disposition: inline
In-Reply-To: <20141013165556.GA4034@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lildS9pRFgpM/xzO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2014 at 09:55:56AM -0700, David Cohen wrote:
> On Mon, Oct 13, 2014 at 10:32:12AM -0500, Felipe Balbi wrote:
> > On Wed, Oct 08, 2014 at 02:12:18PM -0700, David Cohen wrote:
> > > The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
> > > quirk implemented to align buffer size to maxpacketsize on out endpoi=
nt.
> > > As result, functionfs does not work on Intel platforms using dwc3 dri=
ver
> > > (i.e. Bay Trail and Merrifield). This patch fixes the issue.
> > >=20
> > > This code is based on a previous Qiuxu's patch.
> > >=20
> > > Fixes: 2e4c7553cd (usb: gadget: f_fs: add aio support)
> > > Cc: <stable@vger.kernel.org> # v3.16+
> > > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > > Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> > > Acked-by: Michal Nazarewicz <mina86@mina86.com>
> > > ---
> > >=20
> > > Hi,
> > >=20
> > > Since this is a feature that worked in past, this is meant for stable
> > > versions >=3D 3.16 too.
> > >=20
> > > v1 to v2: just added Fixes, Cc and Acked-by lines on patch descriptio=
n.
> >=20
> > this adds a build warning for use of maybe unitialized data_len. Plese
> > fix.
>=20
> It's a false-positive warning. data_len is only initialized if halt !=3D 0
> and it's only used if halt !=3D 0 too.
>=20
> Do you prefer to initialize it to 0 during the declaration to silent the
> compiler?

yup.

--=20
balbi

--lildS9pRFgpM/xzO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPAXcAAoJEIaOsuA1yqREtTQP/1NOCkDI41Jmb32vcn7X3AEC
2SSOHm5XIyuIO1b4NxXmR+bmMz3GoscedI8oqHw8s7pdnPy83TdGfndedRrEL6Kb
ZDEUSzIqy+kbfeWIrqLdKYAdVINQkx0/a2zHtPQIoCx5cp/knRMT8CdbGk26P5ls
HmtYPjHG5AiSqzOZOZtiXAHAdCTnuLpVgp9+6obHoT8ltaOMXnHA1LPSjjELf7xN
CFA3ON9lXa9NhkE969okZQ+NQWX6x3w7huVAg5m7ciZ1hkh7sLiheg2gn7HCs733
REV6JgxZTUUu5rKRCzmb/VOxXcCb/wVqqC0nZKXZgbFn24utnLVNfGKATRc4/Lam
FrJ+n2hHkpac3p3usV+nPmQHg2Zn5SFX73OiM+cznk5gf8JKxzjM4OxL8n/HLpnD
Qghbsor5FQfV3iXhS6l50ni2lCY6ILHwZtfQebL99GqxgYUKNXzC994LMLlCuCTq
RHk8Gzd0JSPRZpDf9HBb/uschZkTaclMwvXfJE9Og/2tkPkW9aUyAFAUHKoepJip
BBq7CQB7qv13+o9sJMdE3XLbhaI62SEyBmC6SzrkyFfu4ydK1N5TWY83iJxtNZMp
VlYVa5xnPDGf7836iY9iQZYjs67nDK3rBlkKxTmfWVMe7S47VdzciYxx6s38ZDIp
hAIKN5mJEvbVX4DTkuLm
=aOmY
-----END PGP SIGNATURE-----

--lildS9pRFgpM/xzO--
