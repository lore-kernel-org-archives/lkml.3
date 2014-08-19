Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbaHSSm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:42:56 -0400
Received: from ozlabs.org ([103.22.144.67]:58264 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbaHSSmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:42:55 -0400
Date: Wed, 20 Aug 2014 04:42:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 18
Message-ID: <20140820044244.7e58b9f3@canb.auug.org.au>
In-Reply-To: <20140819152426.GA19665@roeck-us.net>
References: <20140818133259.3d1182fd@canb.auug.org.au>
	<20140819152426.GA19665@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/G5rjfs3RlvrBIW00zLx65/m"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/G5rjfs3RlvrBIW00zLx65/m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Tue, 19 Aug 2014 08:24:26 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> Something in this tree appears to be completely broken. All my qemu tests
> fail with it. It _seems_ that the problem is related to either mount rela=
ted
> or to locking related code. Someone might want to have a look. Given that
> all of my runtime tests crash, it is probably easy to reproduce by just
> trying to load an image on an x86 system.

Hopefully you are seeing what will be fixed by Hugh Dickins' patch in
today's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/G5rjfs3RlvrBIW00zLx65/m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT85qpAAoJEMDTa8Ir7ZwVkuYP/iBg+eZtXzqibU5eJ2WNwEQ0
ztAkG3kqm20zvnx7/TaMN86pYzht5lvlo+MIC+zRqX2PkD251QUvPieiMQ8vqQWk
oD5ezgfnkBrQghbKRL3wYLOhka5xtZcARJPwSoyHoHVn/owuMYsR5Qv2Cg9PkDce
zpHa9gwbgvmsMLmo4vf9RD9c8eVtJ5loinjT1dIZxyUs/dswSanjJsLirsA+Z+a7
I9xWcPG39w2Mtjp8VOlQTjsyYZAc2FmE50r8ght/DvEeheaIOFIkSNIFE2QIMDEG
fOo/1MlX3giRdUdfoc/ZZ7/+XzBRW8MzKuZ47fzekUvmkT8Vsce8Ez25R/K/AKIl
5E85kRX5JM+9JBEO+Qcyo1dIFraquYr/U4TUx62L88xkF9QzDyuhSKZYAVQaylH2
RQPB4/I9JX3JWFXzYbX3mR799rtkGlBICW0qKJPSijr2Y6f9Vsbcx8JF6kZVH8yA
GENSrMf2fAcDjGNzMSLfMD9r+lkyQwWdGLZho00erXJDux/sJvsXQgsISw1NvWV9
6LdZwY5YIwrxTigMAJyRqBxKACKBmZlFlexH/29wJD9xAzZZSyLqr7z45hcIL4Uv
bakAW4zBm/ushbwOhbOz1EPsLD2hGZQTHGHk1rR7jSTXvgWxRWrCmllLjnsqUO1S
At6yu/+f9E2lxAuYPPDT
=myqo
-----END PGP SIGNATURE-----

--Sig_/G5rjfs3RlvrBIW00zLx65/m--
