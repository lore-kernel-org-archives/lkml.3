Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3AOUl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:41:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36613 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab3AOUl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:41:26 -0500
Message-ID: <50F5BEEF.1060208@pengutronix.de>
Date: Tue, 15 Jan 2013 21:41:19 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: linux-can@vger.kernel.org, Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Bernd Krumboeck <b.krumboeck@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/10] tx/rx LED trigger support
References: <1355853064-18144-1-git-send-email-fabio.baltieri@gmail.com>
In-Reply-To: <1355853064-18144-1-git-send-email-fabio.baltieri@gmail.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2LCUQVEMSRQTINGWUHQAT"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2LCUQVEMSRQTINGWUHQAT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/18/2012 06:50 PM, Fabio Baltieri wrote:
> Hi All,
>=20
> this is the v2 of the canbus LED series.
>=20
> Changes from v1:
> - moved all framework patches before driver ones
> - added usb_8dev driver patch to the series (based on v9 version)
> - added by S-o-b to all patches in this series
>=20
> The last usb_8dev patch requires Bernd's patch.  A part from this the
> set applies cleanly on current mainline.

Applied 1-9, skipping usb_8dev, as the driver has some problems with
unplugging under load.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2LCUQVEMSRQTINGWUHQAT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlD1vu8ACgkQjTAFq1RaXHPzyACeICQA5MiteN9Enx78oRLP0l/Z
yicAn1aDSyJ70ItR3j+sC2g2PKULdCo7
=QU/L
-----END PGP SIGNATURE-----

------enig2LCUQVEMSRQTINGWUHQAT--
