Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbaGPBJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:09:01 -0400
Received: from ozlabs.org ([103.22.144.67]:56954 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbaGPBJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:09:00 -0400
Date: Wed, 16 Jul 2014 11:08:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 3.15 14/84] serial: imx: Fix build breakage
Message-ID: <20140716110853.770d3839@canb.auug.org.au>
In-Reply-To: <20140716010759.GB19997@kroah.com>
References: <20140715231713.193785557@linuxfoundation.org>
	<20140715231713.621762682@linuxfoundation.org>
	<20140716102414.337e58ce@canb.auug.org.au>
	<20140716004202.GB6908@kroah.com>
	<20140716105656.539105f1@canb.auug.org.au>
	<20140716010759.GB19997@kroah.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/YLhZINCwP7dwjjV3ZSwJFcP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YLhZINCwP7dwjjV3ZSwJFcP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 15 Jul 2014 18:07:59 -0700 Greg Kroah-Hartman <gregkh@linuxfoundati=
on.org> wrote:
>
> No I do not, I much prefer to keep the patches identical to what is in
> Linus's tree if at all possible.  It saves time overall, so you can
> track things better, instead of having to deal with "merged" patches,
> which can get messy very quickly.

OK, make sense, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/YLhZINCwP7dwjjV3ZSwJFcP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxdCpAAoJEMDTa8Ir7ZwVsFkQAIjnSkv1pYH5yxSz8XkuD+AK
rlagAJ8FxzrMqAkiUnS25a8F64ikDUM4/fX0QXeTQP+x4JA8E4ptEFlHSXHae1xw
z8JLoVQFEvarU88ojnRyZ3l+As5SgqMdvjafqR681ntnJr17ttqtSJNsOsXxJJ0t
xjqQkokfd9hwFj4uMTqgtZx6cjnsYYtpwKObgWS6mKn/rQ3EsM0a4GnZySlQojAz
QVawi2UwTxRWc/UlQaJAKu6qYT3U3ncVtlFkbU97+T0tk9GoumuhCVzjEkko6M7T
H/mt/1PYohcq2ET4FDo/LQmYG3Gue9XyGG1g+KOFgiGQkTHJh14feAGLJZOr9nH+
fc4n6BuHnptpcXklkgL0PTWo4z974aoZY84fpISUP2vZCXTlOqQRT6fs/3IXB8W2
uOXxPcEvyYQ6wL9SambodLQLljRrgMFaxbF9nt817+2KzLIm+hCpaTUna25f/wyK
Y5S68USgBnIsx7vIT5yKGr8IvU5BJQreypAFsFayzzxzcjRMO1XkK1IL7TvbcOkv
Bg+qEqonbyzNG5FpD6e30vicdvnReS3xvx6Sw9/C+iFYyIuYR79n5c2J/GhmS6aG
+FVboA8sFWHmJR/CufXcwD2+Q3sUAVnrOjpzcQOBxGViiaKNaH4DTqJrBsL8sNd9
XzaXQmVR7ogxP2PR96r9
=ft/H
-----END PGP SIGNATURE-----

--Sig_/YLhZINCwP7dwjjV3ZSwJFcP--
