Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3EHHWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 03:22:54 -0400
Received: from mail.gw90.de ([188.40.100.199]:58080 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab3EHHWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 03:22:53 -0400
Message-ID: <1367997761.10764.23.camel@mattotaupa>
Subject: Re: [PATCH] drm: refactor call to request_module
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Wed, 08 May 2013 09:22:41 +0200
In-Reply-To: <20130507193216.GA2214@www.outflux.net>
References: <20130507193216.GA2214@www.outflux.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-0K5pDc5deo81mXd5SDgd"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0K5pDc5deo81mXd5SDgd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 07.05.2013, 12:32 -0700 schrieb Kees Cook:
> This reduces the size of the stack frame when calling request_module().
> Performing the sprintf before the call is not needed.

Good fine. Do you have any hard numbers for the record?

Did you find this just by reading the code or are there any problems
with stack sizes on some systems?

(This patch would be good alone for decreasing the number of code
lines. ;-))

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/gpu/drm/drm_encoder_slave.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>


Thanks,

Paul

--=-0K5pDc5deo81mXd5SDgd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlGJ/UEACgkQPX1aK2wOHVhrDgCdGOZleXKXZIjkZwrg1AkbhDs4
OcQAnjrR4UIVMMXT8kbW4O40l9h+g8DA
=iv7v
-----END PGP SIGNATURE-----

--=-0K5pDc5deo81mXd5SDgd--

