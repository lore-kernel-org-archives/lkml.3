Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3LSKgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:36:45 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63784 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3LSKge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:36:34 -0500
Message-ID: <52B2CC2D.9070902@monstr.eu>
Date: Thu, 19 Dec 2013 11:36:29 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] devicetree: macb: Document clock properties
References: <1386972205-32733-1-git-send-email-soren.brinkmann@xilinx.com> <52AECBFC.5000207@atmel.com>
In-Reply-To: <52AECBFC.5000207@atmel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MqN7NkqdMMct2fhNWlXT1SFWRAvwEROKT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MqN7NkqdMMct2fhNWlXT1SFWRAvwEROKT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/16/2013 10:46 AM, Nicolas Ferre wrote:
> On 13/12/2013 23:03, Soren Brinkmann :
>> The macb driver uses the clock bindings. Document the required
>> properties, especially the driver specific clock-names.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>=20
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Has someone taken this patch?
If not, Rob can you please add it to your tree?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--MqN7NkqdMMct2fhNWlXT1SFWRAvwEROKT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKyzC0ACgkQykllyylKDCHREACePf+Xs2yGRQFt4vcTxvXPgEuN
DpYAn3cn9Cra9WhiEvwiH2HUIw1LNtRW
=rY3h
-----END PGP SIGNATURE-----

--MqN7NkqdMMct2fhNWlXT1SFWRAvwEROKT--
