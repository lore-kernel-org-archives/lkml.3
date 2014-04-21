Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaDUQRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:17:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51748 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaDUQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:17:11 -0400
Date: Mon, 21 Apr 2014 11:14:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tim Bird <tbird20d@gmail.com>
CC: <iivanov@mm-sol.com>, <linux-arm-msm@vger.kernel.org>,
        <galak@codeaurora.org>, <balbi@ti.com>, <davidb@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Tim Bird <tim.bird@sonymobile.com>
Subject: Re: [PATCH] usb: phy: msm: Select secondary PHY via TCSR
Message-ID: <20140421161442.GC22794@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396649891-2880-1-git-send-email-tim.bird@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline
In-Reply-To: <1396649891-2880-1-git-send-email-tim.bird@sonymobile.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 04, 2014 at 03:18:11PM -0700, Tim Bird wrote:
> Select the secondary PHY using the TCSR register, if phy-num=3D1
> in the DTS (or phy_number is set in the platform data).  The
> SOC has 2 PHYs which can be used with the OTG port, and this
> code allows configuring the correct one.
>=20
> Note: This resolves the problem I was seeing where I couldn't
> get the USB driver working at all on a dragonboard, from cold
> boot.  This patch depends on patch 5/14 from Ivan's msm USB
> patch set.  It does not use DT for the register address, as
> there's no evidence that this address changes between SoC
> versions.
>=20
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>

doesn't apply:

checking file drivers/usb/phy/phy-msm-usb.c
Hunk #1 succeeded at 1412 with fuzz 2 (offset -106 lines).
Hunk #2 FAILED at 1581.
1 out of 2 hunks FAILED
checking file include/linux/usb/msm_hsusb_hw.h

--=20
balbi

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVUPyAAoJEIaOsuA1yqREYcgP/RDpQuqIuIIuY3UOA1hQHnWh
MX60PGqK/5/7jBBXleZobBPkpf+s8XKdt9PnObaMQBmVaOG0gNn9HVX7qd4rEMOr
vGgTVqfRyG0i8IcISj+28tNHNT4wEGLEPl+T59VHuoZxQRfGLXjAmUaohlb6hopM
FUHm7TJJf3kaIwbTF7X3IzskmCM268SPWi0JJTJiDBreWI9OVlChKU3C25bnbiqU
dEme/lrHmYjsO5ET3P08ozesWo/itfTequJrzBrqlhDjcB1EmlYr6/eevfNdati3
Rst/QXQkl1Tr2/M7YsX9ORguTHI5ed3MTJS+6b+7CBS4yICIgtpUHeWlJ0OQqYxL
hdOZSGL8Zb3mtl6+KQUG+j+gp5PWAzDhAy97EgjxrDAhZP+HejLm/DtMQwwV21Cz
f5z2D4p/wxfaDlmcd3zZeVYXuU/owI8xiF1vbVeDDU+jRG9Q+rqq23Hxme+PCY7U
dlLOnNhI7OkSjM9bBztZ0MkVJlFW3xhBgRPeAYBlLQt2jigMj1FmmFGyQgsYlUj5
48L5MBjrVXW0RQRDOdf7aJERZbHWdUtKvVS5GdXYQS2V1nt79tvmng8gav7DdWPR
O8dJjpWK7R45AxXwZ1B0XSYlb/j7gAbhnWciLfjCoLGcXDAOOXWI6pF86afe5M9K
zOYnG34LvnDipMwbyhA+
=PJoG
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
