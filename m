Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3IIMVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:21:08 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:48911 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3IIMVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:21:06 -0400
Date: Mon, 9 Sep 2013 14:20:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, grant.likely@linaro.org, linux@arm.linux.org.uk,
        rob@landley.net, ian.campbell@citrix.com, swarren@wwwdotorg.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv3 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20130909122008.GC22197@ulmo>
References: <1378454907-22728-1-git-send-email-Li.Xiubo@freescale.com>
 <1378454907-22728-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
In-Reply-To: <1378454907-22728-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 06, 2013 at 04:08:24PM +0800, Xiubo Li wrote:
> The FTM PWM device can be found on Vybrid VF610 Tower and Layerscape LS-1=
 SoCs.
>=20
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> ---
>  drivers/pwm/Kconfig       |  10 +
>  drivers/pwm/Makefile      |   1 +
>  drivers/pwm/pwm-fsl-ftm.c | 505 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 516 insertions(+)
>  create mode 100644 drivers/pwm/pwm-fsl-ftm.c

This looks pretty good to me. I noticed that you didn't Cc Sascha who
commented on this a lot. Can you please resend with him Cc'ed to make
sure he sees this version of the series?

One thing jumped out at me, so I've commented on it below, but I will go
over the patch more carefully after you resend.

[...]
> diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
[...]
> +static int fsl_counter_clock_enable(struct fsl_pwm_chip *fpc)
> +{
[...]
> +	switch (fpc->counter_clk_select) {
> +	case FSL_COUNTER_CLK_SYS:
> +		reg |=3D FTMSC_CLKSYS;
> +		break;
> +	case FSL_COUNTER_CLK_FIX:
> +		reg |=3D FTMSC_CLKFIX;
> +		break;
> +	case FSL_COUNTER_CLK_EXT:
> +		ret |=3D FTMSC_CLKEXT;

s/ret/reg/

Thierry

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLbz4AAoJEN0jrNd/PrOh11YP/A3g0vFY//KDaKEO+xFoYXM/
jVcHkqdu8YXAD6V3VBDRdK/9dzo0Us2EGx9f+iWTluntg8OnSfa5mqlgo8xBqmh6
MFsTs83dz51KpqvnaY+NsLd/wS5sGZDjcByVPCzrFYZNz0IagQUEcvtlVYPwlq5q
S2HkmqrwbZFyB/T/fQ6YrsLCCobJK36QY5yqvfwlaZGUbTHQv0tjlqoPq9okCHEn
cI4GlUcDKQMxMSxh4gvr8Ei5eXvzqHB7LMC/a3yic/Vr6JGTYMzk61fILMqBmfP6
h5PpKUF/nEprGo/tiakC/G2d+WKRNfkKDO2qlniMxw4u8kCXQBLJscaxO+61PREw
W7zudKL4QNfypaY29EBiRdp1wKR5Q0N4mrIuol4kd8N7moQn1COYqpT2nG6Qrifa
C5oI9u/yvSgwCoYDD95XGWtqLtmpztYXlUig6SqYI5mEycf0h8T07jHUuwSfB36f
LHKuGE4tTN9hmBFSjjgAh76Y0lC6sDsWgoEzx9rIPCRmQiDWeAQwmYB9XV/obObp
Q1oqehdQ13ZUJUASbLehnhQuE5v2s/9THRpXSK5A6Mk4EUUs9OFkLocb5GB8RlNr
5hlbqDeAg6Ybwjy+I4HeS67G/MWAEQX8TA/V0FbKIUgICYgTsiiUSIKyK4pB1W61
7UigRoQJiIYzFBOsEpi+
=qv2E
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
