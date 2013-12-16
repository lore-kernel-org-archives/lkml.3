Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3LPBqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 20:46:06 -0500
Received: from ozlabs.org ([203.10.76.45]:60773 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab3LPBqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 20:46:04 -0500
Date: Mon, 16 Dec 2013 12:45:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Zanoni <paulo.r.zanoni@intel.com>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-Id: <20131216124559.28f80d315d7b2846159e4031@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Dec_2013_12_45_59_+1100_0lPVKYT5Tq9HfdqU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Dec_2013_12_45_59_+1100_0lPVKYT5Tq9HfdqU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_pm.c between commit be3d26b0588c ("drm/i915:
get a PC8 reference when enabling the power well") from the
drm-intel-fixes tree and commit c1ca727f8945 ("drm/i915: support for
multiple power wells") from the drm-intel tree.

I fixed it up (the drm-intel-fixes tree patch also appears in the
drm-intel so I just use the drm-intel tree version of this file) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Dec_2013_12_45_59_+1100_0lPVKYT5Tq9HfdqU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSrltbAAoJEMDTa8Ir7ZwVf3QP/2sTvolr2SLMuqDeBfS9DuW7
yPReZp9ABtqZTkQKDobSJjw9aoJFW7WYCknKzBqmX6yXAwfyuZ5IxSWkXKJItTF8
s3y+rX4BUyi97gg3i1tKoLfkAOULriCehyZpz1SZF4fjkHnrNLfY1xVOpvQGFn1a
1dFYXvT9MUbCbAK+j4FN8HvoXG3T/sOhCMeoLO8QebO3PrSUwKOyGJegNZOo7s4Y
E3zkIuVfTcaZ1cIHU+zsO5Id0Ek9wgQVvW5HgcRQ++JDWpghoIxtWMIUlvVKEL9S
UA1l41pYW1k16ayGtO1GbLNGPjOkzmgu4SLhtaCALxfYd7lIkXL5jXaGdHv9nlOP
sPJYiyzmL/h+TOu4etuIoslsWU8E4g5Hyfipn/XNwJwZ+K8NzZaJmbNMaNFwvvzh
TB0d5AmbeWJ6VOi6lwz6mmCAtGWSAmUskNvHDafumrcMwhdkTj+G6p8/MBwRpBZ/
apxomj8l8hT4deet/DOwG+qq/9Xp3Fb+lxbEE/8O8GZ8aho1SIxFek3EgZvkd+fx
ooIGmeMCO9FPLrvR5e9q66TAs22dB1kijGb1hAZ2woYo6ezLgAxlObIF3m6sr3Rw
stBVKXjAwy13+lb8/pGdQl3YLi/kScZpM5FSaWzWUd9zi4em6zmxWR8nsaCa5dDz
q7UcEU36QKhp/KIp6ZZc
=xyCq
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Dec_2013_12_45_59_+1100_0lPVKYT5Tq9HfdqU--
