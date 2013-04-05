Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162376Ab3DERzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:55:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162270Ab3DERy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:54:58 -0400
Subject: Re: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Teigland <teigland@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cluster-devel@redhat.com
In-Reply-To: <CA+55aFzPK1Sz_JO4iDvKSnPXdin8CBET7eisYFkMV8DctLfTZg@mail.gmail.com>
References: <1365158085.2735.25.camel@menhir>
	 <20130405162746.GD20835@redhat.com>
	 <CA+55aFzPK1Sz_JO4iDvKSnPXdin8CBET7eisYFkMV8DctLfTZg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TC7LCp1hi214VO6eyvxw"
Organization: Red Hat UK Ltd
Date: Fri, 05 Apr 2013 18:52:44 +0100
Message-ID: <1365184364.2735.33.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TC7LCp1hi214VO6eyvxw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I've dropped out the patch which shouldn't have made it into the previous
pull request, so this set should be ok now. Apologies for not spotting
that issue sooner,

Steve.

-------------------------------------------------------------------------
There are two patches which fix up a couple of minor issues in the DLM
interface code, a missing error path in gfs2_rs_alloc(), one patch
which fixes a problem during "withdraw" and a fix for discards/FITRIM when
using 4k sector sized devices.

-------------------------------------------------------------------------

The following changes since commit 66ade474237745a57b7e87da9a93c7ec69fd52bb=
:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2013-0=
4-03 16:15:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ma=
ster

Akinobu Mita (1):
      GFS2: use memchr_inv

Bob Peterson (1):
      GFS2: Issue discards in 512b sectors

David Teigland (1):
      GFS2: use kmalloc for lvb bitmap

Steven Whitehouse (1):
      GFS2: Fix unlock of fcntl locks during withdrawn state

Wei Yongjun (1):
      GFS2: return error if malloc failed in gfs2_rs_alloc()

 fs/gfs2/file.c     |    5 ++++-
 fs/gfs2/incore.h   |    1 +
 fs/gfs2/lock_dlm.c |   39 ++++++++++++++++++++-------------------
 fs/gfs2/rgrp.c     |   32 ++++++++++++++------------------
 4 files changed, 39 insertions(+), 38 deletions(-)


--=-TC7LCp1hi214VO6eyvxw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRXw9oAAoJEMrg3m4a/8jSva8P/j/i0/2zHHJBtET8hF6IkEZy
dYEPmkFDqkBexp3ANBh4+0MVgQe0EVT7me+pP3oVgmim5WEMyP1IgIWJGywcsZOj
fsL+3I0ou26Lg2g/juGuzJ+DTy9SRi1CXurIlEkrGNFsdqzWXWBV6oOMifb+LIHm
8jt4g+UNdIeHQdFQYLk1lZ8Px1NqavKVKZwmhKCg4TZkZGm3q9bgRfHf4CpSQivl
C/mXGu2hnF4nFyac7AVkpTF9XXHlrv2RjUckvVhXuw21WR7mXwzsi31Rax6uVQFk
AGZodBylbF+P7BGmKW4SBvZsOj/YK/PoXQ0zTTOJg6uNp/6Tg2+kzSUnVWTMiZx/
uo8PUWJqPgZuRqT+Mie3YEmIscFsYkXV5Prm8sdx0X2rWvg2YszTpgF+jXcPEhLu
zHXJ3Y/flHFJXMLcUYaGvVm8kcXCnUssEXGsN8GdW3WSJg/MAnpMnPNJeamq6gZh
W2vX+Nnuhjo1LTfbw/HPmoqMHatcQJS0/u4+WFHHWTWJP+8+cRzVuWSiTajI1g/T
U882Nk2iIlu/SD3hOOpzfHTSgpySFCSgpaRYrjA9Y4bhYnageYSFX93jLr5Srw1Y
eG0cEpVRIHhUHB127pD565Q8Si/uwqobMGK3dQ4hixixNEAgMqLOa7+/8b5LL0NW
tQUcEdhhollYnNhHjn3z
=s1WM
-----END PGP SIGNATURE-----

--=-TC7LCp1hi214VO6eyvxw--

