Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab3LLLRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:17:17 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:48120 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3LLLRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:17:14 -0500
Date: Thu, 12 Dec 2013 12:15:57 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Shawn Guo <shawn.guo@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Wei Yongjun <weiyj.lk@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
 host maintainers
Message-ID: <20131212111556.GB11524@ulmo.nvidia.com>
References: <20131211183237.GI4699@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <20131211183237.GI4699@google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 11, 2013 at 11:32:37AM -0700, Bjorn Helgaas wrote:
> If this looks reasonable, I'll merge it via the PCI tree for v3.13.
>=20
> Bjorn
>=20
>=20
> MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers
>=20
> Add entries for PCI host controller drivers in drivers/pci/host/.
>=20
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  MAINTAINERS |   31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)

Looks good to me:

Acked-by: Thierry Reding <treding@nvidia.com>

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqZrsAAoJEN0jrNd/PrOhoGAP/Rwv5Hl1kzl2/sl6eHcZ5ejn
weIUFpPMDI9nlrXDrB6WLC7AeUa2ZiK6VIyg2gn+ORxqtSxlzb9o4X0CQmqvhK91
RK8cXNasIqNUp5cTzihzvRvPlPmYhElSmqgoAV35BHh14hhaVNxtbnKqTNGUjQUR
JX+0SWNllb2wG6Bc2kA/mIk2HU4OugQmIIFsZ+Kh8rFNKFYW/gh2b76fkZwAi9Ra
ncRoXec7XZkC9cVgxiCQwlifwgzNzMzbmTz1LvqUkxN5shBebaBvRJbcfST9ILEg
JoVTDzJCmhtRt5ugJX7nAXvJmIdwZaTGl1rUtDKWs5fFPT3LPDCqcdUl+nyBIuSL
wZ4z9S5ya2hYdOUQzvDzY91n6BCiquNVqoJNEPMj23A8EqrrpfDPfn4wChwLJtxK
QyxCbfQwchhLVQeZBrOtEaTMJaZXl14zbM4YzkPCBndyoOzDc0jD3paf21wilVo/
ogBUcVdeQcgm3H+EFueJSBlhVsmwmJHGKbgmLJp0F6wpeAFeBph/0mKTf2yyD0TJ
WJ3Xs9y1E4DxcaUPnx9VSuijo4OEkGrXZKd+2AtXjjRNV6ZU4tbYlts9ecYZ3A6V
dmZZKg0hhyVkT2H5VkPCkb3PuZVpMEuvN6jofe34/KmD0vtyGj4ZguZvmW8EAzAN
6wY+t8q6F2A6ZfhotLqG
=Y3ls
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
