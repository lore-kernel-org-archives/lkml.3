Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaHaIjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:39:24 -0400
Received: from libra.uberspace.de ([95.143.172.171]:40237 "EHLO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaHaIjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:39:19 -0400
Date: Sun, 31 Aug 2014 10:39:09 +0200
From: Matthias Beyer <mail@beyermatthias.de>
To: Anh Le <anhlq2110@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: fixed a comment coding style issue
Message-ID: <20140831083909.GB4509@fu.3gs>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1409462690-8620-1-git-send-email-anhlq2110@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <1409462690-8620-1-git-send-email-anhlq2110@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Matthias Beyer <mail@beyermatthias.de>

On 31-08-2014 12:24:50, Anh Le wrote:
> Fixed a C99 comment issue in InterfaceMisc.h.
>=20
> Signed-off-by: Anh Le <anhlq2110@gmail.com>
> ---
>  drivers/staging/bcm/InterfaceMisc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/staging/bcm/InterfaceMisc.h b/drivers/staging/bcm/In=
terfaceMisc.h
> index efb6860..0e5e38b 100644
> --- a/drivers/staging/bcm/InterfaceMisc.h
> +++ b/drivers/staging/bcm/InterfaceMisc.h
> @@ -39,4 +39,4 @@ VOID Bcm_kill_all_URBs(struct bcm_interface_adapter *ps=
IntfAdapter);
> =20
>  #define DISABLE_USB_ZERO_LEN_INT 0x0F011878
> =20
> -#endif // __INTERFACE_MISC_H
> +#endif /* __INTERFACE_MISC_H */
> --=20
> 1.8.5.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAt8tAAoJEJi+S08gyg+UZJcP/iqUc0w11+Cf+4lF+7vxI7hQ
KGtiS3D4HZETZe9+o/3z8i1l5j5OP1lrnbLsUkqdV51Y4mWW6ng+1AXU8CjUY4H4
ps9h0Ot7hXWq/gNtg45kNsuKaSkOb1T+5RiqMi3R7Wx3xFLj/3XD7mbVA1x6vU2y
vS4ayll+RVovQph4qAiOpObQMydNxgB+/EZCUTzkrKDUBfCwGfnHUXQe50vwIXo0
VVaw+zlUOvDuOqBRnAyoBrZ6QCKPq5eiS94rPTCuts6HtrrTz7xfz8PzwXdh1kxB
e5JVDUnhqVuRiBuDF/0tMDeeazzYSrARPVuRo7XtyeFWuR03jvaejB8w8c+Dixqv
l5tavqQS/THeMsqI2t3NhD5gpMD99z33yv71OJB5hHIw4f+8HJs9dfUfjN/MrQ3S
EX4zgp3fqXWhlwJLmhuIwr1Y+xCA+sPVBlXVTupRfYDbbK0QbTox1txpUxUwf92q
rH01F97VjcYYBcE2bb9nW1Q9Fh8mPvSxTfWc1QWgJk+kDnI16Hp1CUHSR5QtkFDn
X90NNrWJoz+wAmUp5YHhAoHdNyBjlo6HaTmGDbmGFmHElz3P0HjQL554noauuaGj
8c1mRVbfHYNYPLw8UPmjgJb4WA3uHR04IWy6YXKmuG0zrGSE1BCm5VfleqhXTUZT
r0jX4YyBvblD7IrO1525
=UGpQ
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
