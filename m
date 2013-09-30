Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3I3QWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:22:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47216 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3I3QWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:22:36 -0400
Date: Mon, 30 Sep 2013 11:22:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: David Cohen <david.a.cohen@linux.intel.com>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: add support for Merrifield
Message-ID: <20130930162224.GC23534@radagast>
Reply-To: <balbi@ti.com>
References: <1380225704-28923-1-git-send-email-david.a.cohen@linux.intel.com>
 <20130926201454.GC16369@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Content-Disposition: inline
In-Reply-To: <20130926201454.GC16369@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 26, 2013 at 01:14:54PM -0700, Greg KH wrote:
> On Thu, Sep 26, 2013 at 01:01:44PM -0700, David Cohen wrote:
> > Add PCI id for Intel Merrifield
> >=20
> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > ---
> >  drivers/usb/dwc3/dwc3-pci.c | 2 ++
> >  1 file changed, 2 insertions(+)
>=20
> Nice, Felipe, mind if I just pick this up now, as I'm applying USB
> patches at the moment...

Sure, just go ahead.

--=20
balbi

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSSaVAAAoJEIaOsuA1yqREDeQQAK1V8tLzD3CkMSUQICxVxazd
6HDgR8yFaTMJFKgL53lGtK3LRhngjPtqbXl7NDVwWivHeCsr4Ui0xI6MomOK/aL7
Rss35VeIzUCPNgEWt/+dX+OI+/lhvG5+tT0siHx+7g16X+JXKJEoN8jWuqGjLgDM
RUH1C4wxUEqHrLy0tJRHLDPiwkGdo1wxAxtpcjny74ER+LF18NBzRGjhWZOjoDGx
twUKWQYMJ61NC7Yqluqf+AQ3NR1qXiLutgwj5lMnycyTGTu8OKw3y/SwfkSaLMlZ
N6RKhVQ0X8iis1HcJ+1Hk7oLTX2j8ZrYJM4omcFdeMsq0qJCEaqJZO1RL0wZY2JM
TC3bGuTKfkIQQ4qoXab2QvwTDhJtHABjY5qM5q1nwk59zp3QfeYRdrOlyeEOgGnT
NZS7Q5i2l3WXiIAasH2Uttc1NPprIv2XbxzB1Gt9VTi3ZD7tpaao1AhgR7BsivNp
i7IsZAHA30nDpNJeeqxZUEACqv/Xr4mYKWHcWeCbw0i2StOT+8M+CjqZTFJAc8ai
DaEy23PeOzZn3ArtBWGipdDvLGXP5Orxtd6FEvkYqd61ycHbSorrnf4L9J8ELixx
PW2CojarAUCkhFNzAfJhtbJ2jr3v0YREIGcVPnx+eDkRAMXmSwUpE7X+4ZNigWa+
/ZeQgPQQFbAE/8S1nW7e
=IXHw
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
