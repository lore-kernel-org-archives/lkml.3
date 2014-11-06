Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaKFD6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:58:45 -0500
Received: from ozlabs.org ([103.22.144.67]:45418 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaKFD6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:58:43 -0500
Date: Thu, 6 Nov 2014 14:58:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>
Subject: linux-next: manual merge of the usb-gadget tree with the usb tree
Message-ID: <20141106145832.633bb8c2@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RuyYQXlLL8qyo+kQGxlVcYG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RuyYQXlLL8qyo+kQGxlVcYG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/chipidea/otg_fsm.c between commit 51f1741fcc16 ("usb:
chipidea: otg_fsm: delete unnecessary 'out of memory' messages") from
the usb tree and commit ef44cb4226d1 ("usb: allow to supply the PHY in
the drivers when using HCD") from the usb-gadget tree.

I fixed it up (the latter removed the code modified by the former) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/RuyYQXlLL8qyo+kQGxlVcYG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWvHwAAoJEMDTa8Ir7ZwVcYYP/i1L4v+/5we48QB0nU7or5BA
k3zG97i2RMGJbstAvmee5lZDOQ8HDvCG4gsBx4LtfaUDWHIw379YYv8zYxlVHnBU
hoQUPDLV691q7ibDs+Rpcj3v/+AKkjj0c9+/H5eXfefkoxbADhBI8PJbAw85LS/C
HXpQ9QAPuQyluByGuK1gdrpEF/fudrtlsNLgGjaO/AVxvQtszedtmK+YKeyDkAPQ
Pyv68uKAOF41OMECenUBWuHe7+AiIjLBUkHEy6Kq1M8YyEU+DvsI6yLUfIMGYa6j
DaFqE3VVfKhf22KdNuamoIBRJhsWk0JdcPyd+CpvouhPz85gO9ruiCaReciIW6od
MEdlZH0zWN0mQVxAKkIT6VMRPXnSSdURDqMG5zmaIss5gQmPN1zWBRmCBVr2W13C
8ezUssr6JUDZI459PgwKnsbo8HT+3AE25AdZ/yj8q5TqFAH9x5UCP/Dc9bmw8AoH
ycFp3+syS11ql1vQ2njVwNI0UgR+Hc2D6D7dhMwoz4lPEpeRh4IMx8KBsaBu4WIm
AwjVmby66T7tgp7JgjrT0WqQ41NKDrJhuGXk3MxOn2qNIhnNc6uA/Zcj/FTBblkF
hVKaNC016eXuntpUyVFo9xCwqZCJPmeLplTZnGuGa/imOWscBw5WYjUQLHNEq5EH
vUoDmMtfT3y6j9ticAxw
=TspF
-----END PGP SIGNATURE-----

--Sig_/RuyYQXlLL8qyo+kQGxlVcYG--
