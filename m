Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab3FAIcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 04:32:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54814 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3FAIcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 04:32:35 -0400
Message-ID: <51A9B185.9030107@pengutronix.de>
Date: Sat, 01 Jun 2013 10:32:05 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Shawn Guo <shawn.guo@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        U Bhaskar-B22300 <B22300@freescale.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] can: flexcan: remove HAVE_CAN_FLEXCAN Kconfig symbol
References: <1368781157-4646-1-git-send-email-mkl@pengutronix.de>  <20130517090949.GI8607@S2101-09.ap.freescale.net>  <519A4A00.8000109@pengutronix.de> <1370043630.3928.166.camel@pasglop>
In-Reply-To: <1370043630.3928.166.camel@pasglop>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2NQWWNTOEEGEOGHGFBKJG"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2NQWWNTOEEGEOGHGFBKJG
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 06/01/2013 01:40 AM, Benjamin Herrenschmidt wrote:
> On Mon, 2013-05-20 at 18:06 +0200, Marc Kleine-Budde wrote:
>> On 05/17/2013 11:09 AM, Shawn Guo wrote:
>>> On Fri, May 17, 2013 at 10:59:17AM +0200, Marc Kleine-Budde wrote:
>>>> This patch removes the Kconfig symbol HAVE_CAN_FLEXCAN from arch/{ar=
m,powerpc}
>>>> and allowing compilation unconditionally on all arm and powerpc plat=
forms.
>>>>
>>>> This brings a bigger compile time coverage and removes the following=
 dependency
>>>> warning found by Arnd Bergmann:
>>>>
>>>>     warning: (SOC_IMX28 && SOC_IMX25 && SOC_IMX35 && IMX_HAVE_PLATFO=
RM_FLEXCAN &&
>>>>         SOC_IMX53 && SOC_IMX6Q) selects HAVE_CAN_FLEXCAN
>>>>     which has unmet direct dependencies (NET && CAN && CAN_DEV)
>>>>
>>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>>> Cc: Shawn Guo <shawn.guo@linaro.org>
>>>
>>> Acked-by: Shawn Guo <shawn.guo@linaro.org>
>>
>> Thanks.
>>
>> An Acked-by by the powerpc people would be fine. However, if nobody
>> doesn't object, I'm sending this patch via linux-can and net-next upst=
ream.
>=20
> Sorry, missed it, if it's still out there, add my
>=20
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Thanks,

Marc


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2NQWWNTOEEGEOGHGFBKJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGpsYkACgkQjTAFq1RaXHNZjACfRw3YJ9tBYhgOf2denmTVtsfC
Ex4AoIUUJu5mxWre69cSk+SqByW5KXNE
=aWez
-----END PGP SIGNATURE-----

------enig2NQWWNTOEEGEOGHGFBKJG--
