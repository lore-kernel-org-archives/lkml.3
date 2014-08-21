Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaHUNYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:24:41 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41750 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbaHUNYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:24:39 -0400
Date: Thu, 21 Aug 2014 15:24:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dma-mapping: Provide write-combine allocations
Message-ID: <20140821132433.GC19293@ulmo.nvidia.com>
References: <1403863018-20033-1-git-send-email-thierry.reding@gmail.com>
 <20140801124057.GA19889@ulmo>
 <20140801151917.GS30282@n2100.arm.linux.org.uk>
 <53F5CC38.7060902@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <53F5CC38.7060902@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 12:38:48PM +0200, Marek Szyprowski wrote:
> Hello,
>=20
> On 2014-08-01 17:19, Russell King - ARM Linux wrote:
> >On Fri, Aug 01, 2014 at 02:40:59PM +0200, Thierry Reding wrote:
> >>On Fri, Jun 27, 2014 at 11:56:58AM +0200, Thierry Reding wrote:
> >>>From: Thierry Reding <treding@nvidia.com>
> >>>
> >>>Provide an implementation for dma_{alloc,free,mmap}_writecombine() when
> >>>the architecture supports DMA attributes.
> >>>
> >>>Signed-off-by: Thierry Reding <treding@nvidia.com>
> >>>---
> >>>Changes in v2:
> >>>- Add a generic dma_mmap_writecombine() function
> >>>
> >>>  arch/arm/include/asm/dma-mapping.h       | 16 ----------------
> >>>  include/asm-generic/dma-mapping-common.h |  8 --------
> >>>  include/linux/dma-mapping.h              | 26 ++++++++++++++++++++++=
++++
> >>>  3 files changed, 26 insertions(+), 24 deletions(-)
> >>Ping?
> >I have no problem with this, but I don't think I can say yes to it; that
> >depends whether other people are happy for this to live in
> >include/linux/dma-mapping.h.
> >
> >I guess consent for this change can only come by no one objecting to it
> >after several postings.
>=20
> I will take this patch my dma-mapping-next tree and later send pull reque=
st
> to Linus, so it will be handled in a similar way as all other changes to
> generic dma-mapping subsystem done in last 2 years.

Okay, thanks.

Thierry

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9fMRAAoJEN0jrNd/PrOhdw8P/3Ty6XtYDNhTMBTbiAgm+WIs
tbBnctP2qSv33Za8kg7XONTC69XrAn82zpyM3izInq6w4ZtmOG6WxiVPxTlVZ5aA
7hWRHbtuncrm5ru99P0uiX7x8g5L18PkTaWH2ScxGUvcXuFRWBw/0vU8j2MLsKtE
F01BLLcBO8Sz7X2hKp658diNA3jairkRTIXF30Nx9DslOIArk8/PLqRvAN5cALtU
kFFY38Vexv7vdmU6VdUmqpM7GVsfxejrkTL1Omc6ET/JkOvf1cY/hstdKRBIpf0f
gVt90PfgvRR58R4MoL75J/vGSIX0ZDRr/QL93jbhu3Oom50AVkazJnG2L+9CUB1g
6lzboO5TLx7vdMEqpQyJfqXKu1zv3H7jednfDIDKrXxUx31LZaA36PKwOCg3pvc/
s34ImRFnnLo/sWNZYDpkh3eES7cNr4gpgWsIX9CXRJNCgezA7VuXRW/yz7oQ7veD
Z5qVOEQmoMhDHpnN2UbZzh3xkJf7xFE+FCgqqN4t5dUXsMfMs66BKUdsGt4mfLxd
z2cyeK92Oaa+VtjHJrmfj9nVAGa7vMb0bEyyGXxca+EBMjsMplwvuhswBJrGJw6H
on7+WtLKC8x094IUy2k4Fb05SO2O7nlbal2ocovOrE6AMHzgiWu4VGKDF6v5YOft
RQh0orI+bErkHbKglQOT
=nQhz
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
