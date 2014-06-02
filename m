Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaFBFL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 01:11:56 -0400
Received: from ozlabs.org ([103.22.144.67]:36247 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbaFBFLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 01:11:55 -0400
Date: Mon, 2 Jun 2014 15:11:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: linux-next: build failure after merge of the mmc tree
Message-ID: <20140602151141.084d3350@canb.auug.org.au>
In-Reply-To: <20140526140735.3f405672@canb.auug.org.au>
References: <20140526140735.3f405672@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/t6C=HlnrAesft1a1OWd=U_z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/t6C=HlnrAesft1a1OWd=U_z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Chris,

On Mon, 26 May 2014 14:07:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the mmc tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>=20
> drivers/mmc/host/sdhci-s3c.c: In function 'sdhci_s3c_notify_change':
> drivers/mmc/host/sdhci-s3c.c:402:25: error: 'struct sdhci_host' has no me=
mber named 'card_tasklet'
>=20
> Caused by commit 3560db8e247a ("mmc: sdhci: push card_tasklet into
> threaded irq handler").  This is the second left over one I found.
> Please check for any more (grep is your friend).
>=20
> I have used the mmc tree from next-20140522 again for today.

This is back again.  I have no idea why I didn't get this failure on
Friday. Please, guys, go through your tree and fix this problem once
and for all.  Grep is your friend.

I have used the mmc tree from next-20140522 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/t6C=HlnrAesft1a1OWd=U_z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjAeWAAoJEMDTa8Ir7ZwV+NcP/iayxrFcHHJGBdHxK5DNbBRd
yBFxK0MzLGCKoTD7hON4NOVeIpOdLoRFeKXW7njFXXv8JTw2hVPwfCFnz1jSzMEH
5dQbP1kmsUXKrH62S20ztFQd9MQQsg15XbFTZYrWwIEf+/w/QZFViXxFdqcuOm8q
Hyw50KCkgaPdLVRDnbYw+8piDIDJadL4Y+OHzH9mmMTsw3pOuLpg/2t+vPoAqhpV
P0ZLgiiDb3Ofdot2X+BgbCtiEs5RlqdYQHHpHxlPPhHEEpdjzn+P2ifBRh+0GgK8
c7zhp7oY0SVYuvsLQcPRszdhsxaR9S6SdByZLI/7GrJeooqxn5LPbYSVlkG/+IOq
TaJNWa9K9l/1mDkpuAiXcrosnsvxG/7m8sfqjoJpbCDUx2+EIRzHZhS1FPIZ9Jge
nJTFmNF2nOHoSYyGcIMkStoOIzmeSGwbKaQUSOtMFplBOkVxsklEku9EBJVsUlec
/NQBBqhNdFBnPXiWD/DBxFFN2QerwHTYaHCuRVV5e6+xjinJJd7bc7T8KbMEh/t6
PVx+gxDr/cfDmb9EIgJrWzNTXTOSHcgLOeeVHOp1CWHwqMmr1SCVx7Sqde5cy/qu
hUG2ItONX14zZJVCdATRt0GfqxFVwJWyZboYWy3L9DIOZqsqaKI6i17DHkAWVL05
6dgANzQEdx8yVSeFsMmO
=k6BG
-----END PGP SIGNATURE-----

--Sig_/t6C=HlnrAesft1a1OWd=U_z--
