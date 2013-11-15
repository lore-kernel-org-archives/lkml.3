Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3KOSF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 13:05:56 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58209 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3KOSFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 13:05:48 -0500
Message-ID: <52866265.2020302@gmail.com>
Date: Sat, 16 Nov 2013 02:05:25 +0800
From: Lennox Wu <lennox.wu@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Liqin <liqin.linux@gmail.com>
Subject: Re: [PATCH 05/17] score: Use Kbuild logic to include <asm-generic/sections.h>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-6-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384285347-13506-6-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="42XAxbj6C0511c4Lgxhs57B4VvUKKJQdu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--42XAxbj6C0511c4Lgxhs57B4VvUKKJQdu
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: quoted-printable


  Acked-by: Lennox Wu <lennox.wu@gmail.com>

=A9=F3 2013/11/13 =A4W=A4=C8 03:42, Geert Uytterhoeven =B4=A3=A8=EC:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Chen Liqin <liqin.linux@gmail.com>
> Cc: Lennox Wu <lennox.wu@gmail.com>
> ---
>  arch/score/include/asm/Kbuild     |    1 +
>  arch/score/include/asm/sections.h |    6 ------
>  2 files changed, 1 insertion(+), 6 deletions(-)
>  delete mode 100644 arch/score/include/asm/sections.h
>
> diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbu=
ild
> index f3414ade77a3..32cd967c19a4 100644
> --- a/arch/score/include/asm/Kbuild
> +++ b/arch/score/include/asm/Kbuild
> @@ -2,6 +2,7 @@
>  header-y +=3D
> =20
>  generic-y +=3D clkdev.h
> +generic-y +=3D sections.h
>  generic-y +=3D trace_clock.h
>  generic-y +=3D xor.h
>  generic-y +=3D preempt.h
> diff --git a/arch/score/include/asm/sections.h b/arch/score/include/asm=
/sections.h
> deleted file mode 100644
> index 9441d23af005..000000000000
> --- a/arch/score/include/asm/sections.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SECTIONS_H
> -#define _ASM_SCORE_SECTIONS_H
> -
> -#include <asm-generic/sections.h>
> -
> -#endif /* _ASM_SCORE_SECTIONS_H */



--42XAxbj6C0511c4Lgxhs57B4VvUKKJQdu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEVAwUBUoZiaRIBnItolwGVAQLJhwf/Yq9YsAeveJsuG7dKN2Q8BJ1PooMrC2IW
qJzwqsFST6VYV1yE3SaDtfX5cL4K/4AZeClmd9jrv8okdvVwN3CgZw6RhWYouYxZ
2aFYPvE82KbT2LWQx/V721m0nc1PDDSwC+hH/naDzchnIuFmwDNm/Cdbd4HVv44U
Dah1mMQq0dQSBVbxRtqAxZgBhN2FzKbq/pHE4gRMDr7MZu8Cxign5+l//5PCO55j
D8IxNkGyVRxWq8BnJSZzgK5rpj4vqsjKmeCYhECVsqUrLXZujUJccDYGKJgTzDRz
At1zfAlAaaEpC1dc1DtPNWLL+f9FfznOrotDQMwFRyIfcCNAyEQ+MQ==
=bjNx
-----END PGP SIGNATURE-----

--42XAxbj6C0511c4Lgxhs57B4VvUKKJQdu--
