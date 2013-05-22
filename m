Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3EVFxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:53:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57933 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3EVFxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:53:31 -0400
Date: Wed, 22 May 2013 15:53:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: linux-next: build warning after merge of the final tree (drm-intel
 tree related)
Message-Id: <20130522155320.7ed167814699e965091ce6be@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_May_2013_15_53_20_+1000_nmursFvh10B3TQj3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_May_2013_15_53_20_+1000_nmursFvh10B3TQj3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (i386 defconfig)
produced this warning:

drivers/gpu/drm/i915/i915_gem.c:2978:3: warning: format '%ld' expects argum=
ent of type 'long int', but argument 3 has type 'size_t' [-Wformat]

Introduced by commit e4341d0356bc ("drm/i915: Be more informative when
reporting "too large for aperture" error") from the drm-intel tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_May_2013_15_53_20_+1000_nmursFvh10B3TQj3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRnF1VAAoJEECxmPOUX5FEN8wP/1fd2oZnmTEiNjTPX+yeHyaH
IlWK/vUF6Dm92hu9l6k0j5NGvGxzadpgAUP4ZwrKIn9rWvXPYfZ+vU5gwhs9l3I4
1b0SoTwWlec4NwASY0LQZweEcI95HQxGVhQmzX0o2WOJ5WfOwglJJpBWpGNxffjT
MOw2PKsGzELxqnLIQMnNf9Oo2T4ZcGeZPMAAU28WJ4z67T0Yxsi8CUt0Tnpdr4mJ
wPy/oDrhL72ZhPmtUskqlx2mg6ztI0x7YOw03YIl2z1sUHa7OAhqERAGsSZTaTTH
E3V3KSV9b4r4/UgQyyH0nQ/JwFSCcdaCfbU+6Bgdop6RxJDKm62XsCdXCDFV+nwL
AW1gOaatkcdNyiU/CrMmIIDsVc/7xfJWS1+ptvNVchA3+Fs75gnDueDuuCqM8P/f
ysHWsWMJ/bvT+vosKOGVZKauk6u5yfTbL6QYz5B7OsTzHDSj+V/5z6KmwIUvfNtr
W3vH4IgSIxmn+lEwpVnUS0KMmLo4MT0yPWzJCChn52KXkkAxE72yHanpa3vRBSVT
rPpX3/A8mYNVG2gqZYG1ZENxvfb/awNeWxkGNLJUIFgj0qLh2PgzIr+Oqdd4CUcW
ulgEJFgrVURTc1nurh9o6vjXdTxX8NSisbKKIJKOFn1PN6uLw0A8GULwYYWELHpl
PIMh2XrF2l23+MRshAai
=wjCB
-----END PGP SIGNATURE-----

--Signature=_Wed__22_May_2013_15_53_20_+1000_nmursFvh10B3TQj3--
