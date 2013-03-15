Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3COBgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:36:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60566 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648Ab3COBgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:36:42 -0400
Date: Fri, 15 Mar 2013 01:36:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Remove __attribute__ ((packed))
Message-ID: <20130315013640.GG4931@opensource.wolfsonmicro.com>
References: <1363274779-20671-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YH9Qf6Fh2G5kB/85"
Content-Disposition: inline
In-Reply-To: <1363274779-20671-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YH9Qf6Fh2G5kB/85
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 14, 2013 at 03:26:19PM +0000, Dimitris Papastamos wrote:
> There is no point having this.  The space gains are trivial if there
> are any at all.

Applied, but numbers would have been nice and...

> Change-Id: Ib4b1320420f780dcf5b9a1e4b05f5805691c4d9f

...this shouldn't be in upstream submissions.

--YH9Qf6Fh2G5kB/85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQnsQAAoJELSic+t+oim9RUkQAIwjt3gmJBbpAyLU0sWW0JsV
pjSTqF5HiT8QMJzZAQstqa1fjtThw0tG4WwMvSDYiiOSLmJ0nevh7gh4/8SwzGpf
pTjOmh6Yz4CDNPVSHFUPjSVJaY43C+Fx0VmZHHmzPU0z4Ntv0P5/Q2/eLJjotTX6
iGCTkVwKg2gLCaF/RJKo4naSafuCo15ERwV1uWG8fxR/IAocCAK5J7h6I8g+Xqsa
Nvd2eizmmI56iqS4LoY8I4I1l3ztnnl50X1UDBhbNtRQHVkVOSpyWuvIHyKNVA0z
qsRz2qWTxXH9PeivEceY2UC+S6h7c26ZA6B9ZS4oXot+sCiUMkBaIppN1YYJlP/d
16SWVdzYOGkY5IEVohJxVDv1klkb9tHSf4zPEnc02jNEqsCBJD+HVsrQthXk7cqH
A5okQDt1Ass+FOMtSdiI2+ep18w9JJgSavdNNFD1jN1+HcYFqSysabRAhsgmBSmc
w9sPvHWQNiU+FwOGANDehAaKFsbX6+tT65gvBiArpfJN3SycR7/A51FOjc9daRFF
4d6f1d8K7xVvpDMXj7/fAuPOR1klmUDWummJuASJUhkZLy3ITt8tY/k5KH/5mPUC
QFZu0+egzGEjayL805NHatiE5UbxP68zr2DDQCMI2S/XLyIid8OxvsRzzLpx4VY5
2HrFhhkiAdY1T24OiX0b
=8wNb
-----END PGP SIGNATURE-----

--YH9Qf6Fh2G5kB/85--
