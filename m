Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab3BSJ72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:59:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39370 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757087Ab3BSJ70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:59:26 -0500
Date: Tue, 19 Feb 2013 11:59:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BONUS PATCH 2/2] base: core: WARN() about bogus permissions on
 device attributes
Message-ID: <20130219095910.GH23197@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1361214544-14403-1-git-send-email-balbi@ti.com>
 <1361214544-14403-2-git-send-email-balbi@ti.com>
 <20130218191719.GB19724@kroah.com>
 <20130218192010.GE10755@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K1n7F7fSdjvFAEnM"
Content-Disposition: inline
In-Reply-To: <20130218192010.GE10755@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--K1n7F7fSdjvFAEnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 18, 2013 at 09:20:10PM +0200, Felipe Balbi wrote:
> On Mon, Feb 18, 2013 at 11:17:19AM -0800, Greg KH wrote:
> > On Mon, Feb 18, 2013 at 09:09:04PM +0200, Felipe Balbi wrote:
> > > Whenever a struct device_attribute is registered
> > > with mismatched permissions - read permission without
> > > a show routine or write permission without store
> > > routine - we will issue a big warning so we catch
> > > those early enough.
> > >=20
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > ---
> > >=20
> > > This is completely untested. I have only compile tested
> > > to make sure I'm not breaking anything.
> > >=20
> > > Greg, do you think this would be nice to have ? I could
> > > fire up kvm tomorrow and run on a few of my OMAP-based
> > > boards to make sure it works as expected.
> >=20
> > Looks good, but you better fix up all of the big offenders that this
> > points out, before I apply it, otherwise we will get a ton of bug
> > reports :)
>=20
> sure, will do that tomorrow though ;-)

Just tested $SUBJECT and it didn't trigger any extra warnings. Only the
one whose fix you already applied (I reverted it to make sure $SUBJECT
was working as expected).

--=20
balbi

--K1n7F7fSdjvFAEnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI0zuAAoJEIaOsuA1yqREawEP/1jnH7qeONp0Zu5JxBDpkXWr
dfuYcKX8ngcCgjDD+CQo/xWQuY8m+tcwpoW7bd61WYD+QZTwz/nkvIX89+8nHcyT
yIkFZYPiN5U+BzTkCcuuG2ioGPdwKfcfeveKW9rlFIKe4ntys4ScCgelLiNfPTA9
u4eLzd9Gxx70J13cvJidhHqtxa6QUSnPfx2qtk6Usoe+L0Ibp7pICdk0VmOD/Zmu
NvW+jdvSbJzaK/urXwN7Xt4E7Gfo4MbX23bMwtHfN3/u33v5AYKzEYsdrG/ilZyq
90SqIUak/d8ONut3XVNQ5Rs1ggnXhmw6QoLV4QeRqJ6AudOFBG5micWBIXC/cWf5
XR8uq7N6Gzlz+bCGYwBReIX4tPSzI1W0wI5+GLJ/LxVDw2KtfJ2YXMSGBpGSwtdJ
OP94H17GRHMaQRrXs15XbA5oIjysBFqwgpEkLkrl1zEAH7uWCmsosMrP3ieCRT7l
PkOVAFRhc+Zeu6hSDdXInGoVC6vLWHdb3oda+wL8gj4tpJHOyuzBeQtdCI6RHmUK
Pv9iKB2tozpptxAN/tnh7npXXeqPL9dBSe+jGwuqsZZ1DfCoeQUltCykkKAs9zbu
WuCoFXJscFwqBVHH52Ls/K6bFVGbJ6q0oGb0N0YjDAhPgu+qjb4KgI3HkbhcbAjC
Oai7tPGmL0sV29mRzdwD
=k08+
-----END PGP SIGNATURE-----

--K1n7F7fSdjvFAEnM--
