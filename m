Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaANPCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:02:52 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:59683 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaANPCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:02:50 -0500
Date: Tue, 14 Jan 2014 16:02:47 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] drm/panel: update EDID BLOB in panel_simple_get_modes()
Message-ID: <20140114150245.GA29766@ulmo.nvidia.com>
References: <1389292654-20491-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <1389292654-20491-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2014 at 11:37:34AM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> This stashes away the EDID data so that the sysfs per-connector file
> "edid" can display it. Without this change, the "edid" file is always
> empty.
>=20
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/gpu/drm/panel/panel-simple.c | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

Thierry

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1VGVAAoJEN0jrNd/PrOhkyoQAL31nh2Za5hZynaCyPlx+G8C
kSieEsDKgZGPPr3cQbOTLef3RAEJpIRipR88ipwQAZ8PdbHeLsKSaS3KKNg5TE9q
URaC+EYKmLx3F528w4V+Y99Mno9hqDP+e9BmOVISYIfY3b7h8zo+lX4IUcU+ZM0t
Xj9Rsrh2PgwP0dpgYUwwEL+egjXNZa6YmAZTWw/bsWkvzldFvHeNtrGP+CF6Nu9J
c2AzcdiTWEn8oapVmJOthfBsUVQV3a0BjOkmWDCJKcFqX0PvpAOA88Ur+uVI1MvB
fc1vKBRJ03UzknDvv8uVf9JR+SgixkBQvB6EOdah44ZVk8xcyN1vHQltXFvHTjUM
E1GL3uWDsXlybUZ06YoB3VSy93mobqOAh/qWdww1xqlJn05PX12mSk477vqNDJzh
YnWD/Jf8k58F2gu3i/VjnizgpmMNyd1iFRg5IF7Gl4nN8sNSPXFb8h7zS0XmpQN0
SMn8uQNnBFv0vEjsIj1R/McQsoeXMQmRTJXX04OtpruGNHip+LQ6LU17jxxb8Nf+
45KC8gYwc2MyUfZrujKn8d04Ag078UlWE4WBflrk2EDbqVcNMXRGevnpdEzY6KYv
IWDCAI8+nPQpZcOyXX1xAUg6QNDqe5B4y3w69n80SamT9aloFrqw/mXGsDD4zThT
NdUwNvmPQjJHu/4Q21V4
=QAeN
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
