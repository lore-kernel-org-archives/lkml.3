Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaJHAdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:33:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58263 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbaJHAdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:33:05 -0400
Date: Tue, 7 Oct 2014 19:32:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <mina86@mina86.com>,
        <r.baldyga@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH] usb: ffs: fix regression when quirk_ep_out_aligned_size
 flag is set
Message-ID: <20141008003256.GB9957@saruman>
Reply-To: <balbi@ti.com>
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
In-Reply-To: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Tue, Oct 07, 2014 at 05:18:06PM -0700, David Cohen wrote:
> The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
> quirk implemented to align buffer size to maxpacketsize on out endpoint.
> As result, functionfs does not work on Intel platforms using dwc3 driver
> (i.e. Bay Trail and Merrifield). This patch fixes the issue.
>=20
> This code is based on a previous Qiuxu's patch.
>=20

btw, please resend and add below right here:

Fixes: 2e4c7553cd (usb: gadget: f_fs: add aio support)
Cc: <stable@vger.kernel.org> # v3.16+

> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

--=20
balbi

--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNIY4AAoJEIaOsuA1yqRETZUP/ifHVFUy6P8yOwgYm1Wrzppc
ahlFpBnLA7E36rxwSC4cvKfaYF98OmGxl5G/EMwtdm13zjRhZskVzIWncVkB44Cb
0I89HEJMSsscIKD/5Vnw9wyvd2DGej9d4Dob3AKcu0RiwzJO2y1sQn4emsGweOul
h5fji6T+/9I2sKjqkDexPaItjGcrIiPmyTJ8WrB5vc1TdvDafIeH4NwALO/IZ7U9
fT4upfYbrZyFVxBDbMLvF4ePsjUnombmZtlaKmABVbeh8mtpI4eLGEihixWIwiax
07buEoS8J3ZjGgHxnHQnq6bztbhD4AcNW8Fh7BQqym/ypq59At/VWlNLXpHAaG1d
3pbfsOIHJE5NqOgKyG5Op5NTZqVyPTAK4BbCpxlYjhiYnnOADCVw+nMjyEre7eNs
MxY2Qlsl6rSO/vF4tIekcqOkO2eu45iGhfFeel2wzbR0O1D1gReaQTHhnw8l8Gsb
DGhSnGzf4882AzD1CBajxTFgWa+SxalNIW9bxDuFrhFYrS7025BnuSSEt+RgPo5N
SBWxk2Vq58ev3bqXUXXkaX9IBgZxDtxZGMa92NA2gJRne9VlOJNvEhrGLF5h+wEX
cK543xDOKYl2WDbsmEYkOooY7IlzMJvDQMeIxueZndqf+lZ8y2fB2h1OKll8m9fE
G6ohi4aQu4X6SA6BWbjC
=oWXR
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--
