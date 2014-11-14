Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161989AbaKNVCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:02:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36485 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161709AbaKNVCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:02:22 -0500
Date: Fri, 14 Nov 2014 15:02:32 -0600
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
Message-ID: <20141114210232.GC16388@saruman>
Reply-To: <balbi@ti.com>
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
 <5465C06C.90705@linutronix.de>
 <5465C75D.4070909@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
Content-Disposition: inline
In-Reply-To: <5465C75D.4070909@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 02:41:57PM +0530, George Cherian wrote:
>=20
> On 11/14/2014 02:12 PM, Sebastian Andrzej Siewior wrote:
> >On 11/14/2014 09:24 AM, George Cherian wrote:
> >>Disable the MUSB interrupts till MUSB is recovered fully from BABBLE
> >>condition. There are chances that we could get multiple interrupts
> >>till the time the babble recover work gets scheduled. Sometimes
> >>this could even end up in an endless loop making MUSB itself unusable.
> >How do you trigger the babble error? Is this something that happens
> >during suspend resume, plugging / unplugging a device or randomly while
> >the device is used?
> I have never seen this error while device is successfully enumerated and
> while working fine.
> Mostly u get it when we connect/disconnect devices to HOST port.
> Normally I use the following for testing BABBLE
>  - Especially when a fully loaded USB HUB getting connected to HOST port.
>  - Or repeatedly load and unload musb_hdrc.ko with some device connected.
>=20
> If nothing of the above work you might be the lucky one to have a good
> board!!!!

if you have a BBB, connect host port to device port, load g_zero and run
any of testusb test cases.

--=20
balbi

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZm3oAAoJEIaOsuA1yqREPscP/j6H5NKh3tcHUGd0nLkOi0sp
oUWaj4NQP99FVTP9SCnUX8ponUUM6+2hf8mUUEQbUeM3QjJSPdj0RLVDgQexqya3
577hxoviFY6vmJSWs+OM2wAwFYJ1siVUsUB0FoEcy/oxh/aM09o5w0MbN+E3N8rH
KkOiXu0IhZPcQYZdfrxLXh7ivaAPhl3y4XC+fj2SWue2+ln2NnMUZleK4XVPhdbJ
qbBrsV979wBfD0QuT1AdLUL2o8YN0lzPj5niWsOvGVKDRkofJI6E3KpgdBhMpEFI
3QByAxxzMymtPZ0cVLBWORZmhceDQ415qzFopv0XsVun3uVax6U2kpGgTcoXbasT
H76v1t6PJAt6d6Xtebi04POhg+l3VNFISbeuxCtL794xId61C5V1jO7n/IxEqzn5
jHOyoK2pk9+VIdwtj3n6ArWlu43YpW7iOBp96u0cnlt1Ac1lbTZYyVcXkOum/zWf
4gN9epWL5HcaYwifFXD+6DnK/2JgeIZajRDkOXFUaECzm4fUFWQHWjeKVs3gYEvX
bS593KcyycVdLbP0cfTIcEsCrYz3xU1i6Pq1ZaQdXKNPLtCBG52/7wd34VIwMJpV
fNYmFZWx4YkMGBu670wYSg8epH+hBoatTR4NZz62FOfsuGpadfWNhMnfXnCWDN69
blr7XOiwyewt3oL8X7RX
=XV7G
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
