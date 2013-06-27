Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab3F0GgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:36:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56993 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab3F0GgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:36:06 -0400
Date: Thu, 27 Jun 2013 09:35:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michael Grzeschik <mgr@pengutronix.de>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, George Cherian <george.cherian@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: dwc3: core: continue probe even if usb3 phy is not
 available
Message-ID: <20130627063526.GG15455@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372238954-29047-1-git-send-email-george.cherian@ti.com>
 <20130626101647.GT12640@arwen.pp.htv.fi>
 <51CAD977.6040309@ti.com>
 <20130626121210.GA12640@arwen.pp.htv.fi>
 <874nclghu2.fsf@ashishki-desk.ger.corp.intel.com>
 <20130627061416.GI3523@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMnpOGXCMazMAbfp"
Content-Disposition: inline
In-Reply-To: <20130627061416.GI3523@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eMnpOGXCMazMAbfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 27, 2013 at 08:14:16AM +0200, Michael Grzeschik wrote:
> > > right, but in DT you will define both instances and each instance will
> > > have a seaparate snps,maximum_speed attribute :-)
> > >
> > > I'm now considering if we should make maximum_speed a generic attribu=
te,
> > > Kishon ? Alex ? Alan ?
> > >
> > > anyone else needs such thing ?
> >=20
> > We have a force-full-speed attibute for chipidea on the way. This
> > maximum_speed looks like a more generic alternative. Michael, what say
> > you?
>=20
> The maximum_speed attribute sounds more reasonable. I will change my
> patch to it.

thanks, perhaps we can add a generic helper in udc-core or usb-common ?

--=20
balbi

--eMnpOGXCMazMAbfp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRy90uAAoJEIaOsuA1yqREIskP/RgjxLOCV/EhWt2YgTwJjnEx
RzLemi4mmF+GNWJbjvJKcNLG9sO8hVrryB0LTLJ1p4D9lnQxgefwP4qQe/kL1241
I8o5zhUg4llmj70+I0GODn8o4HxN5y+6l7/N5vBfcYKhne+G4u2GhshlT/ApY4iJ
DAHoE5JBbou0dUp4kccHu0YnlJFm46caxgoQBSxA6I5v+xbcsrjpz0fvrGoV13P/
ZDajk9wAnWPi/+nhgUav/B1PpiDc9vPLi2h+Lgjspc/+NugpEp5tSeS1iZpREqBG
z+gv19ergh5oWr4mxKcv+S+6uDtJ1mRQpbnZGy4ir01GoRMOlP9xxeyH9Ocx87J3
u7bSKRnFbcN5WxtvP5WnXGfM6X99HtLsVQ1hq92zYP6EecaRCmiyns4b4+XTQxln
9BcPz4hxc/q22gSfXKwHfnrxG1CoRgc0VaOT3KxfFv3VZv4aNQZnMnMfFNH+TU7a
BenP5kkHoG3Ig4rB5yxlLNUD/Z5Y8CtmvVQe44pBsJD9WDx66mP8q5r917NB6NmN
I6czTyzUgZggDnnmZahV+At9wSrm13q0K4kUEXxUbkUcJIth4L4wLYox1ZkX8dRJ
duokRhNUllGzobpuJyzSGh9NgHAeiWlYfv7+a46Hvq5T9hPB+pUZSr9FxbpSGU9Z
rYyaV07DhRCAoeIJm9U5
=x5ru
-----END PGP SIGNATURE-----

--eMnpOGXCMazMAbfp--
