Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab3AJTxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:53:44 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:48430 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3AJTxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:53:43 -0500
Date: Thu, 10 Jan 2013 13:53:47 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: mturquette@linaro.org, swarren@nvidia.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rob.herring@calxeda.com,
        maxime.ripard@free-electrons.com, linux@prisktech.co.nz,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH 1/7] clk: add common of_clk_init() function
Message-ID: <20130110195347.GN19380@beefymiracle.amer.corp.natinst.com>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 01/10/2013 01:53:29 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 01/10/2013 01:53:29 PM,
	Serialize complete at 01/10/2013 01:53:29 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zs/RYxT/hKAHzkfQ"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-10_09:2013-01-10,2013-01-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zs/RYxT/hKAHzkfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 04, 2013 at 12:30:52PM +0530, Prashant Gaikwad wrote:
> Modify of_clk_init function so that it will determine which
> driver to initialize based on device tree instead of each driver
> registering to it.
>=20
> Based on a similar patch for drivers/irqchip by Thomas Petazzoni and
> drivers/clocksource by Stephen Warren.
>=20
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> ---

Prashant-

Sorry for the late response, but I finally got a chance to give this
patchset a spin on Zynq.  For patches 1 and 6:

Reviewed-by: Josh Cartwright <josh.cartwright@ni.com>
Tested-by: Josh Cartwright <josh.cartwright@ni.com>

  Josh

--Zs/RYxT/hKAHzkfQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7xxLAAoJEEef0niEbw+lq4gP/jTFT3AIiweW9FQaEH+RR4Tf
LhXPfe20riXV5fUGjIwmKlcaAvFOL/hsLRS+AT9uHJJOvrtSO2uLR+UFxHt9hN8W
V71PEBMbLiDEmgIo9w89xME3OR/cOdumZNVl4MCyUGgsHmFnZDwjNl+CG57lvYnk
BypWXZx7Z4wjtWNWgd/ayJe1SzyPfWSpsvuJnYTQLif3NciuIsHfl/s1e/jC9Dwb
0ON3r8VeQ/AFdq8MEENq7Fwu2bXqEoal2K9ZI1KyjiRntLcjcVThlKMEqIu8W3Hb
TafOnOjG0akhB2dV52W1DCr63obY8duTSjpnCmC6akqJ1Pdpp8UZmWb84AZsXP4K
im2et9rfBCskaAY8Vd/bqW4QsnPmGKsFrhXUZAf6T6rVu8PhQrjuY7v+avu+EAKX
rwE4Fx/dlr5EFLAJXtRuUAGzO32RDR4Y4xEMH9pOIbTnW+o2dRQ3jnwMDMYIXxLZ
AL9G+2VRCO1xgG/Cb8vUa8T4f3Eu4s8Xdp4WL2u69sIMP0W2kRMw0BCSQ9H0+c2T
r1EbDEuQbu7rkzVK6saW2USGSQlGqpUQ0LtURirgBO2FiLXojToc79IWdzO7xDlc
vIPCZBp2YiNueQKTWES4O2qn2oSAa5d+FHndrLZ2gQYL0WS1Ew27dwhXmYXeI9Xk
emxG9P0JVIoWeC5FzYMq
=PLjr
-----END PGP SIGNATURE-----

--Zs/RYxT/hKAHzkfQ--
