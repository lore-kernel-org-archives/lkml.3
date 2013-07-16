Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3GPQ7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:59:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33902 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab3GPQ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:59:41 -0400
Date: Tue, 16 Jul 2013 17:59:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, Willy Tarreau <w@1wt.eu>
Message-ID: <20130716165933.GU22506@sirena.org.uk>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130712005023.GB31005@thunk.org>
 <20130712051451.GC25815@1wt.eu>
 <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
 <s5hwqoqv4oo.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lIC76ItX9S6XOZ/S"
Content-Disposition: inline
In-Reply-To: <s5hwqoqv4oo.wl%tiwai@suse.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lIC76ItX9S6XOZ/S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2013 at 06:40:39PM +0200, Takashi Iwai wrote:

> Maybe some QA period before the release might help, but who would
> care?  (Especially under the situation where everybody has own x.y
> stable tree?)

Hopefully people tracking the upstream stable trees would be throwing
any pre-release stuff into their QA processes before it was officially
released upstream, though I'd not count on it.

--lIC76ItX9S6XOZ/S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5XvyAAoJELSic+t+oim9ndgP/R9lUPFXx+GHuslDf+WUueJM
US6ugC33Faei91F2Dx8On4bRGCYUeLPHptut1IgHh6ytbhYWNeOs0rR/oj+3sH+I
icmm+loBTUL8S7h9Rofaq3JExAha0OQCpNUuVU1SI9SLWmM+APast4JArTZ5eqhV
SGiyil3/qxe42QLgS2DqRFH+eBj4CmiteRgjirCedtq4KRDSzDzyaK2YL9dcd7bW
1tvmMSx1tPl+Kq1nq33EwjF/pzg5zU+p46G9psWDQOSybmhlBG77elhD63rH6HYh
tUaTBOMHu2sE2ybaDoDKbL7ipVdSQpi+ZuK9W8qeFHrG3Zxp9ug/svn7bK7XkgXe
1/pvyN5ozfmzO3iXrubNuu6FxJxoxzVcXCEt8n/THaTW+PyQJWPei1cwyO5uc9Xg
W1gLoeIu5TA7sA8llug/wB2nusoB/rabr+qwPlR4c6WrStgXPzKEG6ftK3WkU4eV
HUQlXVuRRgESG2+Ue+VmLmGIOMok51A1+fqnjCTF/AvxMpdaSug3HHXNAC4067th
XgABxUyT9TCeK/eIZpkFF0JGA5+BJYkijeFn2xOXEYQ4BrIQLMbJHQM6rrFkZbL9
1pRnMgiySxA0qCS+fmTBUw78PBJphQH3W4qR7l0v1ZCB9C6TUxW/0MMwnj1J4N4O
ffm/UqefpPaoGM08AHNI
=8KwX
-----END PGP SIGNATURE-----

--lIC76ItX9S6XOZ/S--
