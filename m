Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab3C0P2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:28:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47351 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab3C0P2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:28:15 -0400
Date: Wed, 27 Mar 2013 17:24:23 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
CC: <joe@perches.com>, <apw@canonical.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] checkpatch: adding Suggested-by as standard signature
Message-ID: <20130327152423.GC11558@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364396902-16749-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+xNpyl7Qekk2NvDX"
Content-Disposition: inline
In-Reply-To: <1364396902-16749-1-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+xNpyl7Qekk2NvDX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 27, 2013 at 08:38:22PM +0530, Mugunthan V N wrote:
> As people started using Suggested-by as standard signature, adding
> "Suggested-by" to the standard signature so that checkpatch won't
> generate warning when Suggested-by is used in patch signature

if that's the case, then I guess you need to update
Documentation/SubmittingPatches explaining when to use Suggested-by tag.

--=20
balbi

--+xNpyl7Qekk2NvDX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUw8nAAoJEIaOsuA1yqREVb4QALMGdgFAtQkzRtmd7pfcj1zg
jGcMOKI1I4RvoC582gL0esp0wVhIt95jnkyG96T6CVylVWLUz04eyHlyBqG3Ro7a
fzxcdeCaxOoHrnAUbS6v+degfSGqb+4mIjYOnVGGU/0PtMmMedKOHxofERCz2v9G
SqTVSFxnNTopBAsAVH8pFBbWYYGafnAzEUD5xNQ84mftup+KX8kyXs6Ak5XuaZPi
elXDMxkH9SDb581006W5qka40Ch+H10UiJETX2TeMm/4mI+OwJk9WTRchx1UPbk/
nw03+dNTwaOBjkpGnArNCCqLTanImHJ3JH+xnIDGKK3iNpub/0blkihHeSTGazOo
WWCldmhPme+FOLAwBDAhNhi0BryRwNMyPovePu+mAYFNNFB4a1Z0nMRE8C6Q8ecu
GEX4z32DzUVBjtkHzS69qkuvp/B1sp6lxogZnBj3ZJ319UBxmobLCGClbXtBsBW1
I6u1zsjsXBq4dE8VTJ+sHddcP5HzzyjHt76gsYTfa6BC4Z/bZdS/w2LqmGlCYvyh
M5JftDACKSd7xPK0X0D686TphntXz4jcbU5IuNoujaTSfJeP8+MEGUnSsPCJ7NlY
Gb96IGfQy9/0/nJEkkqcPH8/gY9szaueLuANy8cdh9lRCP7eZmFcYM5rmakAZyYB
W8Jg5tvF/I4UbkSID/y7
=gyFT
-----END PGP SIGNATURE-----

--+xNpyl7Qekk2NvDX--
