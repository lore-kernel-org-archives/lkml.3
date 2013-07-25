Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3GYBkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:40:24 -0400
Received: from home.keithp.com ([63.227.221.253]:53018 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab3GYBkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:40:22 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/5] drm/i915: Add async page flip support for IVB
In-Reply-To: <20130724212308.GZ5939@phenom.ffwll.local>
References: <1374544202-15496-1-git-send-email-keithp@keithp.com> <1374544202-15496-5-git-send-email-keithp@keithp.com> <20130723052856.GD5939@phenom.ffwll.local> <86li4v3ds7.fsf@miki.keithp.com> <20130724212308.GZ5939@phenom.ffwll.local>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i486-pc-linux-gnu)
Date: Wed, 24 Jul 2013 18:40:16 -0700
Message-ID: <86siz3v2m7.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Daniel Vetter <daniel@ffwll.ch> writes:

> We could just unconditionally increase the alignement in
> intel_pin_and_fence_fb_obj - we already have more strict requirements due
> to a bunch of w/a in other places. So shouldn't hurt at all really.

That seems like a fine plan; 32kB isn't that onerous. Do you want the
trivial patch to do this from me then?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUfCCATYtFsjWk68qAQhbkRAAv6LzL2aas2HMmgnUowzk2HHjq+NEqt8X
CBuJavJSOMqmIGK0TXt+ekL8ZOMMiAkMXc06d7A2xrtaxfuxtXaeElnudBoz8dnm
J+z0Gs9v0sJerNWh82zctxP8pmZFIwMuaaKNZho/Sq93BsDZ66EPcSBPOdqkrWS0
13r6Q4W9+sPdTapBq3amJYTvw0fkt7dREQiFtme56z4mCFa7F91iMMSzJMjBT3bo
1haUstQ7qFAcL95NUtxVQpxqgkfq41jxL3O2ZbBIM9t4TL/M8by6jA5DZq09eAuu
8YxVCS1wgWE3rLnkplEpEs83f5G13cVu0iJ9CquH+HnBNfudg0oK6o00eNWOIaza
xUWeXvfoNACPk1HLiCQryWk0yoouFaDwZBDcFI3hgAhkx5B3w+sE9Xb3v8I7Fqes
rFF/hT7Sjo6+FCxUO8xrTTwJ/wB8cubbvrT+93QMKUqmqnPSCUJh2MBN4jWXp+fU
7h5OMBeMrLR+URNTgVRIMxJs41qi0mbXU0tV91Wx+VIPRxAkYG7g9EXA2VawuHr7
SZYO4Ubv6H5g8sH6WK7psmeyIx4gdsAFpec/21zS1ZdEs6vmhZ2zHbVku6xKpV+o
w9ZHy66iB4jNqtkPDXNoFSpiFVeyG3LN+HIOd/h8Mu1nBKIE643YPr9jl6M/CsBV
J+7qNY8mUyQ=
=ZItx
-----END PGP SIGNATURE-----
--=-=-=--
