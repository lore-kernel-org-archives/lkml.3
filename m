Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3CLORW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:17:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34074 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3CLORV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:17:21 -0400
Message-ID: <513F38DF.5040404@pengutronix.de>
Date: Tue, 12 Mar 2013 15:17:03 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, tony@atomide.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/8] usb: phy: nop: Add some parameters to platform data
References: <1363087466-32444-1-git-send-email-rogerq@ti.com> <1363087466-32444-2-git-send-email-rogerq@ti.com> <513F177D.40500@pengutronix.de> <513F37DD.9030301@ti.com>
In-Reply-To: <513F37DD.9030301@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VKTUQOOAFXLDGOKPQWDE"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VKTUQOOAFXLDGOKPQWDE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/12/2013 03:12 PM, Roger Quadros wrote:
> On 03/12/2013 01:54 PM, Marc Kleine-Budde wrote:
>> On 03/12/2013 12:24 PM, Roger Quadros wrote:
>>> Add clk_rate parameter to platform data. If supplied, the
>>> NOP phy driver will program the clock to that rate during probe.
>>>
>>> Also add 2 flags, needs_vcc and needs_reset.
>>> If the flag is set and the regulator couldn't be found
>>> then the driver will bail out with -EPROBE_DEFER.
>>
>> Is there a platform which fills out pdata.needs_vcc and
>> pdata.needs_reset? IMHO it makes no sense to add features for the non =
DT
>> case, if there isn't any user for it.
>>
>=20
> There can be a user in the non DT case as well. Consider the following =
example:

I'm just saying, let the implementation up to a real user for the non DT
case. Beagleboard is ARM and there's no point of implementing non DT
fall backs for ARM, IMHO.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2VKTUQOOAFXLDGOKPQWDE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlE/OOcACgkQjTAFq1RaXHMCIQCfQ0QryTHifYl3WtDEDhkyFcbR
QmcAn3Idz6HRgHj6+COKo/sBk7o1hOP/
=LXqL
-----END PGP SIGNATURE-----

------enig2VKTUQOOAFXLDGOKPQWDE--
