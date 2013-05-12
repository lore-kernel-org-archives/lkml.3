Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3ELXnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 19:43:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54581 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3ELXnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 19:43:50 -0400
Date: Mon, 13 May 2013 09:43:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: comment on the watchdog tree
Message-Id: <20130513094339.b93a7a4ccf73ccb7fff86d03@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_May_2013_09_43_39_+1000_dq3v6teF5NKp6jZm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_May_2013_09_43_39_+1000_dq3v6teF5NKp6jZm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Since the watchdog tree now consists only of merge commits (relative to
v3.10-rc1), you might as well just reset it to v3.10-rc1 and have a nice
clean tree to start from.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__13_May_2013_09_43_39_+1000_dq3v6teF5NKp6jZm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkCkrAAoJEECxmPOUX5FELUAQAJbPHeIEEUJR/YeLO6QxE2ZA
5+eW42+/Bv9UUovda8/syxg3/iPcO9cNc5Vfjc0yFzFpVIXs4u0bjjHdpvQ11/3M
qqS28KKARSZh2VmzkuJU6E9RXvDI+GBHEDpBpMpxxGi8uJffunQB3UKIJy/YsAkV
PR9nzfejN1NhmBzkN3u5ORvh6w/VGlgiFuzocn934O+zdVN5CB5IvEB5wblUNtEx
zbNrDtfmPkNMooTaQCXkOLTFiX/4VO13V+7MMPNeAVxlvsNBDMdW0YiX51ep7L1d
IJudGD/ToKUCWp2V0RdWzkjnhrkA5rIT7P0d81nBSdZ3iz3Y4O8dglN+PsWH2l53
q0sAx0IthBBiepe4F9TywgRpbRxVaaFGhNCe5sUFpiaogX9INQqyRrXSshojd3zO
lt0oQCC1OWttlAVdIeU63djpjHHono5161ILbTNzd3+Belg0nDllJzYrsRfCe/Fn
OyEpaTlgpxIP5qId+bncicPM/S1gMR5AqpMOd8MDkHFlA6BhknvphH+KVc0jKWrj
NB4lOfYI9UNRB2W+lWgTHoyYfCovp7L+l7F2jhNMPOFVwym3pfUfYGxjIuVtQdnk
hjKJE3pKFC+rwL5ahavhTzPw6NLsjlJITIz/yrMzAAMWS4uV2QvOFacQHbysiqD6
mkJyvCQWcG2npLz7mT+j
=wrsU
-----END PGP SIGNATURE-----

--Signature=_Mon__13_May_2013_09_43_39_+1000_dq3v6teF5NKp6jZm--
