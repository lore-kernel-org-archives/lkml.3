Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaLCI2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:28:38 -0500
Received: from ozlabs.org ([103.22.144.67]:60784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaLCI2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:28:37 -0500
Date: Wed, 3 Dec 2014 19:28:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the drm tree with the
 drm-intel-fixes tree
Message-ID: <20141203192829.28bec60c@canb.auug.org.au>
In-Reply-To: <87d281nntf.fsf@intel.com>
References: <20141203132708.7423b7f8@canb.auug.org.au>
	<87d281nntf.fsf@intel.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/gmWRvhrWHhDYxacqQvFKbyZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gmWRvhrWHhDYxacqQvFKbyZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jani,

On Wed, 03 Dec 2014 10:24:12 +0200 Jani Nikula <jani.nikula@intel.com> wrot=
e:
>
> On Wed, 03 Dec 2014, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the drm tree got a conflict in
> > drivers/gpu/drm/i915/intel_display.c between commit b68362278af9
> > ("drm/i915: More cautious with pch fifo underruns") from the
> > drm-intel-fixes tree and commit a72e4c9f9a11 ("drm/i915: Use dev_priv
> > in public intel_fifo_underrun.c functions") from the drm tree.
> >
> > I fixed it up (I used the drm tree version) and can carry the fix as
> > necessary (no action is required).
>=20
> b68362278af9 removes two lines of code; these should be removed in the
> resolved version too.

Thanks for the correction.  I will do that tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/gmWRvhrWHhDYxacqQvFKbyZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUfsmxAAoJEMDTa8Ir7ZwVOfAP/Rxe8mOdvyMO31kS/YRT3yBH
VVDzYO9O4EyBIEEYe54wx8d6ouNoWGWwEbRLF/JUQnQzCbFi/EVwI9bbLsw27n5h
bE93ceQPzHGIKDv485lzJwXvsSCA+DjjVy3v6mr99iDslFJgFR1OuVY7hJuOooZ/
NH5zvGxIRf9WIiog2WR1U1mvcJhoEQGJhiCxo9/h56DkQhdrGopkXxAzjC7EhH7N
sAayarg2ctorGaMQE6f/ZAUaILnDZK7+ud6zZx5U8SL/zUi5SL3V8S5uBM+tWRxz
Vgqo9huYjyZ6yS0PSsbELOK75DhN96cRrjAadZNGbaeAXTWvziz7WUAXK8QpbDeK
ZfAUk5GVosSEayv00Jl5GOoFQD0b/HLeFeugmY7wcvpJpc+8zLsIBzH5CCuNfRCX
w5ZqSpfZMlvWelgq0dDlaVxvW0eSBH5lXywJpP1CG1Pk10t2Vq+I43uOPqioj8AY
UC9WdO1cvm7KNSCIkdn3LPLolpDx7E35NBOgmXcvyomCOpsvFVAVm9c+oVy85NKo
1ag0o+G6iJzYd8qcGbdSj8x60T3Je4UyYBQUzEgmxrVW0T7fTdHt++zMn4NBmjZm
BeZkKSx9ci6ICcF0DQINktFSGFoSF1l81ghXie94T+2DWr6q31pqAsjV4g+JNLih
JZTvNPr/jKLzjMZ4+NWA
=70i7
-----END PGP SIGNATURE-----

--Sig_/gmWRvhrWHhDYxacqQvFKbyZ--
