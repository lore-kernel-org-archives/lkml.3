Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab3HBGib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 02:38:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44038 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab3HBGi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 02:38:29 -0400
Date: Fri, 2 Aug 2013 16:38:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Greg KH <greg@kroah.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: linux-next: manual merge of the usb-gadget tree with the usb tree
Message-Id: <20130802163818.e29c7e6d3472cf161703ae60@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__2_Aug_2013_16_38_18_+1000_ESqjQViPTQjRM5HA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Aug_2013_16_38_18_+1000_ESqjQViPTQjRM5HA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/host/ehci-tegra.c between commit d4f09e28d7bc ("USB: host:
use dev_get_platdata()") from the usb tree and commit d50642794508 ("usb:
tegra: host: Remove references to plat data") from the usb-gadget tree.

I fixed it up (the latter just removed the code updated by the former, so
I did that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__2_Aug_2013_16_38_18_+1000_ESqjQViPTQjRM5HA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR+1PeAAoJEECxmPOUX5FEitQQAKT6pTekK1yxxxJduHtjklXm
wWG1pX6eOj5DlHFUKuWnRaQYVxSsw9AbAUwwp7W6lZrTYXCy1u/A+xliow1iC2Xv
07o1MNE/5riLFYLWn34SDXK57f5fiFYBXETvXcQB1aCFCseWX8kJxbQprHZcUz3q
BbU9vaOz93dY1aKvSxaITy2HF0y82hP3/pRg/802hBfWrSO6047qrlAOh5lxjv+P
G6qJqwKIVE7asZY3tQmWrz5rWnykPTCj8Lq52Vpe5BAZZM1EXwLfMbp8NN82e9f3
mMfZQSSq/XS1eLdxDl/7s/24SrYNBSS+Q2+Xb8JJO1V6h4G57H1z0nfKbR9oISk4
WRlcE3WgpTlqv0nRWWfRCP3iHlYamrbMciBTxlItAcTt6WWldGPMI1U0nnF0EATN
/Miw2mN75D2LmBk1I2BFLsEChLaohuQlm5fyAMSWTcx0LBi+dkXMWADZ/vzXEhf/
wUMQO48xAFBgp1nHWLPhmxa3L9YEb3QTfp4uWcF+oBvydFl3OWQfxswtadHzivuN
1Bw0wboSRFDgnnu9lFp8uTcEOqcehpUD85uS0r2iV3L+OZafc7CeLRBTeV8d84q/
bvEcMyD00MYoA3puTn4Nctd1tR+dN1mvaLFDYwjgh7X45uhSU8AgmLiggwBznSM1
78s8Qv2arNF8RJCUUlDJ
=ztAT
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Aug_2013_16_38_18_+1000_ESqjQViPTQjRM5HA--
