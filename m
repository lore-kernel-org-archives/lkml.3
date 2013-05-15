Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab3EOLpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 07:45:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39475 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab3EOLpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 07:45:18 -0400
Message-ID: <51937543.1050209@pengutronix.de>
Date: Wed, 15 May 2013 13:45:07 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Imre Deak <imre.deak@intel.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 07/11] net/peak_pcmcia: take msecs_to_jiffies_min into
 use
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com> <1368188011-23661-7-git-send-email-imre.deak@intel.com> <5193518C.3040706@pengutronix.de>
In-Reply-To: <5193518C.3040706@pengutronix.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2TJUVTAIVCKXTNJFHUUVE"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2TJUVTAIVCKXTNJFHUUVE
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 05/15/2013 11:12 AM, Marc Kleine-Budde wrote:
> On 05/10/2013 02:13 PM, Imre Deak wrote:
>> Use msecs_to_jiffies_min instead of open-coding the same.
>>
>> Signed-off-by: Imre Deak <imre.deak@intel.com>
>=20
> Tnx, applied to linux-can-next/master.

Removed, as requested by Imre:

> The reason is that in that driver I wasn't sure about why +1 was
> added, since the time_after() check already guarantees a minimum wait
> time.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2TJUVTAIVCKXTNJFHUUVE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGTdUMACgkQjTAFq1RaXHM0ugCgkMVdlkc9AKNezqn1e9MjO3Jw
K7oAoIpohcwjvXgdLjcD27uMzoXkKk5D
=3cb3
-----END PGP SIGNATURE-----

------enig2TJUVTAIVCKXTNJFHUUVE--
