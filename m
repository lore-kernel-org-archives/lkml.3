Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935714AbaBDWPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:15:36 -0500
Received: from ozlabs.org ([203.10.76.45]:56035 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933993AbaBDWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:15:28 -0500
Date: Wed, 5 Feb 2014 09:15:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [PATCH] MAINTAINERS: Update drm/i915 git repo
Message-Id: <20140205091521.8fc819ff64a46e0a122f16a6@canb.auug.org.au>
In-Reply-To: <CAKMK7uE99=xfj0gDSv5gdqFALQ6yWWEzmeD1sCnW9KkqMBFZ8Q@mail.gmail.com>
References: <1391540451-24169-1-git-send-email-daniel.vetter@ffwll.ch>
	<CAKMK7uE99=xfj0gDSv5gdqFALQ6yWWEzmeD1sCnW9KkqMBFZ8Q@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Feb_2014_09_15_21_+1100_69YNvLR6WdQww0oN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Feb_2014_09_15_21_+1100_69YNvLR6WdQww0oN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Tue, 4 Feb 2014 20:15:03 +0100 Daniel Vetter <daniel.vetter@ffwll.ch> wr=
ote:
>
> On Tue, Feb 4, 2014 at 8:00 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wr=
ote:
> > Moved to a common location so that Jani also can push to it, to avoid
> > moving it every time I go on vacation. Please update autobuilders and
> > everything else pointing at the drm-intel.git repo, the old one won't
> > be updated any more.
> >
> > Cc: Dave Airlie <airlied@gmail.com>
> > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>=20
> Oops, forgotten to cc our linux-next maintainer about this. Branch
> names are  still the same and I've checked that my scripts recreated
> them all properly. So this should be good to go for the next -next.

Thanks for letting me know - all updated now.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__5_Feb_2014_09_15_21_+1100_69YNvLR6WdQww0oN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS8WZ+AAoJEMDTa8Ir7ZwVXdUP/3j/ktm9Vm19jLGmlnmXJIkq
R+qQDaIrHs42hmluF2PiML1IE57UqNfJs/6bMb2ecXabDckqlGEnK/3wD/udaFxm
iyYZduX4GySdzQdNHkyXkq8hTtngDAeqhFGJbOmfivaY1FojHoSRXpVSAuR0u0jI
qk5r5qdN/4NngYWQkXw3GNocCH7Z9qZNWRIDB6cJbc42uf1LHwpWUCKHrwrCLlwT
JSA3GWdL2VA1YcCAbzu8K/JhjFbW/8IbcV/wMM2d2Ww2NLpz8KFr9+WsNikA2LiZ
qh97MpK4yIh0XzrZtH+j4trKnc5qHg0yef4jlIzkG2YVhuJWpHpfaE4lC6ijMfsk
kROss9zoOdk8F8WbcCO8uLFsnpPN5pdKeUKTRZkKm0nt9J6kLc5ZjiExNW3on/2b
qA0kkQeq2mgGYlapPVM++cCFbziJzcwwNYzaR6u8EFaNZsnU9E2+9RQx8RUIrzA8
kKMxW0ZNlB8ORn81oR50LkVCQTJ3eDhVjEspQYrr7hlFXO58XqvO0AROYIXapqF/
fel+CYb7bL9rbeE0tgSkYjbZe+RDlGCzJE0XbsvspK63zZfcOeTHJPPzsSmYKCwA
Q8IJOkhszkCPIXVwsRXmQXdXglU9H8KdSkJhehDMO57N37OmugWPbbwoPzvPjTzF
Up5iCCHHmilUkygzppJR
=yWr8
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Feb_2014_09_15_21_+1100_69YNvLR6WdQww0oN--
