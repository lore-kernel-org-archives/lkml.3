Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaJGBAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 21:00:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:34569 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbaJGBAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 21:00:01 -0400
Date: Tue, 7 Oct 2014 02:59:55 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/7 linux-next] HSI: remove deprecated IRQF_DISABLED
Message-ID: <20141007005955.GA2270@earth.universe>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be>
 <1412609755-28627-6-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <1412609755-28627-6-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 05:35:52PM +0200, Fabian Frederick wrote:
> See include/linux/interrupt.h:
> "This flag is a NOOP and scheduled to be removed"
>=20
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/commit/?h=3D=
for-next

-- Sebastian

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUMzsLAAoJENju1/PIO/qaPzgP/j2a0EEPGcyrMc1Lj0GKvMoq
UvK0ge22a27y9KXaG1x5gu3nWZXU+yfNNmnIu2K5NhgmSAD2KTEDMjFyvSZyxtfA
YTdterS+hzHWj19yfPuCGkhXWN2xJ/Jmu+nRBtAt3ecWEYjEqHw+CvFbz38LsBWQ
ql7Ey/n+NpEwEM+Kh0smpE3vZEztwhJmngyhUaxB67hDGNmoXUols/fdeuAumg0Z
kqoTx+K/d9Gm1dSnXtjoskU/IIcyFlcsWEjQVELa+euS9xOSNxDO781ZItwOSAU0
behApKVLwhZuATf4yo55ENmVWAMAxq2hwzktCBlNtN1J36MOe48X/0Z+nD+Zyogu
qoIMODKevkCDSVLlVpA9x/3pMdpMy78Nj+py9zfdRYA1mKCrmZXpChrC9QJdNjsR
8YWkNXJiL6JJh8ii+huoeqgie4q6bu8S3yALLf5U0vTZFdEKlMddl9sm7sHSNVeX
dEgzf+Wk0tcKkrMA1NvqsCxs2rmc9rsm0zzoLjzDc5wqE5k6VNtNHcig9ur92DH7
2XSKjtUxsmALfL/fshT0bLySg2JLPvM36WuBOll+WLQPtFV3Jdlq2HgW7/2NV1ww
0xknP81iQgy3DskcrgSx1QAh+00v39YG18+a3f9YYNwG7fIXCFnL6bIbEd7zn/db
hCueqXY46wZLAmu1hKnU
=PP1X
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
