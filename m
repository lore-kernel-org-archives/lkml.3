Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3CFUu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:50:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48138 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3CFUu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:50:57 -0500
Date: Thu, 7 Mar 2013 07:50:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (staging tree related)
Message-Id: <20130307075055.a8722b275ed6edb53839e13b@canb.auug.org.au>
In-Reply-To: <20130306200444.GA13744@phenom.dumpdata.com>
References: <20130306113508.9c868be103b6b140295c548f@canb.auug.org.au>
	<20130306004341.GA28426@kroah.com>
	<20130306135654.GA10760@phenom.dumpdata.com>
	<20130306200444.GA13744@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Mar_2013_07_50_55_+1100_8iNF4jwy3_jD_.G9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Mar_2013_07_50_55_+1100_8iNF4jwy3_jD_.G9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Wed, 6 Mar 2013 15:04:44 -0500 Konrad Rzeszutek Wilk <konrad.wilk@oracle=
.com> wrote:
>
> So, irrespective of zcache, I also see this:
>=20
> init/built-in.o: In function `.rd_load_image':
> (.init.text+0x1b24): undefined reference to `.__bswapdi2'
> arch/powerpc/kernel/built-in.o: In function `.iowa_writeq':
> io-workarounds.c:(.text+0x2f778): undefined reference to `.__bswapdi2'
> arch/powerpc/kernel/built-in.o: In function `.iowa_readq':
> io-workarounds.c:(.text+0x2f848): undefined reference to `.__bswapdi2'
> arch/powerpc/platforms/built-in.o: In function `.spiderpci_readq':
> spider-pci.c:(.text+0x2a84c): undefined reference to `.__bswapdi2'
> arch/powerpc/platforms/built-in.o: In function `.scc_pciex_readq':
> celleb_scc_pciex.c:(.text+0x2fc4c): undefined reference to `.__bswapdi2'
> fs/built-in.o:(.text+0x9717c): more undefined references to `.__bswapdi2'=
 follow
>=20
> Is that new?

I don't get those.  What compiler version and config are you using?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Mar_2013_07_50_55_+1100_8iNF4jwy3_jD_.G9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRN6wvAAoJEECxmPOUX5FEDGcP/0jiaMxOYdZq2fyNYB9DdCa5
ctI1uXUJDVrtf7OIa5tCtsFdHDJereNmMunD57zO7JVq8wLI5TMF1xKof7RX7Smu
369qLme2LLsKIQzr+YAj7me8+nqQ4MUdqJaaq6NC78mEAeyJp/4epkynvbw/ULnm
hCaGAQkouFIa5Rd4ThBsKGc7nlImnYUapHD9d3qvOEGT5cnniFf7aUN5PUeBnEmX
B4Fs1RtQYXBTFyR55Al9UgGE24Y3M8n8u2W/n2LWj2IaeNFpZspJilFMZ9VWC3Rp
TUCaxpfhw0A/2Z4OKD3ceq34FDN2Qk+hPiJ+AHY9b7M7U3sOcrjGwvo5NjpYpDRY
EMAnBnBPJ/1cUSluTR5BbquSNp5ICnDTkJ/UAhjCZGPIN5phTUT3ZTOmBztbXCQs
wGnxqjm9o4kb2BZNurvUNqeQIZfI4yCaGJaH93zkx+cuzVUq6CGzTN2JzI665S5H
0SY7T7Igxgh5gL92u0fbBlN5lD72kZ092HhZrHRYg6CM0M7sCVIFOF3havm0e4N6
MLaSMC5x8KX8QgIkOjGjK3ixDHtsQHQYLqhC+f+RB8IfJ4u6zClMgIVsHXVtU2Zt
b9v7riZbQHqPoOwjtIbRPSP/fL2YnC5s8Zg0UYFLTGV3HwMobGA9U22jV+wdp/3j
PynqE2x0Pydl1sOwxMge
=9T4T
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Mar_2013_07_50_55_+1100_8iNF4jwy3_jD_.G9--
