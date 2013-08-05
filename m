Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3HEQIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:08:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42579 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3HEQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:08:09 -0400
Date: Mon, 5 Aug 2013 17:07:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Oskar Schirmer <oskar@scara.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Zeng Zhaoming <zengzm.kernel@gmail.com>
Message-ID: <20130805160743.GN9858@sirena.org.uk>
References: <1375688163-1935-1-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pg9nAr2jDD6ER3CP"
Content-Disposition: inline
In-Reply-To: <1375688163-1935-1-git-send-email-oskar@scara.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] sound/sgtl5000: fix codec clock source transition to
 avoid clockless moment
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pg9nAr2jDD6ER3CP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 05, 2013 at 07:36:02AM +0000, Oskar Schirmer wrote:
> Powering down PLL before switching to a mode that does not use it
> is a bad idea. It would cause the SGTL5000 be without internal
> clock supply, especially on the I2C interface, which would make
> subsequent access to it fail.

Applied, thanks.  Please do use subject lines corresponding to the
subsystem.

--pg9nAr2jDD6ER3CP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR/83MAAoJELSic+t+oim90gwP/05OSKqmA64Edt7u1o+G5SPN
VnxcvE1cjDGatdqc/dcAZXiG3IXDAxgpaItnZ2ZkgRlXCL1TktBIOf6bwnLjC1Po
unSasjx8IIYVXKb86w+39BRx5MbWYP3+nWsbv2WY0u7C25iLwElWpOASrJvTfnUk
K9kcRmO2aGu5kSz07a2+WXiviWu524gcyIs+3Zt8Z8i6T30E5rx3nc+vWGajAWaM
486eS2Y+s+ArroHNm1NG8PwND3oOg0EYx3FQ23/IE0aTsYt1YYyFhEQjddgtx0ZP
8vpZxAFO3FDuDZr40xj+mhdqfFeqk3GJJKAJWX0x0arTLkLS8ulHNXW8wW2sYFrt
Crrm37MCuNG0FeFlGaMZZx02QuHCbYiruAGu4FGI7Iv8gpQISdUkNBUiv7fUbaSC
Z5/oNq2crdG5GiOu8VtrTytd8fic7g3Ks6KLEUngSbyepvfgDUi9q5b401d98DmY
b6aOrYB0vc1X8bZicafqaV+ZEzFo14g3MG+J2KRH0/4mNJrpPrNE/nGOToOrtH4n
YLU0j16xkVd+07i4xRB5b4T0z1/7xN9hUWMVmn+7nXNpulfpOUelgmuUWfo3dJK9
ntASXl/S6DzIrD62YdYzQIqMykd9HJaEupuwiedKIWNDWvw33qLiRWJwwbagifmg
CAcO0VuIJubPA2Y6+i5I
=vjiF
-----END PGP SIGNATURE-----

--pg9nAr2jDD6ER3CP--
