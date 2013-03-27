Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3C0Hv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:51:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44986 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab3C0Hv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:51:58 -0400
Date: Wed, 27 Mar 2013 09:51:27 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Roland Stigge <stigge@antcom.de>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: Fix compile error by selecting USB_OTG_UTILS
Message-ID: <20130327075127.GB23925@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364319361-28265-1-git-send-email-stigge@antcom.de>
 <20130326180334.GL20785@arwen.pp.htv.fi>
 <5151F48C.9060308@gnu.org>
 <20130326192453.GA21915@arwen.pp.htv.fi>
 <5152043F.4010307@antcom.de>
 <20130326203741.GA4227@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <20130326203741.GA4227@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2013 at 01:37:41PM -0700, Greg KH wrote:
> On Tue, Mar 26, 2013 at 09:25:35PM +0100, Roland Stigge wrote:
> > On 03/26/2013 08:24 PM, Felipe Balbi wrote:
> > > commit ?
> >=20
> > 1c2088812f095df77f4b3224b65db79d7111a300
>=20
> Showed up in 3.9-rc3.
>=20
> Felipe, I can take this directly if you don't have any other USB patches
> for me at the moment.

please go ahead Greg:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUqT/AAoJEIaOsuA1yqRErCcP/iruny5FHPwBjx5+F2mIRiGi
XLmWu3rxANyvmj2ig3V5D78r2/cRd6UuB6Iu2FbRr/U6C+pFX9mluPIq+/bj4WrR
FsHr0cTU3r6h9P2nWT+AKNx2mwLwfQo8WwWe6XBwffHEGUjkWMLAAaX3ZPVAMFTx
2FV/H2iBd7vzCkGEDhQ/7nVEwa8f0xTSSOPQtue28iEUbI6/z4JOqcUpUSEN3+Bz
O1CTD/RNXo09nH6XwBdbmEJsewOVf3YnYDZsVVtB0xYiGZikJXLLf29keDgAiJ0S
14fnVxifp99HyA3h5cgW+E4nGjRCQP+mviQtVzLVLz0vG8c4gvdIwqOCYIk13Mdf
WXciMv3FEhoDbEB+Nu2yHRB/olB2VQAJ/9A3ISuIpnNZgodG/aFjfyIMiAg4Ty5B
DjOR833A3x2s+i2k3CgbZRWIUn/4sn8wecNCHKOihGBV99h7AHXLf6dXhH8moqnD
FttB0JOs7Mit+OdjgfewODAUw3y1sTaeu1wXgTqfEg0aBG4tQ9XnHz/l28aye+0T
kGz3bBezLWtD9rUFbwLQcwJoKdC6MYSLFfa3ih7M7sC3guQtBwycgY0YQC9wgTib
NQuvk/fnallXBnTLpQUtQfjx2uNdhz061uYC2kroCiR7UmrnrqhgglsK3lsrJzFW
uXo5EoscjJ9EX+HyuXUN
=EvpQ
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
