Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbaH3ILI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 04:11:08 -0400
Received: from libra.uberspace.de ([95.143.172.171]:37253 "EHLO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaH3ILD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 04:11:03 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Aug 2014 04:11:02 EDT
Date: Sat, 30 Aug 2014 10:04:12 +0200
From: Matthias Beyer <mail@beyermatthias.de>
To: Andrew Plummer <plummer574@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: LeakyBucket: format kernel-docs
Message-ID: <20140830080412.GA4509@fu.3gs>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1409345416-16408-1-git-send-email-plummer574@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <1409345416-16408-1-git-send-email-plummer574@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29-08-2014 21:50:16, Andrew Plummer wrote:
> Remove insignificant spaces before tabs in comments.
>=20
> Signed-off-by: Andrew Plummer <plummer574@gmail.com>
> ---
>  drivers/staging/bcm/LeakyBucket.c | 81 ++++++++++++++++-----------------=
------
>  1 file changed, 33 insertions(+), 48 deletions(-)
>=20
> diff --git a/drivers/staging/bcm/LeakyBucket.c b/drivers/staging/bcm/Leak=
yBucket.c
> index 8c4030d..d6b55f9 100644
> --- a/drivers/staging/bcm/LeakyBucket.c
> +++ b/drivers/staging/bcm/LeakyBucket.c
> @@ -1,20 +1,16 @@
>  /**********************************************************************
> -* 			LEAKYBUCKET.C
> +*			LEAKYBUCKET.C
>  *	This file contains the routines related to Leaky Bucket Algorithm.
>  ***********************************************************************/
>  #include "headers.h"
> =20
> -/*********************************************************************
> -* Function    - UpdateTokenCount()
> -*
> -* Description - This function calculates the token count for each
> -*				channel and updates the same in Adapter strucuture.
> -*
> -* Parameters  - Adapter: Pointer to the Adapter structure.
> -*
> -* Returns     - None
> -**********************************************************************/
> -
> +/**
> + * UpdateTokenCount() - Calculates the token count for each channel
> + * and updates the same in Adapter structure
> + * @Adapter:	Pointer to the Adapter structure.
> + *
> + * Return: None
> + */
>  static VOID UpdateTokenCount(register struct bcm_mini_adapter *Adapter)
>  {
>  	ULONG liCurrentTime;
> @@ -59,20 +55,16 @@ static VOID UpdateTokenCount(register struct bcm_mini=
_adapter *Adapter)
>  }
> =20
> =20
> -/*********************************************************************
> -* Function    - IsPacketAllowedForFlow()
> -*
> -* Description - This function checks whether the given packet from the
> -*				specified queue can be allowed for transmission by
> -*				checking the token count.
> -*
> -* Parameters  - Adapter	      :	Pointer to the Adpater structure.
> -* 			  - iQIndex	      :	The queue Identifier.
> -* 			  - ulPacketLength:	Number of bytes to be transmitted.
> -*
> -* Returns     - The number of bytes allowed for transmission.
> -*
> -***********************************************************************/
> +/**
> + * IsPacketAllowedForFlow() - This function checks whether the given
> + * packet from the specified queue can be allowed for transmission by
> + * checking the token count.
> + * @Adapter:		Pointer to the Adpater structure.
> + * @iQIndex:		The queue Identifier.
> + * @ulPacketLength:	Number of bytes to be transmitted.
> + *
> + * Returns: The number of bytes allowed for transmission.
> + */
>  static ULONG GetSFTokenCount(struct bcm_mini_adapter *Adapter, struct bc=
m_packet_info *psSF)
>  {
>  	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL,
> @@ -256,18 +248,14 @@ static void send_control_packet(struct bcm_mini_ada=
pter *ad,
>  	}
>  }
> =20
> -/************************************************************************
> -* Function    - CheckAndSendPacketFromIndex()
> -*
> -* Description - This function dequeues the data/control packet from the
> -*				specified queue for transmission.
> -*
> -* Parameters  - Adapter : Pointer to the driver control structure.
> -* 			  - iQIndex : The queue Identifier.
> -*
> -* Returns     - None.
> -*
> -************************************************************************=
****/
> +/**
> + * CheckAndSendPacketFromIndex() - This function dequeues the
> + * data/control packet from the specified queue for transmission.
> + * @Adapter:	Pointer to the driver control structure.
> + * @iQIndex:	The queue Identifier.
> + *
> + * Returns: None.
> + */
>  static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter,
>  					struct bcm_packet_info *psSF)
>  {
> @@ -284,16 +272,13 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_=
mini_adapter *Adapter,
>  }
> =20
> =20
> -/*******************************************************************
> -* Function    - transmit_packets()
> -*
> -* Description - This function transmits the packets from different
> -*				queues, if free descriptors are available on target.
> -*
> -* Parameters  - Adapter:  Pointer to the Adapter structure.
> -*
> -* Returns     - None.
> -********************************************************************/
> +/**
> + * transmit_packets() - This function transmits the packets from
> + * different queues, if free descriptors are available on target.
> + * @Adapter:	Pointer to the Adapter structure.
> + *
> + * Returns: None.
> + */
>  VOID transmit_packets(struct bcm_mini_adapter *Adapter)
>  {
>  	UINT uiPrevTotalCount =3D 0;
> --=20
> 1.9.1
>=20
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

Reviewed-by: Matthias Beyer <mail@beyermatthias.de>

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBAgAGBQJUAYV8AAoJEJi+S08gyg+Ux1IP93/37gkSIWNBQlFsEMN+txtv
37Yqf24KNlziQMgMY0FTI8JaUibC8MvnRqmAyQHdnXmMhuFpru122kWi6ktpLLCI
6dwevsht/q5Mtb+2imaDlGrO9XQWztr80mm11N6DsautFN2XNYDqL7IrMNG5+KjV
TSKLj3oQfrXyFC7KLtonl2zz4mGTzxAJp4XLQPh0NeTHcEmJ1Zfinm83UAhbv8Wq
Y2MUE0DHi6+K/wHgA9zPo4h5GXrsycAhB3/InWK34vNyl1Kmc1C9DG0MVaic+Gok
frtDCm0uHolfhoag4TUJXslJRJm1ETsUhNuKMtgHouG0+A8DmtOIJtvHTBs9R9Xz
7plmoPqoDBmIWa2GVhKb0gjJpEJHjTP+g/q/lU22JVkGTFBWVat2h7+RzvMEkmFp
URPzC19OIslohBz4q8j+AielSfpOeD7wH0P4cjH87iWdWCQEhvu3WRrfRBI8wZT0
wJw6usjSS9vkIL4h8ceQBqxjmaqym3rhg9E6+WNqy3SrZnRRwkvi2Jq8FA0LCW34
hXr1e83WrPezATztL3+xP2ADXvTRXH5t7cT+qxICi/62utz4iB2nObIe37pojJRK
PXJHdD/IVwaRygo0WPXDWTHhTrjFZ1/Xu+rPtQhuqFm/5fELbU3I+tuJQW+46YHB
TZk9TK5o1KDLvt4sLjw=
=DryE
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
