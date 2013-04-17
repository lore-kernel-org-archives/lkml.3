Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab3DQGDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:03:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54768 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3DQGDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:03:09 -0400
Date: Wed, 17 Apr 2013 16:02:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: linux-next: manual merge of the renesas tree with the gen-gpio tree
Message-Id: <20130417160256.3bb8bc1e26fe4e9dc47fe5f1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__17_Apr_2013_16_02_56_+1000_Dq7XpV1SvUfknija"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Apr_2013_16_02_56_+1000_Dq7XpV1SvUfknija
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
drivers/pinctrl/sh-pfc/Kconfig between commit 76ec9d18b897 ("Convert
selectors of GENERIC_GPIO to GPIOLIB") from the gen-gpio tree and commit
809e5fce84f4 ("sh-pfc: Remove dependency on GPIOLIB") from the renesas
tree.

I fixed it up (using the latter) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__17_Apr_2013_16_02_56_+1000_Dq7XpV1SvUfknija
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRbjsQAAoJEECxmPOUX5FEQzsP/39EOaL22DgZpdgxyyI4TYT3
hgJ4/lvYL5LkYWMx2OOk8zczN3ttjum8v2haUEho9b1Oya8zwmfFeqzNf1FEEtUt
bpHN2SgeNaa3ljKCLZ9VQOkm1lvAgGNxUpCvaamgU4+dwKqBYEGN8PFv0PhikOk6
4biQSmGIVXzNwy731pbqe3xUoUnXavXQvFgZ04PloQZ1vZKLPnjwxpbT8/EfLK6M
zVFIpD/PI9lr/fJvM56XOp2Pu0XmEe1w+0wQkrrYXhAQ0H+UYpRi0NX5tm1SJiLf
K5jIy3ycs5izJhJLZIf1L4/TNM3F9QVUSTbUwkISMH2cGWTZE8fi4Fhpju50tgQ8
jyns0WAvD6Nhg/yFHaPAu3fTpcczobbXdeTK+IqHjPM7suboE3m5Pk0i1d7w7MpH
gMdyJvOz5ByNtwhXsOxiDZ1Qmapko0DTsq1GW4Pm/bi0viOlfSr93B0RHKNzvAIt
HCLCCWWG3o6fK50eenOp2jf820NPksXcKeNgaBJwlDV4aofZE0Hu1gYy9JXXPELt
weLE+umdNDA1h265yMeAnfgl+AfRTXLTF6cBqPtQ5P7XQKsaMuW4L1kE6hVtbIRw
uCrHYak5hPcehYEFfyqCD1B3femB2DcF+37GPSgXzgnboKKzo1RqoKphN4Yf3ocK
mFCJ6DG9Jloal+FXrG/8
=fXQ3
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Apr_2013_16_02_56_+1000_Dq7XpV1SvUfknija--
