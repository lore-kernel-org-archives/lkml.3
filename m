Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3AYJAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:00:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37051 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3AYI75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:59:57 -0500
Date: Fri, 25 Jan 2013 10:59:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: <balbi@ti.com>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <sameo@linux.intel.com>, <gg@slimlogic.co.uk>, <s-guiriec@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 1/8] usb: otg: palmas-usb: make palmas-usb as a
 comparator driver
Message-ID: <20130125085934.GJ15886@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359083551-8524-1-git-send-email-kishon@ti.com>
 <1359083551-8524-2-git-send-email-kishon@ti.com>
 <20130125074339.GD15886@arwen.pp.htv.fi>
 <510245D7.4090008@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MHXEHrrXKLGx71o"
Content-Disposition: inline
In-Reply-To: <510245D7.4090008@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3MHXEHrrXKLGx71o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 25, 2013 at 02:14:07PM +0530, kishon wrote:
> On Friday 25 January 2013 01:13 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Fri, Jan 25, 2013 at 08:42:24AM +0530, Kishon Vijay Abraham I wrote:
> >>palmas-usb is made as a comparator driver to omap usb2 phy, so that
> >>omap usb can make use of palmas for srp and also to set vbus.
> >>
> >>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >
> >doesn't apply. palmas-usb isn't in mainline
> >
> Yes. We'll ask Rajendra Nayak to pick this up in his tree?

Eventually the final version needs to go upstream, though.

--=20
balbi

--3MHXEHrrXKLGx71o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAkl2AAoJEIaOsuA1yqRECbQQAJvHmPUbs4xx896cRy66Vz6J
46Q6v5R4CtIXGt7nCTWd8Cnpla9YsfGiXg9igm8xHIvmFS8KuPvzBNEwR5Xq9enI
ostktytTV81kKt/rtU7qEpct9VwFI8YQnQl8AN7pUqyJNMmVTe5t7bLCRdp1rfP0
zEo2bOzodkgvEXjNYzjN3XheSqeq+fyHWvKe1RN9A72z49hpDatW/6G2Ijs8i/qg
RDTfLaJkL5h6f1i6lTC2Yb3LUsDo6qcCMXaCGL3V7Nrg9ElaVHJMgrvP2n6SsY6T
CklW4dBg9WMvt/m9ABcZPI22hO+6CkmnK/DeGbF3poubNLNjFyH384Ta3J25hvE0
lfVcB46swosjo7SyVDuaWvS2Z9Bre0P50WLv3ej2Fsno1GMKveqsPt5ot1SsZ4FQ
KJvWa3Ga6zYJZrFy4oDliy9q8tRlG4lwg5slQpZ8PcVQYfn3uX8gOaHHb1OWeSDT
53y1KMi/mYOeJS7mFEeury4E2E7QoPN1Sg9Yn6YmA+XYo++pN/KAXGa+OOHUyXnv
4MRvO7EzvUl126dAC91Wey/aFo9UU2gUcCaC1akrSLmO+3UQb6XjNvEKRBOBcw2q
2/pzK94VD6nDEBYbLALd3cJNOQisr9EH7bUje3XS1QzL1Amnp+dgRTU4GTEUVwKU
VtCcghvDiArFoeOBkd36
=NTLP
-----END PGP SIGNATURE-----

--3MHXEHrrXKLGx71o--
