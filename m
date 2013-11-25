Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab3KYTha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:37:30 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52978 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab3KYTh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:37:27 -0500
Date: Mon, 25 Nov 2013 13:36:58 -0600
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [RESEND GIT PULL] USB fixes for v3.13-rc2
Message-ID: <20131125193658.GY18046@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385406153-28085-1-git-send-email-balbi@ti.com>
 <20131125193348.GA25899@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MRlEjvj2/M31Nfs"
Content-Disposition: inline
In-Reply-To: <20131125193348.GA25899@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3MRlEjvj2/M31Nfs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 11:33:48AM -0800, Greg KH wrote:
> On Mon, Nov 25, 2013 at 01:02:33PM -0600, Felipe Balbi wrote:
> > Hi Greg,
> >=20
> > Here's my first set of fixes for this -rc cycle. Please
> > consider merging them on your usb-linus branch.
> >=20
> > Let me know if you need any changes to this pull request. I
> > did a test merge of this tag with your usb-linus branch and
> > it merges just fine.
> >=20
> > cheers
> >=20
> > ps: resending with lkml in Cc, looks like my emails aren't reaching
> > linux-usb@vger.kernel.org and marc.info seems to not be picking up
> > any emails at all from no list.
> >=20
> > The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e=
42ae:
> >=20
> >   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git master
>=20
> Really?  I don't think that's what you want me to really pull...
>=20
> I now have 2 pull requests from you, which one should I use?
>=20
> How about I drop both and have you resend the "real" one?  :)

hehe, sorry about that, looks like I had a script bug :-) Will fix it

--=20
balbi

--3MRlEjvj2/M31Nfs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSk6baAAoJEIaOsuA1yqREWAEQAI9zRRlY47rrcMvvkha+hVt6
J9wRJhsE+VTSPD9YtyA4qXEngQ2h3QVGlwfYJpfllBINjSwnLAK+HzBU8SrT3I05
tjYF+zPpPt83tj3cy/epK12wk/H9x1F4JsZ+EmMEfJ8Yc/l6eM6KcM4/lqa5hVLj
vnTjiQt7oSbZn5krNNHfE89TkBorJ6w3om5Bh0GsKvzIf82LJ91Y1xoNcLYO9i4S
Idnr/NHJX784FlWBBBlC5tdYO/H0QLy7vigf0lGrRl9G292ROOy2nxARJFQ3eid+
AxldOew87TNeoUsWhjQwNZie80q7iJOAuKBlz9QrV6Mg7pCgwnq8kskK9FKP3bmS
yNoaCMjSgWj3K3z/xAJcpNatQIPQkuB76BOGI0a5BD3q6JQZB5c1eNesjzwB9/ty
GLS0XWqqSAo95S8diFcW2iNthlVP6KheucbQ0OeiDMmTalrWY89BJ6tBIpT78pC5
Zp45+eIOh0TyYGI9t+dMm7hFy0sHMbusF+ffjXkR7noPoLuy9/1b/ui1zFNpnZTG
X1/FaXcp3MJrVaGb1q8tKEdXvVHhrnMadxK3JrItXvHfVX34oMbq2Mwr2S0oDKK6
xU2IAWMo34LCC8u6q9QNVBQeXw5JKU8NXXMY0oQCXPM9EAsOjIpubJa3XHt+RITm
lB7X8s9MXaRDEBBMmPyh
=ynBV
-----END PGP SIGNATURE-----

--3MRlEjvj2/M31Nfs--
