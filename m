Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaFEEMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:12:36 -0400
Received: from ozlabs.org ([103.22.144.67]:35253 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaFEEMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:12:35 -0400
Date: Thu, 5 Jun 2014 14:12:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: build failure after merge of the drm tree
Message-ID: <20140605141227.7449bb38@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/OPW+P51QxJBdWP_AoTzaiwe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/OPW+P51QxJBdWP_AoTzaiwe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpu/drm/i915/intel_fbdev.c: In function 'intel_fb_initial_config':
drivers/gpu/drm/i915/intel_fbdev.c:392:4: error: implicit declaration of fu=
nction 'drm_get_connector_name' [-Werror=3Dimplicit-function-declaration]
    DRM_DEBUG_KMS("using first mode listed on connector %s\n",
    ^

Caused by commits c0c97622c1bd ("drm/i915: Use the connector name in
fbdev debug messages") and c23cc4178dd1 ("drm/i915: replace
drm_get_connector_name() with direct name field use").

I have used the drm tree from next-20140604 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/OPW+P51QxJBdWP_AoTzaiwe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTj+4xAAoJEMDTa8Ir7ZwVUUsQAIMw0BeoY5LTowxSOUdOm2eC
/zT1kdTuhuSSJHYRd5/uo2uCOmZcdjFXBid9JJ6LLKXn/fY+JI36U0Ye56VNVaVO
Vn4tml8zu4UDWRUkX7U7DDVfqjeG7ZD5ci833cyIhiB7gUbSg/Bm4rjvqaQk3+Ex
sGpa88IZBAw3eAcxWRuIOwYmVL9fcdILYGw4H+V5zcSd/RwdHQbAQhBoAJ6Rmmrk
gz6b774vln7VX9c6RpKXzs76IoUp9S0YZbZzfJefIymr/taKlT6YZZCHf7g+1QvR
aEm5/TlivkE6+JkQFzF4nJceKJnw48pTO7eIS1HE72NwOs4+2cQ4SBnkxf9XsaYm
/KNOsHNv6uaSOieSIEWJ4DQ7ftcHGlv6Xhg8XhZ/AP759SN7nTcqeWedTkjbboBX
gAeFrW0oxeDy5dnMNYzeDT6p6A0R5Q7WUPkMTTJQx5KZNdznDsj+m/X8lYhgoKId
J3cBzUWaaYxTuUR+49FCqzTpfy5EcWzICP/84v724AGb+yR78iK+fbdDpfE3MKDx
xPN2ZUyxtIrTjhMeAeLyKDZPPZcGU3L0DmxHsn2R7nVDhBwbdVXNRiqdntxwiO8k
R4z9MIrAuSz+Vjeyb6ShhK4DBF/Ayud+FuOUDvPcn3ZQS9LfupLvQ6G8Ih51RfgI
4c2sQWavQeaJzdWB76Iz
=02d+
-----END PGP SIGNATURE-----

--Sig_/OPW+P51QxJBdWP_AoTzaiwe--
