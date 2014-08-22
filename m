Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbaHVP6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:58:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39745 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249AbaHVP6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:58:18 -0400
Date: Fri, 22 Aug 2014 10:58:09 -0500
From: Felipe Balbi <balbi@ti.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers: usb: gadget: fusb300_udc.h: Fix typo in
 include guard
Message-ID: <20140822155809.GA27616@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140822140656.GB22707@saruman.home>
 <1408718673-2003-1-git-send-email-linux@rasmusvillemoes.dk>
 <20140822144848.GF22707@saruman.home>
 <87a96wsg7r.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <87a96wsg7r.fsf@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 22, 2014 at 05:21:12PM +0200, Rasmus Villemoes wrote:
> Felipe Balbi <balbi@ti.com> writes:
>=20
> > On Fri, Aug 22, 2014 at 04:44:33PM +0200, Rasmus Villemoes wrote:
> >> Clearly this was meant to be an include guard, but a trailing
> >> underscore was missing. It has been this way since the file was
> >> introduced in 0fe6f1d1 ("usb: udc: add Faraday fusb300 driver").
> >>=20
> >
> > right here you need to have:
> >
> > Fixes: 0fe6f1d1 ("usb: udc: add Faraday fusb300 driver")
> > Cc: <stable@vger.kernel.org>
>=20
> Really? I can't see that it satisfies the
> Documentation/stable_kernel_rules.txt. There's no chance of build error, =
since the
> file is only included directly from a single .c file. As you can see on
> LKML I've sent a few handfuls of similar patches all over the tree; IMHO
> none of them qualify for stable.
>=20
> If you insist, I'll add the Fixes and Cc tags.

it's a bug fix nevertheless.

--=20
balbi

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT92iRAAoJEIaOsuA1yqREZscQAKgxc2tPZIrdTN10JWhn7AXM
DggDpvQO5ySkg6wN7UifhsDiOI/eg6Hx0tOxmbbltc8OAkyIo+9iMn62AcODjHoC
01CR9pH4SWIh5+7qJer77OOIOXOyF86+BGyuCD9kLEQLMZvr3INSyprGa6mxxf+h
jLc8qA+KMjq39UJIkBWA+9Uq0KaOXU1r6LAzxJpHdd5K46I5z9rNXQL3oggdsasR
xBLMN4jRj6UPu1uMpsXnILN7EHlq8IxUF+s/Z/wUuEHozvCLAkUviiK8RNp5c61o
mjPLb5HjBpLNZ78CWd+oDvznm0VfLpuxxQqlE6WHcbNx0UsZTcHDmw7qGM+Eyd0V
BSIOYyg1uEF1Uu20SXfjNNglEnmWC0o4Wa1v73gkregyAhwffWiiLz0p04u2U5vU
jvXy9L6IlThSwRTMY+5o7n14Ft7fstGS9Qy277ehRgpT9H+xA4u/rKycP9vX+cgB
P/csJtNNez/LLJHFaHPjBmQvamiKnzjWV6+h+apT3KHIuqmkkAHLWkbzZb1lAJWH
gVrWmZoTMvA3SC7FEBS4A4SNR81WTnAM2zCx7tNuhJBgxQGtl1aSMfVmNCCraLOk
1Xqxw/khEwa+UDgwPqLdyLOCVev/83ipt6CSSI1Pjyl1IPKQ7irSKBvcNIxFNGtw
WLHC1vnCp9t2llIMk6dy
=Ldb5
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
