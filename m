Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbaKMTNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:13:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58255 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614AbaKMTNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:13:20 -0500
Date: Thu, 13 Nov 2014 13:13:44 -0600
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.18-rc5
Message-ID: <20141113191344.GG12546@saruman>
Reply-To: <balbi@ti.com>
References: <1415652779-31904-1-git-send-email-balbi@ti.com>
 <20141113180517.GC12546@saruman>
 <20141113191159.GA4115@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuhbYIxU28t+Kd57"
Content-Disposition: inline
In-Reply-To: <20141113191159.GA4115@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IuhbYIxU28t+Kd57
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2014 at 11:11:59AM -0800, Greg KH wrote:
> On Thu, Nov 13, 2014 at 12:05:17PM -0600, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Nov 10, 2014 at 02:52:59PM -0600, Felipe Balbi wrote:
> > > Hi Greg,
> > >=20
> > > Here's another minor for v3.18-rc5. Please consider
> > > merging to your usb-linus branch.
> > >=20
> > > Tested with AM437x SK and testusb.
> > >=20
> > > cheers
> > >=20
> > > The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5e=
b06108:
> > >=20
> > >   Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)
> > >=20
> > > are available in the git repository at:
> > >=20
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fi=
xes-for-v3.18-rc5
> > >=20
> > > for you to fetch changes up to 520fe7633692181bb6d1560d655fbdfbb7c05a=
aa:
> > >=20
> > >   usb: dwc3: ep0: fix for dead code (2014-11-10 14:39:44 -0600)
> > >=20
> > > ----------------------------------------------------------------
> > > usb: fixes for v3.18-rc5
> > >=20
> > > Just one fix here on dwc3 which fixes a minor
> > > bug caused by a fix that went in this v3.18-rc
> > > cycle.
> > >=20
> > > The corner case is minimal as it can only be
> > > reproduced with back-to-back Setup transfers
> > > (without starting data or status phase) by
> > > means of a LeCroy USB Trainer, where we can
> > > generate USB packets any way we like.
> > >=20
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > >=20
> > > ----------------------------------------------------------------
> > > Felipe Balbi (1):
> > >       usb: dwc3: ep0: fix for dead code
> > >=20
> > >  drivers/usb/dwc3/ep0.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> >=20
> > Gentle reminder on this pull request.
>=20
> I just got back from Korea, sorry for the delay, will get to this
> today...

no problem, let me add your G+ to my 'following' circle :-p

--=20
balbi

--IuhbYIxU28t+Kd57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZQLoAAoJEIaOsuA1yqREazoP/iVjLuLE1aKpjCXzQr9B/JQY
/oaFfArq8Okn4PD14pcPUUPsClJBpw4kGt4ssHk70izIYY5xOPSe8U7lcHP8/dVi
QRh166me1RstrNFYwNuog0Elbb8iqXAvLbpGPIJbhB5tLZhEYO7fSXREr5GTeX+F
tQz0QFVXEJa7EGw6SAeNPxWzrn18HDsAlzgnGZ0KgY32gdt7+QglULtfOP01zWPW
QA04hu0OzintwM49xzBPxS755jzGPTUZeQ+ddUZZpjF04ggIsCUcYkERJ6jJxWvl
mILa70KpQ01ApnHSpdpFkoMuFiAiCaLXIOarfSSDhxemizuKajcaAJnAupUoHr0P
tHGUmFCsPvTZIQ6bTfLJgQxvXp0TSwpcjr7mfJ6HlTC9n1oWcG9EJF7oYahqVuFn
c6IfL52lcQmnne1cTAgcxS4rZj1UciSCTRFKgRd9nQulLtHrgZLZGGpy6KqnAoYs
laHZrs4Rnh/gxouo9jQInQMTKaNeYmhYW7ls+wc656UzejT5NQnoYzsSWh+Er0lh
9r8IgAjQPTogBXHfZsf/NfusvlDqiMNEAfr7MJ1UkD3rW4yZmYRcijKaGFjYm/8R
7YEy3k/rX/z6oZpYxHG3+rtTrkCMurfsWTztkI97kytLOYGdunEjtQT9A2HBfMYB
DGuuYLG56EqaZIhbCW3K
=y+/8
-----END PGP SIGNATURE-----

--IuhbYIxU28t+Kd57--
