Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaJHAby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:31:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58642 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbaJHAbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:31:53 -0400
Date: Tue, 7 Oct 2014 19:31:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <mina86@mina86.com>,
        <r.baldyga@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH] usb: ffs: fix regression when quirk_ep_out_aligned_size
 flag is set
Message-ID: <20141008003144.GA9957@saruman>
Reply-To: <balbi@ti.com>
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 07, 2014 at 05:18:06PM -0700, David Cohen wrote:
> The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the

did that commit non-aio or is only aio broken ?

> quirk implemented to align buffer size to maxpacketsize on out endpoint.
> As result, functionfs does not work on Intel platforms using dwc3 driver
> (i.e. Bay Trail and Merrifield). This patch fixes the issue.

and Braswell.

> This code is based on a previous Qiuxu's patch.

How have you tested this ? Do you have a test-case to share ? Then I can
add it to my tests which I have been running on my platforms too (they
include USB20CV and USB30CV where applicable - quite a few fixes coming
soon).

cheers

--=20
balbi

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNIXwAAoJEIaOsuA1yqREK2UP/iIcBhAzm+ZAybvt9DMKQvov
M11imP1BRHjc+tremynkaeo8nVOJUTT5H855vCg07wVKJeTEdI4boO0Qq/LuIUWF
E58urjTh3XXoJbO/n9ica9THo2uudVU8eoHcEVSx141N1yvb1AMBMbVtIqRQGqCB
yF/oG7Klkqd9TtwWWhVwblPtaNAwVt+wWcS/nNHXf83WdEy2Jl/W6X6aMcWayC+v
winE6BzuFWtWy/r4g8uvlNI8ZdAqJrIFmT/15uOS6AGnHaPXXbwoa535QtiCrRPe
Yoz5iDm6hFTechgVLpqyJPyQrNcr372NPStdQpYn0SCANWrx+7+4zvsrifAIF8ov
Foa7Eux+RCJUnYOMK1uT20Wrr1MC6rKzvLlKV6wLVsceREXK5AhqQqKl/+AvbUtl
LnLwvSiaeoumC0bG1hvedIDLAWYexiPEzRbL94sMznfxLPP1YuyiBimTUrUTzLsA
79kE/NLTm08esfpgnLIa1+0KGgV9jZ8guLNrqXx8VlB2NEMvjMnkzDlk6OR8uehT
ftriNw0cCGRaxGAKVqMEJ3w1dnvdBSTh+ZmmAR7hQrdciLy6zL2GsLZOoTK/UAd4
dAUE38zawLFC9DY03ABJkdr1EeYRE8yUVRiQCZFCHwrWIr07rRdDU9h9yenyhpG8
I3ZCKL9rjq3JJWLgSzv6
=f9pL
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
