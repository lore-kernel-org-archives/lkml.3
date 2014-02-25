Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaBYSOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:14:06 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59425 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbaBYSOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:14:02 -0500
Date: Tue, 25 Feb 2014 12:12:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <Peter.Chen@freescale.com>
CC: Neil Zhang <zhangwm@marvell.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Message-ID: <20140225181234.GF23275@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
 <20140225011839.GD7540@shlinux1.ap.freescale.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
 <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A5@SC-VEXCH4.marvell.com>
 <bce87beb86d34377ac3dae0645622edf@BN1PR03MB235.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="65ImJOski3p8EhYV"
Content-Disposition: inline
In-Reply-To: <bce87beb86d34377ac3dae0645622edf@BN1PR03MB235.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--65ImJOski3p8EhYV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Feb 25, 2014 at 07:46:08AM +0000, Peter Chen wrote:
> > > > > > Hardware zlt will try to send the zero length packet
> > > > > > automatically when the data transferd is multiple times of max
> > > > > > packet, this will cause issues on Windows.
> > > > > > So let's disable HW zlt by default.
> > > > >
> > > > > Would you have description that what kinds of issue on Windows if
> > > > > zlt is is selected?
> > > > >
> > > >
> > > > Enumeration will fail.
> > > >
> > >
> > > What causes enumeration fail, why it does not occur before?
> > >
> > A unexpected zero packet cause enumeration fail.
> > It's not easy that the descriptor is actually 1024 bytes, so not easy to
> > be found.
> >=20
>=20
> Chipidea bug too? Does it follow ch 8.5.3.2 Variable-length Data Stage, U=
SB 2.0 spec?

wait, this is a chipidea core ? Why aren't you guys using the chipidea
driver yet ? You need to switch over to that driver dude, we can't have
duplicated code in the tree.

I'm sorry, but I won't be taking this series, please use chipidea
driver, it should be very simple to add a glue layer for your core to
the chipidea driver.

--=20
balbi

--65ImJOski3p8EhYV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTDN0SAAoJEIaOsuA1yqREVLUP/0tYu9VNXMLJDuqHubTLmqFQ
TQ0KSZbjZBBPMRa3xaZfvIORKac6LwBHueP14qyF5TwfTlUypiMLxrnERe8O2qrl
42PjvyxRBaJNK3t3DwFQwYFHRTwdkYKc+MyhSlq50IljG3WZu1CG2Q5lNLZtpfLp
27O1c1E0nSomzObPwr5b+aCtBiblvKJVN8g6JET+M0Nu7kMKn7LoWqAW7jbPjRHE
TIJfFRA8MGStwV3GZ4eHHL63CPk2VUMqufedqOabXMK+lCtLDzIA4Fzn9QO2qPrH
NBFUktK8VQvIHFQeFIzSloIwKDxptfJy2vbUUgKjkWE0eAGw8HK6v2vawEjmq8vO
H7JjnuL72Uscvhd4/Oe5vArTraO27tEXGVbNTuGQDfhfdsdaLxxTJSX3Auns8MVz
z6Px94lYnO50l9V/eyQ01qUii42YK/lEZlZQRVQdttGeQccUSQutUhjqrhjbZoir
L0YM8p6Epefje+DNHu2ejAmj9I9A8gWmkp94uQ5pxFq3P/WvX0fDtbNVGAgCgT8I
JCkjd/OUMYPckAz0NWUC6K9nQVB8rFwTINPakaeupSGtb1XPT/kI8fysGx6/zE7o
10gB80KhrVsOhMlEhKX+0px1wFOB3QoXIFSA9l6KPH2nd8Pxeiby6aFpC3wPBUMf
scoDMfA6Onn9e1MCmRK7
=lccO
-----END PGP SIGNATURE-----

--65ImJOski3p8EhYV--
