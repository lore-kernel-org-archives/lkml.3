Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3I3NXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:23:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50887 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab3I3NXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:23:35 -0400
Message-ID: <52497B4A.2020409@pengutronix.de>
Date: Mon, 30 Sep 2013 15:23:22 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 01/21] drivers: remove unnecessary prom.h includes
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com> <1380221456-11192-2-git-send-email-robherring2@gmail.com> <52492E4F.2020701@pengutronix.de> <52497A6E.5010908@gmail.com>
In-Reply-To: <52497A6E.5010908@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7V7bqdqEoSOLFc2OvX8r5N8QO3a5281aj"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7V7bqdqEoSOLFc2OvX8r5N8QO3a5281aj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/30/2013 03:19 PM, Rob Herring wrote:
> On 09/30/2013 02:54 AM, Marc Kleine-Budde wrote:
>> On 09/26/2013 08:50 PM, Rob Herring wrote:
>>> From: Rob Herring <rob.herring@calxeda.com>
>>>
>>> Remove unnecessary prom.h includes in preparation to remove implicit
>>> includes of prom.h.
>>>
>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>> Cc: Wolfgang Grandegger <wg@grandegger.com>
>>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>>> Cc: linux-can@vger.kernel.org
>>> Cc: netdev@vger.kernel.org
>>
>> Applied to linux-can-next/testing, it will be included in my next pull=

>> request to David Miller.
>=20
> Please don't apply this. The whole series needs to be applied together.=

> This patch is a dependency for the rest of the series.

Okay, then add my Acked-by to this patch.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--7V7bqdqEoSOLFc2OvX8r5N8QO3a5281aj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlJJe0oACgkQjTAFq1RaXHN9pwCfVsN6WRkRPfEbHYiqSYOYWZ8O
CD4An03DCJm2LZtQwWmB4BQkTodid83l
=S39I
-----END PGP SIGNATURE-----

--7V7bqdqEoSOLFc2OvX8r5N8QO3a5281aj--
