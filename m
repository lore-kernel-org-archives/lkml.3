Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3AYK1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:27:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39892 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615Ab3AYK1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:27:23 -0500
Date: Fri, 25 Jan 2013 12:27:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <balbi@ti.com>, <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 4/4] drivers: usb: start using the control module
 driver
Message-ID: <20130125102700.GO15886@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359109440-2195-1-git-send-email-kishon@ti.com>
 <1359109440-2195-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXygN3QAmJYWdGtb"
Content-Disposition: inline
In-Reply-To: <1359109440-2195-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xXygN3QAmJYWdGtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 25, 2013 at 03:54:00PM +0530, Kishon Vijay Abraham I wrote:
> Start using the control module driver for powering on the PHY and for
> writing to the mailbox instead of writing to the control module
> registers on their own.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/omap-usb.txt |    4 ++
>  Documentation/devicetree/bindings/usb/usb-phy.txt  |    7 +-
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   13 ----

I'm taking this patch but I'm leaving out the omap_hwmod_44xx_data.c
change just to kill dependency. Can you send that single change as a
separate patch which Tony can queue ?

--=20
balbi

--xXygN3QAmJYWdGtb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAl30AAoJEIaOsuA1yqREU1gP/2I1Wkkkg/GoIVP3VrxRFT/6
eYgCznQW9qaMZ12A0YoqyLGUlOveIQXcchFzyZQQ+5EZzFVZDfXHhfRBdCpUOUzR
4bGHapU0fsJMAbmmU5qBELrU/ekUHUJCNLlBJB7q9qZcM1osPgrA5cpB8kD9wgjh
tG4yrS6qEuo703SY+0O1n1aEOMM+n4gETxD74BJlwS0R9HLXD6JZ1Nd9zzWU1JQW
cS+2Wrb7Q62pPvDfWliDBfqQAXuHagt/tj+4LwLO/Le2rWwaCoBh/ozv3DkHGxKS
qpNHGApMKJTRuNnQ8wd+ZkjXzmEZ+Y5QQtWOqeFCJB2m8QFaWovgUJZeI/UlTQvq
wACUY3b/XCrr1oC4M3JOzFYfFEjoXXW4U8QlvWRIWHe1Rb/BusLRor8gnZhrQ8hV
ocrSKELWQzsV/s5gbc3q47sGGVMaq3LOgA1M0Usv53mA60W/EnBaxcq+tcl9Dj/t
ACsS6GoIqsj4DH1zLUI5ftTKO3GkBdexL+YRpmtaJoeSrQum+h/qdqmCMWCx/RNw
9674Gn9HDT+UNebpX0MjQOQCqfMJt4gMibzPyNF4VYh/EDffjxkYHMqAPBwlcZd1
Qh9Z6+m5JZEIvOo35wSkm2UNuet6lLUO+uJH5IlYBXItdYmwb3sc4otmV4La1gaO
Ndx5p2DFCZ1hf0xy0FHk
=cDOB
-----END PGP SIGNATURE-----

--xXygN3QAmJYWdGtb--
