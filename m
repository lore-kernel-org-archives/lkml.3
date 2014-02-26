Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaBZNOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:14:01 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:33453 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaBZNOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:14:00 -0500
Date: Wed, 26 Feb 2014 14:13:56 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9 Resend 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Message-ID: <20140226131355.GB29779@ulmo.nvidia.com>
References: <1392799137-17188-1-git-send-email-Li.Xiubo@freescale.com>
 <1392799137-17188-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <1392799137-17188-5-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2014 at 04:38:57PM +0800, Xiubo Li wrote:
> This adds the binding documentation for Freescale FlexTimer Module
> (FTM) PWM driver under Documentation/devicetree/bindings/pwm/.
>=20
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
> Reviewed-by: Yuan Yao <yao.yuan@freescale.com>
> Acked-by: Kumar Gala <galak@codeaurora.org>
> ---
>  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 34 ++++++++++++++++=
++++++
>  1 file changed, 34 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Docu=
mentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
[...]
> +- clocks : Must contain a clock specifier for each entry in clock-names,

Nit: A slightly more correct way to say this would be: "Must contain a
phandle and clock specifier...".

Thierry

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDeiTAAoJEN0jrNd/PrOhvAwQAIGeUZpSfjwWI36hVO6NUSEk
Wkk6gkSybGO9gNmyK8WtA/O3f0Y1T5ULzFXKT579dalaIcn9nOii70KH9Y47BE5r
16E7IU3yHzwGBtX8dilHMMF0bHwI1WQQfBj+LHbQtyBDW0XrSJ8tVMzTsGD+2EaE
Ef4gDNnCmQprXZuKP2/pGV2jNwoi6xGzBi8JWMxvVrKkoqekOSxxWMPo+KEV104k
iLFsjZWSFmsY1JshACb34yNLpXxkzVQ4UtAy7ryEf+n5T/+r6Q/4RA01XY3LLlsB
qGl5qq/NFioq3dmNRl7OKmWxUO1O2vGcFQOWQ8x3UFrXF9TiACbV982GoT9CdGY7
7KoQ4jpNkZM0zVLxjbHoP7kJB6nfsz7b0R/6awFp7W8jcnqsZNoOj2Xz7I1DKICW
2oOjHfARkdhtI0mO+3duNLYY97QXc+uPHt+1/5bv6Ut2WWXvczl35r6Q5HTVQW3B
QxpH0GjzHoosQH5zcPL+79+u2P2PIsoRS+xQ496WP/VvVYPk6RkI4RskKlicRp36
UmsBAdqM651pSpYp5Bl7c3zvvAcjXQ5Ig4wxZ1xPvpRvtsheHkqc02u6BUQq8X/h
svbSVf86YtPil0x+2eIfck29M4DhiB0714zNqTZfBT4vn68R6YvuJoED7Xt8UmmF
zuYAwkXhZh3CGvXQMb3b
=bWSM
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
