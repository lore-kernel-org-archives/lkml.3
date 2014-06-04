Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaFDI2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:28:33 -0400
Received: from ozlabs.org ([103.22.144.67]:54639 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaFDI2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:28:31 -0400
Date: Wed, 4 Jun 2014 18:28:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: kisskb not updated?
Message-ID: <20140604182812.6ec4b06b@canb.auug.org.au>
In-Reply-To: <CAMuHMdWwBP6mmWMF3QAvjqo7HQQAB8KZ2QUW5kHZ6iHMMLNYuQ@mail.gmail.com>
References: <CAMuHMdWwBP6mmWMF3QAvjqo7HQQAB8KZ2QUW5kHZ6iHMMLNYuQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/POndC8eY0kLj3AUMuPlwPay"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/POndC8eY0kLj3AUMuPlwPay
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Wed, 4 Jun 2014 10:21:06 +0200 Geert Uytterhoeven <geert@linux-m68k.org>=
 wrote:
>
> kisskb.ellerman.id.au/kisskb/head/page1/ doesn't seem to be updated
> anymore? E.g. v3.15-rc8 is missing.

Yeah, our machine room suffered an airconditioning failure and our
build host is one of the machines that we can't afford to run at the
moment.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/POndC8eY0kLj3AUMuPlwPay
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjtihAAoJEMDTa8Ir7ZwVjBEP/2fOkt4vkawzcKmLBlaf0bXT
Caih8fI8aGtLDmluEHycPSvc6rHDD340ohrEtGDzcLY7WrhM71T6WV8HQljuwRhO
JsiPEoRA8NB7y3Qp5Cp8ku6iUDYaxQEgcrWyl0Y7BD/QZxYABQ7/I7ODPE2unrqw
oa8mAozWqEr5pVzClPgFXU0dxvKdCxHrS0s4HcMllCILJAbM3octMExsjJbMRxGZ
hgPpceBLDmrn/7R0vkk0U3r20tP/nBd99YWP/8CtcDwULW2anTvi3l2JtIE4T4OC
U918CznVcawIGZ9mcVcVdqZnv3KxjDmS9/WocNhF4NCqqlQi/myGDaTvUSnKODq9
bDqhebk13wnBPIsHD7cePMZWbS8itkim6jxE6tk7N8eREAaLZC23WImwnHX3Z6cc
OMLL/Ya5naP5KO8UfY8f9hDOHcqMvKbgs9tZLB7V2qopP6FfDo8nkrxX8qDlg1tc
W2BbxemzTBD1SC4X2gdP6QFoVLrWb80KK0dHSVHwrvb4yR73lx+FH+bHD/NbgTSo
ArnCGusHO6d7lB4HBIxRTCDy8N3Hu0PfZ2RdoirDdySWks84WG8Ab0HNSp2jexDJ
W/yJZRe96sVlXa1bcMx7yJZj+jYhNmeuLMdCTaCughZBTVhzPBp59yq9dRj6Um4V
ZVOuARbXA++LWUOlkM1G
=Y8Iu
-----END PGP SIGNATURE-----

--Sig_/POndC8eY0kLj3AUMuPlwPay--
