Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbbA2BNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:13:21 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62823 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbbA2BNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:13:17 -0500
From: James Hogan <james.hogan@imgtec.com>
To: linux-mips@linux-mips.org
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] MIPS: Add arch CDMM definitions and probing
Date: Thu, 29 Jan 2015 00:16:38 +0100
Message-ID: <5668659.y0L0n9UuOk@radagast>
Organization: Imagination Technologies
User-Agent: KMail/4.14.3 (Linux/3.18.4+; KDE/4.14.3; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1501280253280.28301@eddie.linux-mips.org>
References: <1422393401-13543-1-git-send-email-james.hogan@imgtec.com> <1422393401-13543-2-git-send-email-james.hogan@imgtec.com> <alpine.LFD.2.11.1501280253280.28301@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1552609.32XrLGTaGl"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1552609.32XrLGTaGl
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Maciej,

On Wednesday 28 January 2015 23:09:17 Maciej W. Rozycki wrote:
> On Tue, 27 Jan 2015, James Hogan wrote:
> 
> > diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
> > index 33866fce4d63..2086372fa72a 100644
> > --- a/arch/mips/include/asm/cpu.h
> > +++ b/arch/mips/include/asm/cpu.h
> > @@ -370,6 +370,7 @@ enum cpu_type_enum {
> >  #define MIPS_CPU_RIXIEX		0x200000000ull /* CPU has unique exception codes for {Read, Execute}-Inhibit exceptions */
> >  #define MIPS_CPU_MAAR		0x400000000ull /* MAAR(I) registers are present */
> >  #define MIPS_CPU_FRE		0x800000000ull /* FRE & UFE bits implemented */
> > +#define MIPS_CPU_CDMM		0x10000000000ll /* CPU has Common Device Memory Map */
> 
>  Is it a typo here: 0x10000000000ll vs 0x1000000000ull?

Yes, it would appear so. Well spotted!

Thanks
James

> 
>   Maciej
> 

--nextPart1552609.32XrLGTaGl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJUyXvtAAoJEGwLaZPeOHZ6G84P/2pUYfaem5Swny14MEfdn/26
dRSXnSCsbbryWQ+FEtZqe2BMPxLNVMlGniLxE4dWjqAWkgY0Wfo/2gOShBs+iN1e
QtRz+iCU/DNxnp4nBVsD/RaEYE/AjzLqh+zQD9FqkK6UonsGmAmU78BQ4lNe2gTk
IrgAMBKnokIhVmliup8nAqz4pjiOTwjNzGUYMDeQXMHTI1bXTlo/6gokWRjCMKmb
nYekCBwwU8tnzCY0+F8R7bN9+m6FP2S1KP8QRn53gnKg0zB+IrQ0H7lRpBak9fpm
/zg7oZrLTu12Pyhm2WOEYN7jBRbpp3n9xc6qYE8vjKJ0jnj7dvVI13j3+DCmDlvo
a6GZSovbelq9pe7ySzLvAFqjPPLCUHJrHsTUCf+oEnzCU+3COl32hlSCTb7ii61K
abdXkx1mbdiTNqEcpmhty0moX8DisYGC+hY+UIpz+7NCYyXFRhc4VMFkJsyCcDPk
XbVrVqUiwpYZBWuMbfqVdRlWKWiN4NPuUprSstZ1U7R7EQrWaNPgrZZdq+ykwQ3X
U45rZA87u8llW4qsLJE8qLWACFAjwfTWsbySpGuoAJm4aGZoSuDu/JLTXRv+ps3k
HQPoKZUrH6YJk6zcgpI4ikoAe68dHeu17/rjDEw/eNED8XMEyDpr8tnqgQCrWVdV
YZ6auhprKGqNShUQ6RdT
=7Txp
-----END PGP SIGNATURE-----

--nextPart1552609.32XrLGTaGl--

