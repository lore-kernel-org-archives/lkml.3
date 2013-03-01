Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3CAByl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:54:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48058 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3CAByj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:54:39 -0500
Date: Fri, 1 Mar 2013 12:54:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ying Xue <ying.xue@windriver.com>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>, Dean Jenkins <Dean_Jenkins@mentor.com>
Subject: linux-next: manual merge of the bluetooth tree with Linus' tree
Message-Id: <20130301125425.1819c6cc77fb64be71351ade@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Mar_2013_12_54_25_+1100_8Z82eTK66fLT_ln6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Mar_2013_12_54_25_+1100_8Z82eTK66fLT_ln6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

Today's linux-next merge of the bluetooth tree got a conflict in
net/bluetooth/rfcomm/core.c between commit 25cc4ae913a4 ("net: remove
redundant check for timer pending state before del_timer") from Linus' tree
and commit 5c87e6efd14d ("Bluetooth: Avoid rfcomm_session_timeout using
freed session") from the bluetooth tree.

I fixed it up (I just used the bluetooth tree version) and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Mar_2013_12_54_25_+1100_8Z82eTK66fLT_ln6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMApRAAoJEECxmPOUX5FEticP/jnWQCWky1nMBKuz70fEQC87
VIdFkpBiJ3XinwiEpFeVuFjdmEstj+92YjAWgPeqV1aSek2Ju0mUQievMPE3Ltn8
c1aNnfTGK/Q6PQjTTuAi0P45nmbTQhffXg4oiOa4UeNOZzKF/msq8Et9w//oHarK
fB3gg79bB88c9sH0g2YWS04vGUpggmFToaXXjer4caNIXti0qXOJL17ouloJ23qT
K3O1kDebDuJg9f8d/XbHTTrVgxyz9O/uMbblV9N/gqxLIsO/9mnV4PbZ3TjkcPRd
YS60ZqTOZENm4vxbxskmfSrMTxsE9Oz2Wl1XFtu/gv8dUUgAYzAAo+jCYIb6Vmy2
AoQzoAQY0sXDEqut36Hqrv2dNILD5Qb8YUj5/+Tc+ZsVVisGsnHsUgiEDR3/MTSM
EKex/WayY8D3dXVUGI8trK+7l03CHM8VmITx60p2tCF82NaJegwjZMzMRflrPfqX
byAmEbehR8xZ15ixvxSXdSHEHlFGsC7dEQVe77frAyeZgJD3N3DZgRFe0le7gGeo
juIOycH49dltamgfKdp/DVMFVDpGpX2/XariZkfwKCtTu/pZ/QFZ5Zzoj6nzkM2f
sxtFhekUSRyGNXpxrNxw+uBKnCG+DKqWQqpVAXoJ25K4tsHT8+u614Nh0tZvbsY0
o3shdbcVOPnuOPX59FuW
=TSIf
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Mar_2013_12_54_25_+1100_8Z82eTK66fLT_ln6--
