Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaDTSwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 14:52:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40566 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaDTSwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 14:52:42 -0400
Message-ID: <5354175B.3070109@pengutronix.de>
Date: Sun, 20 Apr 2014 20:52:11 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        leoli@freescale.com, balbi@ti.com, michal.simek@xilinx.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kalluripunnaiahchoudary@gmail.com, kpc528@gmail.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        Peter Chen <peter.chen@freescale.com>
Subject: Re: [RFC PATCH 0/2] usb: Reuse fsl driver code for synopsys usb controller
References: <7aed4ee6-69e7-4f9f-9f45-675bc695089c@CO9EHSMHS031.ehs.local>
In-Reply-To: <7aed4ee6-69e7-4f9f-9f45-675bc695089c@CO9EHSMHS031.ehs.local>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pmvvGVFxVpXF3EStVhMQPAHlmlk8pKBL1"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pmvvGVFxVpXF3EStVhMQPAHlmlk8pKBL1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/20/2014 06:27 PM, Punnaiah Choudary Kalluri wrote:
> Zynq soc contains a dual role usb controller and this IP is from synops=
ys. We
> observed that there is driver available for this controller from freesc=
ale and
> decided to reuse this driver for zynq use.

Have a look drivers/usb/chipidea. It's maintained by Peter Chen (Cc'ed)
and is in better shape than the freescale driver.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--pmvvGVFxVpXF3EStVhMQPAHlmlk8pKBL1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlNUF18ACgkQjTAFq1RaXHOe/gCfaQTcIGRWutnvCgxpLF5zt/zz
ckwAniLxhuJdXwoFWp2o59jgg1v8X8GS
=x9vH
-----END PGP SIGNATURE-----

--pmvvGVFxVpXF3EStVhMQPAHlmlk8pKBL1--
