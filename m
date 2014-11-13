Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbaKMSEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:04:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53756 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbaKMSEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:04:53 -0500
Date: Thu, 13 Nov 2014 12:05:17 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.18-rc5
Message-ID: <20141113180517.GC12546@saruman>
Reply-To: <balbi@ti.com>
References: <1415652779-31904-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <1415652779-31904-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 10, 2014 at 02:52:59PM -0600, Felipe Balbi wrote:
> Hi Greg,
>=20
> Here's another minor for v3.18-rc5. Please consider
> merging to your usb-linus branch.
>=20
> Tested with AM437x SK and testusb.
>=20
> cheers
>=20
> The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb061=
08:
>=20
>   Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-=
for-v3.18-rc5
>=20
> for you to fetch changes up to 520fe7633692181bb6d1560d655fbdfbb7c05aaa:
>=20
>   usb: dwc3: ep0: fix for dead code (2014-11-10 14:39:44 -0600)
>=20
> ----------------------------------------------------------------
> usb: fixes for v3.18-rc5
>=20
> Just one fix here on dwc3 which fixes a minor
> bug caused by a fix that went in this v3.18-rc
> cycle.
>=20
> The corner case is minimal as it can only be
> reproduced with back-to-back Setup transfers
> (without starting data or status phase) by
> means of a LeCroy USB Trainer, where we can
> generate USB packets any way we like.
>=20
> Signed-off-by: Felipe Balbi <balbi@ti.com>
>=20
> ----------------------------------------------------------------
> Felipe Balbi (1):
>       usb: dwc3: ep0: fix for dead code
>=20
>  drivers/usb/dwc3/ep0.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Gentle reminder on this pull request.

cheers

--=20
balbi

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZPLdAAoJEIaOsuA1yqREVlcP/2KwGt1JjMAkgo4IBD3TWMUP
14H3hESqLDadLMMteHiO3HLgN5uvA8pOrq2ilYISUpMfy+f7QCxHo7K5lTBkAGzy
HQ5qKfCP0VR4l11Mm12f7J3PWxytrZl1oG0RAKhgyE8NqRR/FRopUA7am7i4wThH
sGkxKjNd17cGHQESTIsNsn1u5cNZj8pyj1+1ZNoQcLi3ZzgoGxg8WjupDT03+IND
oBcqufS+V7o9hMx89r5pjcgkyfVsKDepou17LwCn8Hg3uOp410TOw6jyUdRmIUWc
3S+uWWHWRAmriYFFlPea7xUpKHh/WujebqCRjI0uxobmv/wFtyqMZ9uyz/HD4whO
qMB8JcOlB2GKabtPe0zESm/27BupdOowZAK0nZ44wSMcbK9H3Dra1Brk9edEwli4
0qhe1tk6mqqxtIlb3ycATxFFyRBrBIKnoK8BpuR391rE53o68ykCPLfUUK46uABe
EaZ52kGCY3LpV25EM/YDVHmdMDSYgRUrdBsAZNkzCJPBvyRRYM4boZ/iSyHb5SyZ
z7Wuebrm6iawhu9gGDWeOtmpY2V+fxrk+Vkf7OSDYt85nhYQ5eGsJnQ+cgOp7Qjk
wTfcJ+Ymz581Xh0WYvr4UyvsYN2NGizsKW8jwCb31dICI7jir5cPFZ6lboviBEnH
MzqH3x7oO6hJ88jea2Xf
=zaSs
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
