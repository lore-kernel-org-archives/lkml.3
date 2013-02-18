Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab3BRTU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:20:26 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46582 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755Ab3BRTUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:20:25 -0500
Date: Mon, 18 Feb 2013 21:20:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BONUS PATCH 2/2] base: core: WARN() about bogus permissions on
 device attributes
Message-ID: <20130218192010.GE10755@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1361214544-14403-1-git-send-email-balbi@ti.com>
 <1361214544-14403-2-git-send-email-balbi@ti.com>
 <20130218191719.GB19724@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mrJd9p1Ce66CJMxE"
Content-Disposition: inline
In-Reply-To: <20130218191719.GB19724@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mrJd9p1Ce66CJMxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 11:17:19AM -0800, Greg KH wrote:
> On Mon, Feb 18, 2013 at 09:09:04PM +0200, Felipe Balbi wrote:
> > Whenever a struct device_attribute is registered
> > with mismatched permissions - read permission without
> > a show routine or write permission without store
> > routine - we will issue a big warning so we catch
> > those early enough.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >=20
> > This is completely untested. I have only compile tested
> > to make sure I'm not breaking anything.
> >=20
> > Greg, do you think this would be nice to have ? I could
> > fire up kvm tomorrow and run on a few of my OMAP-based
> > boards to make sure it works as expected.
>=20
> Looks good, but you better fix up all of the big offenders that this
> points out, before I apply it, otherwise we will get a ton of bug
> reports :)

sure, will do that tomorrow though ;-)

--=20
balbi

--mrJd9p1Ce66CJMxE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIn7qAAoJEIaOsuA1yqREUkoQAIR9LRkHNJgWUJV7MRso+LFO
J6UXDGZEaJbN+fIj1rclaV06sLASvLwkpKi0n/9iLGXF2bfnpQwhK/RuwqVs49ng
cc6ofGlg+xImiuoaFq5DtzYTmAi2ociFra1dXS29/lSWrAQikfXkkegfRQSEtVs+
Wi5S25ZZKqCVpH+aaErLyQmdQuL56YmZ7JPeDplbMwlJfPnit8F4wwCUDhpPisjm
pBsJoAwelSvGWtkh6lK8vRnj5elunpxj65U8YWeFsiBJW8yMrBpHX3/djD+eSDMJ
KtqUgLMKejBLOibraA+o8Fr0aXHgtojNLTRgJZ1JnvNgN2eLs/8kPSt/5Yh08hhh
D257pAWeI7ZupUn7GArjvq1mvHz8BfnsHs6nVuHvCeWavb7cQQ+hQRtEutmYX01D
4mnFT3m2vn+nmJ6A8laX8uzN5zcLUtmgdqnsZ53a5xiAILK8IHF8L81C9lvZLFNl
xLrJupNstiOTtSbkYb484mtiLQYwRXSBZXbF1iggrRnvKyo/U3GR9VPAsxgsBHAj
rfBlYYv2BuN/XkxA59Qjr4kj8SbonRtSlEzCB3vfRVjS/7Py8okyRQOEp+pubB3W
8bUqkdwmuLf+w11qh61Wp3BStDb0rZFUHgOo/5y/oei6mK+CUV226xxcuRBJ5WhG
l/UYbozigYVHPYwmaUm+
=Oxg2
-----END PGP SIGNATURE-----

--mrJd9p1Ce66CJMxE--
