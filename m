Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaCEMoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:44:22 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48106 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbaCEMoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:44:19 -0500
Message-ID: <53171C16.20505@ti.com>
Date: Wed, 5 Mar 2014 14:44:06 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: FB_OPENCORES should depend on HAS_DMA
References: <1393012569-22560-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1393012569-22560-1-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="qX4r0E5FKqhRUBSi70TVJGJdwKKDcR6FB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qX4r0E5FKqhRUBSi70TVJGJdwKKDcR6FB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21/02/14 21:56, Geert Uytterhoeven wrote:
> If NO_DMA=3Dy:
>=20
>     drivers/built-in.o: In function `ocfb_remove':
>     ocfb.c:(.text+0x27fee): undefined reference to `dma_free_coherent'
>     drivers/built-in.o: In function `ocfb_probe':
>     ocfb.c:(.text+0x28418): undefined reference to `dma_alloc_coherent'=

>     ocfb.c:(.text+0x284d2): undefined reference to `dma_free_coherent'
>=20

Thanks, applied to fbdev branch.

 Tomi



--qX4r0E5FKqhRUBSi70TVJGJdwKKDcR6FB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFxwWAAoJEPo9qoy8lh71XxwP+gKLDjnzZw7TH1CM5fTMBM4O
rG+y/Y1S07m8hqqiqTnhtBu7uqkpEB13Mr7ZKVQegmv+Z3vmyQzm0PrwhIXsQFpz
nz38fT0PmPu2aP09BgC4b789LVMDqFCyvKlKAzw0/HGKABH3yZqqU94MoiyviDVm
PcDTQ1FowhyC88MG9OO+6eMhf5JHWz7qf86pb130fn++vFkumlXXEwyMBgwjPdvv
gcMXi+exQf7x0se30heEjX3PUZAJn+OFI+g5eDVPFamCl8kM5PWk0S7a0webnv/z
rrAIvTTooJMNk+MWOjF8bfaJmxDkfO9LK5X76WJcUx3z0CaMcSLlonqoCo1sbqRy
WPyn9GxAKnqQ3qZjpd+uhZmq6yefnW91TfFFAxcl4qyYrD6WHagv3Zdk2U0hBIpB
2mXVVzkUwenAEld+0K7dNW+PydkQi8ivXR8EOArAEwBHzbp2iqURk8CqCliPZ6YI
6AUddmF57bwnyMPST9hETmGKQaLmbybdQyWNSIUMXaCC8jTCZ4AK58w/OYuQX56J
Ht9/4ZyrRfqfqEiq6LtpvOcsJ56knubFCnd8PGgC8UevshrgXb3c6gbgvMoCg009
SHyNuy7hGsrHfh/tHJZu0tZJ6UA+DlzN3I8ISuN5ST2GI7JyARurBeR5siyLiFx/
oYqKRhM7fhKAytUpLiiq
=LBRN
-----END PGP SIGNATURE-----

--qX4r0E5FKqhRUBSi70TVJGJdwKKDcR6FB--
