Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3HVAFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:05:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42423 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3HVAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:05:50 -0400
Date: Thu, 22 Aug 2013 10:05:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-Id: <20130822100542.c483601b8a90e87b120416e5@canb.auug.org.au>
In-Reply-To: <CA+55aFxMkQoJAJd2=XyJu0NX2dG3mX=obx=YL6YXatLg4S=-Vw@mail.gmail.com>
References: <20130820224032.GA20491@kroah.com>
	<521504D7.7090204@wwwdotorg.org>
	<CA+55aFxMkQoJAJd2=XyJu0NX2dG3mX=obx=YL6YXatLg4S=-Vw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Aug_2013_10_05_42_+1000_f=oypeQp3fCXe5+F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Aug_2013_10_05_42_+1000_f=oypeQp3fCXe5+F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Aug 2013 11:36:05 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Wed, Aug 21, 2013 at 11:20 AM, Stephen Warren <swarren@wwwdotorg.org> =
wrote:
> > On 08/20/2013 04:40 PM, Greg KH wrote:
> >
> > Presumably the idea is that much useful testing only happens on -rc
> > kernels rather than linux-next or arbitrary points in Linus' tree.
>=20
> Linux-next gets little to no testing outside of compiles.

Besides which, regression fixes often get no exposure in linux-next anyway.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__22_Aug_2013_10_05_42_+1000_f=oypeQp3fCXe5+F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFVXWAAoJEECxmPOUX5FEmYUP/ivqNzLgHR8isggE7m6xZnZt
yieZVwtFezv3Uc8v11eBxwg4uP1bekFKTSn2W94+CdmVPhKycuDE/HZ4j1XkqsnI
D6ahl2TOL9ZcoydLp0bnKc1Mp7FNzzxMEMrfr1Qb58eu3Tytz3nEr1NkZLUNqCWA
34VX2Pw281/me/YzgCgREanDZ5xxDvRhcZvyjsoJ/jFf3Tgb6D5X0UxAvdYlWQKm
SQdcLodiVl9Csz8ck/s6PcA7eQzbRB4fjvnpepRIuafhrpS4YtXT/7kTM8tIO3k7
6U/zBEt8u9qyzHBkf3EnUu0GkY1A3OvLGnODnmy/xeHLi4pLPdU4NGFyBGz7DtbQ
1fU1+CZD/eHXElITd0BIKNbJYDCxFwcfeaYYG8hG2uTe+bjWXVB3V2hwmKZTskco
+/MR8cnYsRjCd98WRGXIVhR4lYy4WUzQw0sSKd8G69l0v6pB2T9xtEGdlTMhNUIj
ZR98q8l6qGd04XnosZOQYd4Y/1DSIGYW/z1MJtmVkcYTBL+4lTFyDynOflLNVVqO
+ZPVUfdj+E0SGTgyj7SE6eGOdI2zDHzAM+dZ/S8gA2DfwCW9d1te/NEu+Cp7TnoM
f23rmIQg1vgrxkCsZJ1VqKNsNWAbo/AaIzkTmwWJ54hXrZFqSz1o92zGZahK8v1I
186CyTFtGAhMzPOwhDFd
=wnr/
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Aug_2013_10_05_42_+1000_f=oypeQp3fCXe5+F--
