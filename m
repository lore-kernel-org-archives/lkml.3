Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaBZPUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:20:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44861 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbaBZPUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:20:44 -0500
Date: Wed, 26 Feb 2014 09:19:13 -0600
From: Felipe Balbi <balbi@ti.com>
To: Neil Zhang <zhangwm@marvell.com>
CC: "balbi@ti.com" <balbi@ti.com>, Peter Chen <Peter.Chen@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Message-ID: <20140226151913.GF30028@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
 <20140225011839.GD7540@shlinux1.ap.freescale.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
 <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A5@SC-VEXCH4.marvell.com>
 <bce87beb86d34377ac3dae0645622edf@BN1PR03MB235.namprd03.prod.outlook.com>
 <20140225181234.GF23275@saruman.home>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413885@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Content-Disposition: inline
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE54EC413885@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Feb 25, 2014 at 05:48:17PM -0800, Neil Zhang wrote:
> > > > > > > > Hardware zlt will try to send the zero length packet
> > > > > > > > automatically when the data transferd is multiple times of
> > > > > > > > max packet, this will cause issues on Windows.
> > > > > > > > So let's disable HW zlt by default.
> > > > > > >
> > > > > > > Would you have description that what kinds of issue on Windows
> > > > > > > if zlt is is selected?
> > > > > > >
> > > > > >
> > > > > > Enumeration will fail.
> > > > > >
> > > > >
> > > > > What causes enumeration fail, why it does not occur before?
> > > > >
> > > > A unexpected zero packet cause enumeration fail.
> > > > It's not easy that the descriptor is actually 1024 bytes, so not
> > > > easy to be found.
> > > >
> > >
> > > Chipidea bug too? Does it follow ch 8.5.3.2 Variable-length Data Stag=
e, USB
> > 2.0 spec?
> >=20
> > wait, this is a chipidea core ? Why aren't you guys using the chipidea =
driver
> > yet ? You need to switch over to that driver dude, we can't have duplic=
ated
> > code in the tree.
> >=20
> > I'm sorry, but I won't be taking this series, please use chipidea drive=
r, it should
> > be very simple to add a glue layer for your core to the chipidea driver.
> >=20
>=20
> Yes, it use chipidea IP.
> But the driver is earlier than the chipidea one and we use it for our
> products.
> So it may be not that easy to switch to chipidea driver due to the
> stability.

that's nonsense, the average chipidea glue layer is ~80 LOCs. You can
write that in less than 2 hours and give it a try. We cannot have
duplicate drivers in the tree and development effort *must* be shared.

If you guys use the same IP, why wouldn't you use the same chipidea
driver ?

sorry, you didn't convince me.

--=20
balbi

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTDgXxAAoJEIaOsuA1yqREtYUQAKAKyuWUvrZVJ6t409NIfnca
lUdjlwOzeWGFdqSPEHAeSMrJMmXZ86vjvn1Unzs7GNMnLfN+du41LE2A06aszv4m
BSuCtDWp/yWWNf0WfhR9HOWdiTYFzJnE78ad1R+pbUebcAnpgkIawIZqW4Du0G/r
GcMeWNBJp2k5Q3NydXNhv8FnwDi1B5O4Bk7wGD+Bu7/oPQ6SzBrmCFtXSBomAZ8+
/WrjP54KUD5/eDfrKaLd7mTtgmLxa5d+dq66WKQ6Ze0qvnUFSJs8uKfgKYsKShEO
0d8SU3JMMAjTZxwMwto//Zav8rap23tQXXkGAhM6P3HeaBL91vk1TumNVv8ySH3e
CKGWqob+P7rnn/eBuFY416l1F2AlCHTTjVJicUBfZB3ek1QXUorV3fc7JgEYoPqG
MM9GYMNs/k1YsIfAA0q3EFpuRobP7k0/NzDrq/+1kd3gMOT9Xf2diLgjUofqsyz1
frxCwcb01oYJXzIY1NdBrhagebReSWgmeOOYupvOjNMHn3CWYBp/jDPJWSXwE3K7
haH2g+dyNeEmkt2zjzeYhWOorMuat6AuuQQwWr1o9z0eVNOEc8RbRA+7XwJ/E6pK
jwKdecD0tIhhBm4pC14g0gfPY6fwHbgdb0AqA7NVhSMDOaeUgA/ZESRFfNkR3gIR
0eTby/ydFdfmzB2OkavP
=iUI8
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
