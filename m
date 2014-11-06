Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaKFE64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:58:56 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42330 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaKFE6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:58:52 -0500
Date: Wed, 5 Nov 2014 22:59:15 -0600
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Peter Chen <peter.chen@freescale.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the usb tree
Message-ID: <20141106045915.GC6272@saruman>
Reply-To: <balbi@ti.com>
References: <20141106145832.633bb8c2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <20141106145832.633bb8c2@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 02:58:32PM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> Today's linux-next merge of the usb-gadget tree got a conflict in
> drivers/usb/chipidea/otg_fsm.c between commit 51f1741fcc16 ("usb:
> chipidea: otg_fsm: delete unnecessary 'out of memory' messages") from
> the usb tree and commit ef44cb4226d1 ("usb: allow to supply the PHY in
> the drivers when using HCD") from the usb-gadget tree.
>=20
> I fixed it up (the latter removed the code modified by the former) and
> can carry the fix as necessary (no action is required).

Alright, thanks for fixing it up.

--=20
balbi

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWwAiAAoJEIaOsuA1yqREtrMP/1borPbLiK2+KBOP0HbSZYPq
cPiedJtrwLHx6XBjbG9VMFDe+tYOBeJm6Wbhn5eEPD+3dRIN3V5yfN3xcA/jc0BD
IOOU5lF40q/BxkXyyzFVdkYJX486oW1BPj1Rvefk44Y0IeknEE6YnuXVdIa/S3xF
xMzc5gMERvYlYaQ0kNj3qVizUs92URGEeD42iQzMyVdWx4NvqQTZ3j3PdU4Q0r15
DdNX884hmrXIyn4IRITwdot5ADVBSbfaCWe959NqVYBUK429P9yv/9qa4noxlmPQ
W5Sc7cWTDJ6aqG647Gm4vS+G7QlXp6PBKs6drC+QjlNm3GqPs5Nz1mUW0WX/DlBG
4RexAvk446d4CQXKJ08EudpsO5ev+aqGN/AoxlISTJyLIA3B7KNtjOEqNGPE85JE
S2gzMVlpw5wANIuNStuL+Yrft4lCxdfLlr2wJ/eevUPuhOPWEH/4sCZDt+vpAd1h
AoxdklPA4EpO4dmbL1Ko9+6u/5RVGk+JSeF+9nFF5D0d3DSkiAfz3OerYnc4e256
E+22uKE+1DypKBjudaXF9tZlhpVhB9xNiN0u95X+ilA0dutewcOD0l5m07D/BGni
WPL2isB+sUkCs93RFQ3tu2fxjFtGI5sdghUIAX6JlBH45VqNCczpFIdVP/wXH8oY
LxoIFSoh9pDzVKI7Xbu5
=oOCl
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
