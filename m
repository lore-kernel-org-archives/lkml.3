Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab3BKL5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:57:50 -0500
Received: from multi.imgtec.com ([194.200.65.239]:38837 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881Ab3BKL5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:57:48 -0500
Message-ID: <5118DCA8.1030905@imgtec.com>
Date: Mon, 11 Feb 2013 11:57:28 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        <linux-sh@vger.kernel.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] Centralise CONFIG_ARCH_NO_VIRT_TO_BUS
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net> <CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com> <20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
In-Reply-To: <20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig37A461183FDA2E5D4D4AAECC"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_11_11_57_35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig37A461183FDA2E5D4D4AAECC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On 12/11/12 21:26, Stephen Rothwell wrote:
> Make if easier for more architectures to select it and thus disable
> drivers that use virt_to_bus().
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I was just wondering what the status of this patch is? It was in -next
for a while but seems to have disappeared.

Cheers
James


--------------enig37A461183FDA2E5D4D4AAECC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRGNytAAoJEKHZs+irPybf7bsP/RSiVOQdalVSVaHYvN15XDWz
p+iSIRyYRLbaYTJ3Sln+av82+aVnjMi75l8UBsWLHGKkLSMB4SqnOTVmASJHVnFp
w8ClS7+/UmlQySB8o5YxQ5IFPO1MaRBYOTPBpc+Y/y6Ub045wzW62wvkjD7j1Rl3
uVTldd26lD+hysgWEjQOYIl3ZaAeMmSTx+zML/1XxHRFODCVCId5GyGaP8mulRIj
aeemZHXqZFpzGAJbun52dOy0xI8iY+fj9jzwyoFKq2bMyRHt2CV7b2DsRmrYLT+G
pTJQpqn609pFYPPFsHD8pCKBZOAzz2KUJjJmf0yAFViAdzaoeSvKQ/405J6ja+0J
7BJguKzKTJI5MpPe+w7Z6XeNMz4nmhz6JkezwMsEWs8mm2f/ZtvJQQNeJGJ1MD7e
JUolNN1DjDHNck8i8ZfoA5AiCpdqNqu8BWLc/EW3fE4+dvbkW9N7nG3pu8wQsGBk
ZS46URl1F8tHHUNVg87pDoYKJU91FTQzq+8TX658R1Voqg2xMRjjBaZkpQSiC16k
Ewx+uSTWe5Uf7PcjcRdqbLxpvKgoJyD5BSsat2doSk12s/Gv3zeF5Z3Va5Ldn2q2
r0d4b6qGvL8q6LAhxeVUsVynPBv9UC3UMP2jMNGAecSXrqjwA3qgOOdkwLulIfVM
r5wi1jOQ1/vVvboMQJ6z
=wprH
-----END PGP SIGNATURE-----

--------------enig37A461183FDA2E5D4D4AAECC--

