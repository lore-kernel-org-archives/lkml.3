Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaCGQ0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:26:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36789 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbaCGQ0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:26:03 -0500
Date: Fri, 7 Mar 2014 10:24:06 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, Roger Quadros <rogerq@ti.com>, <tony@atomide.com>,
        <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 5/8] phy: omap-usb2: Add clock names to Documentation
 binding
Message-ID: <20140307162406.GB23885@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394197751-28984-1-git-send-email-rogerq@ti.com>
 <1394197751-28984-6-git-send-email-rogerq@ti.com>
 <20140307160422.GA23885@saruman.home>
 <5319F267.3080309@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline
In-Reply-To: <5319F267.3080309@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 09:53:03PM +0530, Kishon Vijay Abraham I wrote:
> Felipe,
>=20
> On Friday 07 March 2014 09:34 PM, Felipe Balbi wrote:
> >On Fri, Mar 07, 2014 at 03:09:08PM +0200, Roger Quadros wrote:
> >>Add "wkupclk" and "refclk" information to DT binding information.
> >>
> >>Signed-off-by: Roger Quadros <rogerq@ti.com>
> >>---
> >
> >so, should I take this one ?
>=20
> yes.. the ti-phy.txt is only in your tree.

yeah, I know that, but I need to know if this is safe to be applied as
in "it won't change anymore".

--=20
balbi

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTGfKmAAoJEIaOsuA1yqREmxEQALYnC3r4FzQsBjhHagyMOx/L
xAE/K/glxOmA73sBtp8tRnse0xo9v++XBEQxhICTpw08KFmEsopPtMwU5RMKRJ+v
OzCQLtCTphZ2PB+mnW+yw4BmrHorN8mQPCR1vIaYTpIITiXz/1lUpNT7dqBFu5Ob
Ps9CVi6ZwH3o/sUZFLCUQKUM1lDC8EjGFeA/Qv3XaH/Xe3Z6tZ25swVmp1qxNWbr
sfoZ67r7tUd693ZXM1N/tlg/527sqFRF8+DvD1xO6Ug03hfxJimXKzt9Gx9Sc9Rz
L8OlFlozwGlPlOdXlQsnnbCRYL70z4hiEoCg51IfZLWR5sS+QSv15s4FbMic5EwM
PMVQwg3EdMT8phXvaaDeWTYPuLJ+r/0ifSsTPL+KxCjNvPd7y7maoHcSagnowIkc
fYCP0fBzlvIfLjhBFhs8JHoYhiQzsCQZOYjXXwZIJ5K20/4NSAr+k3yeh3NGqa+0
i/cSrvG++rdi/vrNAtDlKJ4Q58g/kfHpJTBTE72a8RZmuITz9nV0B0SQyFfxJ/9F
Wqb5NBMhzwil+aM+YDgp1XzxCgJo0br3aSwMoyOsSWPnaH7bkc7h1T9XUmUSK6iV
s5icimkPU+YFpx3JPW/JnA0W9YDOkzBYP7soO6S8tOqP/qgJj+lCZ60eRh+P6XfA
aAde7QbA6cjBbBqrSidl
=m959
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
