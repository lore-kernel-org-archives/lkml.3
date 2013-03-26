Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539Ab3CZPZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:25:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60753 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964830Ab3CZPZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:25:05 -0400
Date: Tue, 26 Mar 2013 16:24:58 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Philip Avinash <avinashphilip@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pwm: tiehrpwm: Staticize non-exported symbols
Message-ID: <20130326152458.GC28997@avionic-0098.mockup.avionic-design.de>
References: <1364309698.4090.1.camel@phoenix>
 <1364309757.4090.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <1364309757.4090.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:bPTexJkPiMEsyMihcMW09Z2kaSuabuUm7clekx+Uhvy
 OSZ2Quy0Hj06BKO7uvU4gR7Z13T1ZN+DABpJY3J98XhCOd95TC
 /IoUgxNaMAw9KZ3NjYcAFpag0VHR6wdT/ZfTvdPOM32YBzDX1K
 Pznckv2xHE+4ITjryocf9ojr2NpZWzzR4gkfMPq98EbMuejGeP
 DFd6N3pPgREV1BzYtyJ/5T2uAAcSckAEYsq+itdGJeF5Nw4geo
 o7kdIJKd7ySBHHT44Lfylkw9xf0qVMptG5G4cnYxLfoJgZPObA
 ptefZ1yhhjVCPZJgC/Mhq97m22/p90elI0uUs/PyEzi/cZKm5q
 +AkJ9Mxem3ZkWG0gsXXuR8tjID8git3/+wCp4I4LIKlD0nWK/L
 hMf2gDt0gQMJ2HZ1k1iVtKF+svEKYD7Do4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2013 at 10:55:57PM +0800, Axel Lin wrote:
> Both ehrpwm_pwm_save_context() and ehrpwm_pwm_restore_context() are only =
used in
> this file, make them static.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied, thanks.

Thierry

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRUb3KAAoJEN0jrNd/PrOh2JYP/1J4Qx8XyVCY/5bXn7CHxiMj
vh9uR/TQjiSSaVsUOiCdj7zYMFaeDR9tC2KzNmTZ2UMRFyg2zkJ7k9DPBwIe8KDF
zcStQIHRmfFPcLui6PDyYx/PeHb2CqU/AR3zM2P46hhxmuV8MNuzkWQTHEOhrw1F
YICMWbPKmexPxIoH9+zZSnnc/IA1MHaoETtytQssoCf0hhFD4x0tcKViEOAIC965
shuhvRs4NeBiL1dzmX5EzwhGBb8V39X9W0nbcrkU/0xZDZtFJtiEInyXsZjkDtYV
MXKZUsqwmUJYnNW7AAg3f8EQQu1ysdzZGp9UmkRV+rQ1vu5ko3d+ozJH42skjYTm
BQ8iiPm+zjRP7vX91nGLWS3sy9fDp5tqS9OrZbaA3IuZDkYxHcm82MUPMzU7s48K
/wpLhvEKopokQCaoWtgXVAFZTyqeSHg0WClyVF8Q57vLMIL7Q01IWgdx3YAdwqGC
LwAPWLHme/anMADuhkS3O4Bj+7CA+h/lNPQ4DI4o0CcbmqZ+o1PwgbtLgaNn0xwj
XPpEsk6BFI7Zpi3dXHC18lSOfKJKBhnOTt+QX38wRHM0TPzVSNAmu1rb2pnANSMI
wSaZDxdBdPZNMQKlCSjPO4OWuXziN5z+ccUJP400unuYT37pOSmiac78TloOlW1f
LAnkZ2csJCTh4MckfjLZ
=+/px
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
