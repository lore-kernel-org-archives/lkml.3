Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3J1F2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:28:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46333 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3J1F2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:28:34 -0400
Date: Mon, 28 Oct 2013 16:28:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Widawsky <benjamin.widawsky@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20131028162826.19047f4f1686a375d8de0beb@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Oct_2013_16_28_26_+1100_1YpAtSvv/X2I0w3p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Oct_2013_16_28_26_+1100_1YpAtSvv/X2I0w3p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_drv.c between commit 828c79087cec ("drm/i915:
Disable GGTT PTEs on GEN6+ suspend") from Linus' tree and commit
9d49c0ef4089 ("drm/i915: move more code to __i915_drm_thaw") from the drm
tree.

I fixed it up (the section of code added to i915_drm_thaw by the first
patch looks as though it could not do anything, so I just used the latter
patch) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_Oct_2013_16_28_26_+1100_1YpAtSvv/X2I0w3p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbfX/AAoJEMDTa8Ir7ZwVmOMP/2dmq/n6GzOzJo3cGRNpMLXx
3MuEqU2RvQd+oIrQAccfeWoqI5Sqznxt0R/08d7W0MYTvGx4ZS748OG2p6ezk/dN
Fm8/r2sm2HgcFcXYirROnpy23KLjyNgqZrmGpjwmjd984xdVD1cdMzuy0v+usMUY
8VIdI59PBasiiqBCFFfPeQlcanX8DmFHinDQJ+eGd4R/2NK/wWG17U3pPDKDvS+1
rDPXAiIicH72XkQYH1d/+7DcdOP9xeG/jYtEz7PWm3cqaWMti0tJAwfu7BhPCttz
WGVt37fkwgchRfB7eMZCpZzAWl8b8RVPNBdhB+FxaGalT9rHCTVBu7yQpMEA6Zia
aLLR9K6Pzl12HS/CkQDAYriHVIRLQjAmmT+BPuJzfCI7mBS11TLZD5lI8OcP+1gY
hQJvFUfLkGzWocLLTtoOseeLZvKlxUkin8Jqyq1zi9W2/cyAjf9xHdJxe+ODHG4I
v5Pvbq1IA/4pFpg9K3p81bKWSrEtucQI2CrlOC4pz835ELeYfXIO0h4UPgSWWpXb
ivjNLZ8MNMkpBvmbGkl+/Nlg8+6zmFKgdTZAblThK2XP678qtVyWcA3KNTcJgUVE
yIjLoBjzGcNq3u8psUmfxL72IgNg+mWnVRf9iY29IXQMcrGxFSKv91/0elPXoLY6
/2dIWIXm661YNJxqZrRO
=kgju
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Oct_2013_16_28_26_+1100_1YpAtSvv/X2I0w3p--
