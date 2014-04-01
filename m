Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaDAV3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:29:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58593 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaDAV3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:29:48 -0400
Message-ID: <533B2FC3.80300@pengutronix.de>
Date: Tue, 01 Apr 2014 23:29:39 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [patch 00/12] can: c_can: Fix a series of serious bugs and improve
 the performance
References: <20140318171007.528610837@linutronix.de> <alpine.DEB.2.02.1403312355280.14882@ionos.tec.linutronix.de> <533A742F.4090703@pengutronix.de>
In-Reply-To: <533A742F.4090703@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IkOFxdI3osvLMbH3K2bLQJlFGe8wV0pUE"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IkOFxdI3osvLMbH3K2bLQJlFGe8wV0pUE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/01/2014 10:09 AM, Marc Kleine-Budde wrote:
>> What's the state of this series?
>=20
> I'll apply your patches today.

I've applied all patches of this series (with some with minor tweaks of
the subject and/or commit message) to the can tree and skipped the
non-series "can: c_can: Reduce interrupt load by 50%".

Thanks.
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--IkOFxdI3osvLMbH3K2bLQJlFGe8wV0pUE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlM7L8MACgkQjTAFq1RaXHPEqACfbQ6/53LYb7yI29Xox0VAdWn/
I84An3QqJYNoK3q0ttMrHoGPYlA7uKsq
=phoy
-----END PGP SIGNATURE-----

--IkOFxdI3osvLMbH3K2bLQJlFGe8wV0pUE--
