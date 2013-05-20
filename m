Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3ETQG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:06:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43968 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab3ETQGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:06:55 -0400
Message-ID: <519A4A00.8000109@pengutronix.de>
Date: Mon, 20 May 2013 18:06:24 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        Kumar Gala <galak@kernel.crashing.org>,
        U Bhaskar-B22300 <B22300@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] can: flexcan: remove HAVE_CAN_FLEXCAN Kconfig symbol
References: <1368781157-4646-1-git-send-email-mkl@pengutronix.de> <20130517090949.GI8607@S2101-09.ap.freescale.net>
In-Reply-To: <20130517090949.GI8607@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2LNJKRDFSKBTBRHDHOKQV"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2LNJKRDFSKBTBRHDHOKQV
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 05/17/2013 11:09 AM, Shawn Guo wrote:
> On Fri, May 17, 2013 at 10:59:17AM +0200, Marc Kleine-Budde wrote:
>> This patch removes the Kconfig symbol HAVE_CAN_FLEXCAN from arch/{arm,=
powerpc}
>> and allowing compilation unconditionally on all arm and powerpc platfo=
rms.
>>
>> This brings a bigger compile time coverage and removes the following d=
ependency
>> warning found by Arnd Bergmann:
>>
>>     warning: (SOC_IMX28 && SOC_IMX25 && SOC_IMX35 && IMX_HAVE_PLATFORM=
_FLEXCAN &&
>>         SOC_IMX53 && SOC_IMX6Q) selects HAVE_CAN_FLEXCAN
>>     which has unmet direct dependencies (NET && CAN && CAN_DEV)
>>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Shawn Guo <shawn.guo@linaro.org>
>=20
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

Thanks.

An Acked-by by the powerpc people would be fine. However, if nobody
doesn't object, I'm sending this patch via linux-can and net-next upstrea=
m.

regards,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2LNJKRDFSKBTBRHDHOKQV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGaSgAACgkQjTAFq1RaXHPbDwCgk97qatZ4r84KYI1L6zCJRWrf
ECcAn0ydqy6yQnEKnxiTWViJ/p+wR2Wt
=J2Zm
-----END PGP SIGNATURE-----

------enig2LNJKRDFSKBTBRHDHOKQV--
