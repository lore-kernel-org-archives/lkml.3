Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbaHZMwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:52:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41502 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaHZMwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:52:12 -0400
Message-ID: <53FC82F1.5000709@ti.com>
Date: Tue, 26 Aug 2014 15:52:01 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v2 1/2] msm: msm_fb: Add remove function for platform
 driver for clean unloading
References: <1409055038-9204-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1409055038-9204-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="bgw8PcqXxfofNAmxR3CBSuOXi20wHT1Nr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bgw8PcqXxfofNAmxR3CBSuOXi20wHT1Nr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 26/08/14 15:10, Pramod Gurav wrote:
> This adds a  remove function to platform driver structure so that
> resources are released when driver is unloaded.
>=20
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>=20

Thanks, queued this series for 3.18.

 Tomi



--bgw8PcqXxfofNAmxR3CBSuOXi20wHT1Nr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/ILxAAoJEPo9qoy8lh71ZnwQAKo4GEDhaZpPw/mKdTz/Gs45
7J6KQkhkWjpe6HavFlxaWdauNYu/eq4EeLCs6QJZrnHCQqzJPj1JLWCoBluaj8+Q
JWPd1q97aCOUl/3kMJYqky7FOaXvBwgw01rDdRMqcx8JMZCVQ4W0Uu20N6cDAGAD
hEcUiTvmc7T01EGwAsE3SKWZn5bowWA7H5xfNZg/TSpIA7G2FPPMLOFe4JwpkEg8
ObqBRh9dwvn28HnttG4PUBpfuRg060j/3Nwm1TQBrYyquCXlmdiNsR7kFBmLmEoc
uanLMqrv4wKxG07+XMUaQ7bb9DZEn7B1aeGSEijB5ZRzU6MctdR5Tu9cqEjqeEIy
jPOpbMUXKdpKiIerJk3kAJCwk4Os6UEBWzZsK1yKPesBW1b/HtGhtcSib4bmgEDc
1Jw+O7ngm6UrDxTvL6IaqXC/z0FQ7US4hyEDF8Ozqj3zNUJtaCjYgXYX2P2nyKKj
aTHgWQU/hH3jkYU0qxQYV76lg+c8ZlDl6sEDzTh2EUOwm4JNpGbRMCSIlUGTjuxw
Sqo/4VcBLVi6KRwzmrQnSVsYqbXjchLl387ClSTmjomhA7UoNjiIkDKV2AxfFeYQ
4hmDjC1roxA3Hla9pHO5nmFSKvz2OtbEMKsw01kJcv2yyLs2GJ3QubShq7OU4BXa
BpeLV2qqBztZlbeafTe0
=ePcy
-----END PGP SIGNATURE-----

--bgw8PcqXxfofNAmxR3CBSuOXi20wHT1Nr--
