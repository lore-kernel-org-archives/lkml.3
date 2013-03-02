Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3CBXYk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 18:24:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48937 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3CBXYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 18:24:39 -0500
Date: Sun, 3 Mar 2013 01:24:22 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <kgene.kim@samsung.com>,
        <kishon@ti.com>, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 06/10] usb: xhci: Enable runtime pm in xhci-plat
Message-ID: <20130302232422.GD14558@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130302203908.GF12181@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1303021647290.17418-100000@netrider.rowland.org>
 <20130302232132.GB14558@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LKTjZJSUETSlgu2t"
Content-Disposition: inline
In-Reply-To: <20130302232132.GB14558@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LKTjZJSUETSlgu2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Mar 03, 2013 at 01:21:32AM +0200, Felipe Balbi wrote:
> > I don't know much about clock handling.  In general, the
> > pm_runtime_set_active() and pm_runtime_enable() parts should be done by
> > the subsystem, not the driver, whenever possible.
>=20
> good to know :-) Though I disagree with calling pm_runtime_enable() at
> the subsystem level.
>=20
> This means we can add pm_runtime_set_active()=20

ignore this last line, forgot to delete it.

--=20
balbi

--LKTjZJSUETSlgu2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMoomAAoJEIaOsuA1yqREUzkP/RFU9kRyZf14+k/53EJFboLT
NMA0EDE6i4L8Uvf76KGGiwh7Ypsf74mMtWrt731XrqqJUvJbFcze47TsrF1uXHRR
sqbyE2vad5T6CfD7aUFWVvw6vE9bKIpFwOcWEBGVbaf+XMVSv3Mq3JrWBuYL+ll7
en77THA8zT0C3D9CyAX/sG2GS4h9zaVi+NDsLBBRJeqrCS98ZZtgifWh6JtqP7Re
5l7l4dLMXplmC3+VdxKANcrcKyaDyFwHaMH6eHiEsTt9/tBHCCRQkuOp9Dj9esW2
24Li5E74yj2eDfkToCFip6ORxYNAmfiD1xjkc9VJ/gfpIu+P4noRlI19yfYzDZFZ
iWqnqAXANPKI7r6YHk/ZUzYc7EV7qchQlbaUD0/FwZjpnHc4aRT9QkRmZSe7ADhg
bqcrlZa2lnvBq7m1NBKanBqF8I14yWS7eQG5+4u5JUMMspzxCZgF5S7capSUIA+D
gHkQY/mtewJ6R65VyZTC8XYppvEdpoYSbyK3LOEqGkZFVBNLZ84+Ynr9hgREPK4J
fwe+1jofn1xD3UrQT2Hzg2NuYgMaTMn9E3llVjhXJZlx6XWTGWgSRN9vZzRB3SQ9
bz1mzXHS6EpIsdcDGhueUWHGcZ9V4EjyOSCNUq5R5fQwBIaJQ3+FEz/m+3EpX7xK
up23dblsEFWYFd2CgME7
=9N5y
-----END PGP SIGNATURE-----

--LKTjZJSUETSlgu2t--
