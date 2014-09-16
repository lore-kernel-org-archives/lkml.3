Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaIPJGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:06:09 -0400
Received: from libra.uberspace.de ([95.143.172.171]:50251 "EHLO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaIPJGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:06:06 -0400
Date: Tue, 16 Sep 2014 11:01:41 +0200
From: Matthias Beyer <mail@beyermatthias.de>
To: Martin Kelly <martin@martingkelly.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        klmckinney1@gmail.com, linux-kernel@vger.kernel.org,
        Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH] Staging/bcm: Fix whitespace/comments in Ioctl.h
Message-ID: <20140916090141.GE8562@fu>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1410840975-24388-1-git-send-email-martin@martingkelly.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <1410840975-24388-1-git-send-email-martin@martingkelly.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Matthias Beyer <mail@beyermatthias.de>

On 15-09-2014 21:16:15, Martin Kelly wrote:
> Cleanup whitespace and comments in Ioctl.h in a few ways:
> - > 80 character cleanup
> - Comment clarification
> - More consistent vertical alignment
>=20
> Signed-off-by: Martin Kelly <martkell@amazon.com>
> ---
>  drivers/staging/bcm/Ioctl.h | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/staging/bcm/Ioctl.h b/drivers/staging/bcm/Ioctl.h
> index 797f862..fa5f867 100644
> --- a/drivers/staging/bcm/Ioctl.h
> +++ b/drivers/staging/bcm/Ioctl.h
> @@ -87,9 +87,9 @@ struct bcm_user_thread_req {
>  #define IOCTL_BCM_FLASH2X_SECTION_WRITE		_IOW(BCM_IOCTL, 0x866, int)
>  #define IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP	_IOR(BCM_IOCTL, 0x867, int)
>  #define IOCTL_BCM_SET_ACTIVE_SECTION		_IOW(BCM_IOCTL, 0x868, int)
> -#define	IOCTL_BCM_IDENTIFY_ACTIVE_SECTION	_IO(BCM_IOCTL, 0x869)
> +#define IOCTL_BCM_IDENTIFY_ACTIVE_SECTION	_IO(BCM_IOCTL, 0x869)
>  #define IOCTL_BCM_COPY_SECTION			_IOW(BCM_IOCTL, 0x870, int)
> -#define	IOCTL_BCM_GET_FLASH_CS_INFO		_IOR(BCM_IOCTL, 0x871, int)
> +#define IOCTL_BCM_GET_FLASH_CS_INFO		_IOR(BCM_IOCTL, 0x871, int)
>  #define IOCTL_BCM_SELECT_DSD			_IOW(BCM_IOCTL, 0x872, int)
>  #define IOCTL_BCM_NVM_RAW_READ			_IOR(BCM_IOCTL, 0x875, int)
>  #define IOCTL_BCM_CNTRLMSG_MASK			_IOW(BCM_IOCTL, 0x874, int)
> @@ -130,7 +130,7 @@ struct bcm_bulk_wrm_buffer {
>  };
> =20
>  enum bcm_flash2x_section_val {
> -	NO_SECTION_VAL =3D 0, /* no section is chosen when absolute offset is g=
iven for RD/WR */
> +	NO_SECTION_VAL =3D 0, /* no section chosen when absolute offset is give=
n for RD/WR */
>  	ISO_IMAGE1,
>  	ISO_IMAGE2,
>  	DSD0,
> @@ -152,11 +152,11 @@ enum bcm_flash2x_section_val {
>   * Structure used for READ/WRITE Flash Map2.x
>   */
>  struct bcm_flash2x_readwrite {
> -	enum bcm_flash2x_section_val Section; /* which section has to be read/w=
ritten */
> -	u32 offset;	     /* Offset within Section. */
> -	u32 numOfBytes;	     /* NOB from the offset */
> +	enum bcm_flash2x_section_val Section; /* section to be read/written */
> +	u32 offset; /* offset within section. */
> +	u32 numOfBytes; /* number of bytes from the offset */
>  	u32 bVerify;
> -	void __user *pDataBuff;	     /* Buffer for reading/writing */
> +	void __user *pDataBuff; /* buffer for reading/writing */
>  };
> =20
>  /*
> @@ -207,20 +207,20 @@ struct bcm_time_elapsed {
>  };
> =20
>  enum {
> -	WIMAX_IDX =3D 0,  /* To access WiMAX chip GPIO's for GPIO_MULTI_INFO or=
 GPIO_MULTI_MODE */
> -	HOST_IDX,	/* To access Host chip GPIO's for GPIO_MULTI_INFO or GPIO_MUL=
TI_MODE */
> +	WIMAX_IDX =3D 0, /* To access WiMAX chip GPIO's for GPIO_MULTI_INFO or =
GPIO_MULTI_MODE */
> +	HOST_IDX, /* To access Host chip GPIO's for GPIO_MULTI_INFO or GPIO_MUL=
TI_MODE */
>  	MAX_IDX
>  };
> =20
>  struct bcm_gpio_multi_info {
>  	unsigned int uiGPIOCommand; /* 1 for set and 0 for get */
> -	unsigned int uiGPIOMask;    /* set the correspondig bit to 1 to access =
GPIO */
> -	unsigned int uiGPIOValue;   /* 0 or 1; value to be set when command is =
1. */
> +	unsigned int uiGPIOMask; /* set the corresponding bit to 1 to access GP=
IO */
> +	unsigned int uiGPIOValue; /* 0 or 1; value to be set when command is 1.=
 */
>  } __packed;
> =20
>  struct bcm_gpio_multi_mode {
> -	unsigned int uiGPIOMode;    /* 1 for OUT mode, 0 for IN mode */
> -	unsigned int uiGPIOMask;    /* GPIO mask to set mode */
> +	unsigned int uiGPIOMode; /* 1 for OUT mode, 0 for IN mode */
> +	unsigned int uiGPIOMask; /* GPIO mask to set mode */
>  } __packed;
> =20
>  #endif
> --=20
> 2.1.0
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

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUF/x1AAoJEJi+S08gyg+URxUP/Aybn8y7I/21XIvpY6Tx9K2G
HZIk8PC0kqfduqptkr62xCBXhHXJrys0h3MyM8tRNs/rt5ffsnlfOWWLuIAhfn7o
re5tg6r258FNuUFG1JOlTA94CuYNOQ0A4BpaSVkT2vTTTYrXRsDWlrvFlT7S0xv0
SWJiQiazQTcuIcOREz0dDkzfJbnx8kFnU7ngZvRUEto5Ai4et0JiJrgTEELz1e3n
SSLF80Nnyl8V3uw+uw8G0X61jHt1V/3d2Ox7zuiUg8HUM2TCqhYOmQ0Q0W1s2rUK
DnyC6vWfVCtkrQOva0iiEoLn0dnTxliIiezuKUiMm9QgJOk8jFfYkVz4kieSZRAz
xlYy/wmbZzTApzEKL3ETxWZlfRBPT5MZUqjDg/ErhbszylNB13FQiWuflM/3fL9W
XMWlLnVczqbP+K+tSlKL9W8DBrdBnwNr/D0Hp/HbdoPHBHVgvV0MHdD1gwVWgLcJ
uLQBYEcfSg2qpDl/zP8pTqaCAE++BYTiHpxz8q9h7z70fTBNM9UjSilSNThndZ1A
1dwnfxoxxRp0JhbcxMSIvpIXrvJIv5UsymTQk4nSNtO9X1mpDzX3inoT7f2UDCcp
bknADRAD0M1J5YQdex8EqBfP1lnD2t8ZwIv78fOJnhJjEvmhgJpUuzynx8hAh2lS
rTc0Z+N7tZeAnFXqDOoV
=Vlka
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
