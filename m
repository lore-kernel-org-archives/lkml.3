Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3A2LJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:09:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39623 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab3A2LJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:09:50 -0500
Date: Tue, 29 Jan 2013 19:09:36 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V2 2/4] regulator: tps65090: add DT support
Message-ID: <20130129110933.GE32597@opensource.wolfsonmicro.com>
References: <1359450318-24912-1-git-send-email-ldewangan@nvidia.com>
 <1359450318-24912-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PMULwz+zIGJzpDN9"
Content-Disposition: inline
In-Reply-To: <1359450318-24912-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PMULwz+zIGJzpDN9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 29, 2013 at 02:35:16PM +0530, Laxman Dewangan wrote:
> Add DT support for TI PMIC tps65090 regulator driver. The DT of this
> device have node regulator and all regulator's node of this device is
> added under this node.

There doesn't seem to be any dependency on the rest of the series so I
went ahead and applied this, thanks.

--PMULwz+zIGJzpDN9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRB63mAAoJELSic+t+oim9X8wP/2SKw9HkjewSFmcUEdc1S7Xt
7GvzfgR8MEOIAU6t7kHehtSRtQEzc6/KTssx4m6OTVLqjXkdXXRU2EbvmpKy4j8y
FAzKVq78am7YXGka+Pcb9aM/0KX1I9aAJfSF12E0PygBfmJTCYPrzwqqOLgY+rk4
AhVqgph9UfhV8KAXCQ4LAQ2wUdAyWcJ8iOIkIPQmpm/ZRXaJgSck16LIa+H8zDi7
vCe0IBA/KqFULAzfPtdn4Ikb6NdZQIIb44eJ4bwZLgZQ+vz1iUmcZHEZOM9v/bZ7
kgrxJQHacq8O3aXQk0ZA8Qmr7zvbN5G20bdAXebYah1gsWD/lpxj2/IEMKt00jVG
JikYlcDpt4Sy3GVuCl7PgqnmVrhfMZEPhq6SjcO4XcNcIWFi2n8pR4oRkLWDtcMD
6cc7qolW/J+mE6Jqml8vpqdxrd5OEUCyeV6dJgmUrlxdalFQPDFvbsrV6HIrUfXm
PzhesUY4fuhMdqwjMszdl1GURcvPktN13EynTxM54wZXBIB65aoasMqquNoznDdq
Mo5Dv6n6dNFw1c0EB7/dk7NUDs2rbLEvKCOStEeUWPvzm+xO+h/xOv19zsGRDJVy
BP6KGfP2xEwhSVw748QNFMoTaVMNf6P/sOaBZL9u1KtZqnBXt6RZ6uCvDHVUxjzG
jQHLhfHYVtNAu/7CVe84
=e6N6
-----END PGP SIGNATURE-----

--PMULwz+zIGJzpDN9--
