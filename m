Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3JWOHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:07:43 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:63019 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3JWOHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:07:41 -0400
Message-ID: <5267D82A.3010307@gmail.com>
Date: Wed, 23 Oct 2013 16:07:38 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: The development of GNU GRUB <grub-devel@gnu.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>, keir@xen.org,
        david.woodhouse@intel.com, stefano.stabellini@eu.citrix.com,
        Daniel Kiper <daniel.kiper@oracle.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>, xen-devel@lists.xen.org,
        Jan Beulich <JBeulich@suse.com>, ross.philipson@citrix.com,
        richard.l.maliszewski@intel.com, boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] EFI and multiboot2 devlopment work for Xen
References: <5266620602000078000FCA48@nat28.tlf.novell.com> <1382435127.1657.70.camel@hastur.hellion.org.uk> <526668A502000078000FCA7B@nat28.tlf.novell.com> <20131022134252.GA27302@phenom.dumpdata.com> <1382449985.18283.12.camel@hastur.hellion.org.uk> <20131022140947.GA17829@phenom.dumpdata.com> <1382451868.18283.21.camel@hastur.hellion.org.uk> <1382455358.18283.31.camel@hastur.hellion.org.uk> <20131022162632.GB19189@phenom.dumpdata.com> <1382517150.22417.21.camel@hastur.hellion.org.uk> <20131023131348.GA23898@phenom.dumpdata.com>
In-Reply-To: <20131023131348.GA23898@phenom.dumpdata.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2EGGLESAVBQLOBUFKDFAN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2EGGLESAVBQLOBUFKDFAN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 23.10.2013 15:13, Konrad Rzeszutek Wilk wrote:
>  - not make an ExitBootServices call - which it does right now in the S=
olaris
>    GRUB2 case and in the Fedora GRUB2 case.
What about having a special tag in multiboot2 file header "RKEBSIHE":
"request to keep EFI boot services" and then bootloader will pass
another (empty, other than header) info tag: "Beware of EFI"
>  - Do the signature verification (hand-waving which one - probably both=
).
Can someone throw me the link on the EFI signature specification? Can't
really find it now.
>  - Pack the right bits in the multiboot2 structure.
As soon as my patch is tested for compatibility with Solaris, I commit
it. Tell me if you need sth else.


------enig2EGGLESAVBQLOBUFKDFAN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJn2CoACgkQNak7dOguQglb5QD+KtDa5y4T4bCajaI/IehayhQ3
YeRPLrRXQpUCHH36N3AA/0NEXyP01ZoZd7Ez5aJx8MnooeomFHAVX16krDFgK2sw
=CQ4C
-----END PGP SIGNATURE-----

------enig2EGGLESAVBQLOBUFKDFAN--
