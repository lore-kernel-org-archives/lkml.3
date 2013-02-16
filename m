Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3BPS4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 13:56:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab3BPS4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 13:56:21 -0500
Date: Sat, 16 Feb 2013 19:56:18 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Johannes Thumshirn <morbidrsa@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: twl: Use to_twl() instead of container_of()
Message-ID: <20130216185618.GA17744@avionic-0098.mockup.avionic-design.de>
References: <1361038851-4994-1-git-send-email-morbidrsa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <1361038851-4994-1-git-send-email-morbidrsa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Md2WX1egJIOFAfkJzkD/npCDb/RfOBSAFWWeeAwMiWn
 5A7mLTINOiujXks6SbK5DFG7deu/BfRNX9Z0G4MC7XX5jV0hV4
 LrPSB6R9jfWsX4fbvqwoUPDlcf90lXYw6Xmk+b2eWJDmtKE4VL
 rlCgS28ajpgqzTz3/RwFid9BwqBufLStTQf3KzOxDYDMQyYc+t
 WBB/Ilzl0RO3c1WZaKIej5iyYw5AIYsgFw3+0DbaWFttx8VijH
 OqkEcWBUeQUsn8DJT4Eh8UIjSqB0ntrgb1hFrusdK6UvYSPjWg
 CcEoGX1HlG+fr9batsC/nKCupLQqe1PpsoD8BKU7a7FtTYqLFJ
 cqffTtjfHIB0eFDQG3DzR6axkvOnfl9R2mYyZcPWgojKdjlsiz
 Z7U501OcmXzT3ns+fDuW3RjH6Knmm6zUsk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 16, 2013 at 07:20:51PM +0100, Johannes Thumshirn wrote:
> In twl6030_pwm_disable() use to_twl() instead of container_of() like in t=
he
> rest of the driver.
>=20
> Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
> ---
>  drivers/pwm/pwm-twl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Hi Johannes,

I see that container_of() is also still used in twl4030_pwm_free() and
twl6030_pwm_enable(). Would you mind fixing those up as well?

Thierry

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRH9ZSAAoJEN0jrNd/PrOh1J8QAIQkT+BZuqkzl0jpFJOSTcZv
tZ4V8+RSpAIrqoEkmKNU4x5ZrMJ5koZECkc57XdwMT/BHIX+y9+HZIE3fTsLMDVi
1VcapCHwAza/qHQx+/zpJCk+hzBq4rw8xvxVXWHm6TobWaOX7DtE2zC/gn7b8mxv
ce26Ir8edQA/tvaxZsiN2KVgsAgQMtpEYXRu712IghEnXoJx2riiZeo4MTIbLy3Y
kzHO3cnxKXXoM92svdC6UAH+1QesuQ9oIzXcRZz4ml857fFKfLVDB7+Gqc2nHf0k
krk0DrkOzK03tLw696rD1YyJFRKnxISRTX/p2ymlKTfV50znJcaO6aZ5XGyrYlcj
owKBhyHRkyRptW0t+G7bareHCuL1KYKIOnJfU5CnZfM4DC5g939AthdFpZyYGJbI
5CUED4MVROGyKWouqDzXUPBmXh+vf8qTXIYcrjasbpxBela2quO4XJbR9dn3AaST
HuC3xbEVGxLA2H9hiPncE/HbBImR4H1bo2GahH+aLoswz0/LcmFD0N+viag8Egyi
l/2E6Gwu3C3QmSWo5AqxAtOnaCM6eFjI98xTwUcqLubbptuta2V3qb9rfm6VXHa8
eDKa6MPwRn9DIPF8iRetuhWDg+24AjBFmDWaUOD8zKxG2+tLX/D1TXeLcPBA/ZjM
MxPeJ8kGm5ehQ5q82kDj
=QdTe
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
