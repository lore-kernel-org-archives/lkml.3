Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3AUFnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:43:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38023 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3AUFnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:43:47 -0500
Date: Mon, 21 Jan 2013 16:43:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@linux.ie>
Subject: linux-next: manual merge of the akpm tree with the drm tree
Message-Id: <20130121164336.9edf1179a8e5c91baea8571a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Jan_2013_16_43_36_+1100_oWq4nSPXY2LvyxSy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jan_2013_16_43_36_+1100_oWq4nSPXY2LvyxSy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/gpu/drm/drm_fb_helper.c between commit 848499032504 ("drm: add
drm_modeset_lock|unlock_all") from the drm tree and commit
"drivers/gpu/drm/drm_fb_helper.c: avoid sleeping in unblank_screen() if
oops in progress" from the akpm tree.

I can't see an easy way to resolve these, so I just dropped the akpm tree
patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_Jan_2013_16_43_36_+1100_oWq4nSPXY2LvyxSy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/NWIAAoJEECxmPOUX5FESO4P/jOWQW1Rfm4vDN9GH9gGfy4p
wLXyC+WPMbVLHIdb581Vg5fJA8h3pxukaUahWlCVcW1zh8RsW8DPYpH6LAUF/q9d
7PRT3uXN+SbQcgfmU6cpi5IOv2/li3abV7fQ0d4L0+aYgv0oidutlY/qut8KQQtI
inKDhV+jTP9zPNEAhKTEDq03cEIbcHRDwSeu6Che7SFjzWpaNsx8Wi1qnKvxVZl9
+RFih44eTQ3+WdVnjd5RHIVIYaQr57hocFVPiUHlbZA3FcEckRBk/zb1qK2JEhuG
h3rdv98cYlkmjxZ9gW/70tGsmqlqhYw2SoP9BeYROVMFqqMFrK2CsL6r17wTKqxG
WvOaUivx+e/5NQdQwbAt5GPwIEqbcTXd3wEG2BAXkXKHbBy31mCvaLCUUqvbMX1N
TW4lMMvjK+KWuR16yapFA6+3KxU8WTBi+RYkx8SSc2poG1Q7WBFxGQgnPdqLqAfy
DAAD/AmEfE0YwlR6Qq5t820OKhNlbbX0G7TyB8doflrW+SIXF0QkS0mqF2IGD03U
VkLZBBXLkYJmpPyYfqKugvTyVLhm4/XF4VPwBo3q+2X0Ge1ae1Q4JlCk5xAqvlsS
Mdc4Cs2ttFbWoqNh6hmYEbWHFZ+kpQ6orQ4gRsck7Wg6D1mHTYryT2bhF/Sws2xC
VCslGmvZLr2fS0Mf0jYv
=YtPi
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jan_2013_16_43_36_+1100_oWq4nSPXY2LvyxSy--
