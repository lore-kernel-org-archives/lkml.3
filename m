Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaAWMwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:52:25 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:32897 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaAWMwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:52:24 -0500
Date: Thu, 23 Jan 2014 13:52:20 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] pwm: Remove obsolete HAVE_PWM Kconfig symbol
Message-ID: <20140123125219.GC28527@ulmo.nvidia.com>
References: <1389884494-13729-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <1389884494-13729-1-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2014 at 04:01:34PM +0100, Sascha Hauer wrote:
> Before we had the PWM framework we used to have a barebone PWM api. The
> HAVE_PWM Kconfig symbol used to be selected by the PWM drivers to specify
> the PWM API is present in the kernel. Since the last legacy driver is gone
> the HAVE_PWM symbol can go aswell.
>=20
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>=20
> I suggest that Thierry as PWM Maintainer takes the patch through his tree.
> Is that ok for you Thierry?

Yes, that'd be my preference as well. Perhaps you can resend and add a
few more people on Cc. In particular I'd like at least Russell's (ARM)
and Ralf's (MIPS) Acked-by. Dmitry was already Cc'ed for input/misc.

The patch is rather minimal, but I'd still like to give them an
opportunity to object or at least see the patch.

Thanks,
Thierry

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4RCDAAoJEN0jrNd/PrOho8wP/iDOVWDGatEcpTOT854cLsrQ
F62Q67hrLHWTib2u1/EntD62h3ZOIEAWp1b4KKFHE9sBUm5JMq13t/TM1hDZ01St
LPMbqowi7Sl1JgdIu31lHlh0jn6KJ0kGJ7AI35hkhPEDxEvFJWfQJTxet88Q9BZ6
dHMwllYJw5zis5+rMFDozq6cLZqc3dNLuZP82pz4lx0Q7d3fLZdfaVXpeTBjABY6
uCn13ZvHhLUqOr1pKMv73aEVr2jGEP9yroBtcvccIiV3SMg3NuiaPiTSKqx9noos
KNbfjAAKXSUN9e8+qm4B90RIHmxvW7bohm7MbUH/ukIRZy00BvByqzbAhGza9f2I
3WJJ7dxEyE78q05UpXeE2uQMSn+AOQ5sr1rQ07LbmU17ouvJuzVDi8rZXOr34ys3
JkCZ3WOy5PiA0c/p+b8vBN7cz/FUD1iEkXQcF8my7krBcn2az4E1bRZ0DZdfqF0b
pXkW2mKTUiwUKcDsj59clwo5jBG/lDU+3640Tfm4UfvA8yegHOExcwxCf1wrFEXC
xN0fKJExslMc7PJqBEe9Yd+XupploEahHvvxAINY7IwMzpmkWTf13OzTQgy9DBZX
jz29krPIOUmI/jJzhfPTsqMkdZ6i/eSMLFCK3EzXMGebh0xigPT4nzRRZl2wgNYr
PmRPW30DdPwOMgLlUidx
=eoiF
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
