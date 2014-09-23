Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaIWIvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:51:37 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:33297 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaIWIve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:51:34 -0400
Date: Tue, 23 Sep 2014 10:51:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Janusz =?utf-8?Q?U=C5=BCycki?= <j.uzycki@elproma.com.pl>
Cc: Mike Turquette <mturquette@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH] clk: Add PWM clock driver
Message-ID: <20140923085130.GO30514@ulmo>
References: <5410AEFD.5030302@elproma.com.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0PSjARDFl/vfYT5"
Content-Disposition: inline
In-Reply-To: <5410AEFD.5030302@elproma.com.pl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f0PSjARDFl/vfYT5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 10:05:17PM +0200, Janusz U=C5=BCycki wrote:
> Hi,
>=20
> http://patchwork.ozlabs.org/patch/359069/
> https://lkml.org/lkml/2014/6/12/186
>=20
> Will the patch ever included to linux-next?

I've never seen this patch before. From a quick look it doesn't seem
like it would work as is, but the idea is certainly interesting. If
somebody decides to continue work on it, please Cc me and the linux-pwm
mailing list.

> pwm_config()  API could be extended to support
> not only period [ns] and duty [ns] time
> but also frequency [Hz] and duty cycle fraction [1/1000?]
> (instead of time in ns) as parameters.
> Then  ns (rounded by pwm) to freq. conversion problem
> inclk_pwm_recalc_rate() usingpwm_get_period()
> could be avoided.
> To extend the API pwm_config() can support
> new flags forduty_ns and period_ns,
> eg. PWM_DUTY_PERCENT and PWM_PERIOD_HZ.

Is that rounding really a problem? Also the PWM chips will most likely
use the concept of period and duty-cycle internally anyway, so it will
convert back from Hz/percentage to nanoseconds and fall victim to
similar rounding effects.

Thierry

--f0PSjARDFl/vfYT5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUITSSAAoJEN0jrNd/PrOhMKkP/01lPka/hbsq3eDqEaJn0y41
QrVcSIbKff6BOv+kJ/dY8e64PKOilOfNH3vfA1GBvIytZix/IA0XPZoyteWXb1mm
unh5lbW/kSBCZoabTUuk0mbRGjZipXT+M3yMBVNf+gW4kJ1w70RyFVyqSrUXmN3T
3BOC1d8bdGwTqIGLSFRAF/TCbayyT9ERB0wLZ6xaNIez9rEyroyhB3bVNQbo1vnB
He3miKj96s7ct54hx0EsOY7GfDtoRASpjjRw4IZ/b+Aa4mXlRdl/flGlecsIfj+3
2hvSgPIbbbPf8VQQOIUMeKzjqenVWWARz6P8+LHeeNxP/gU+Ua7riGLE9OP9XvXl
cfZTrwr7TSUiCy/iCWipYZncIkTQC/qlzCMzIQ4aOHT+gNX52IZ97RcgXmgFiXbd
P5cSRvs04heZyFy35gvD4r0bFRbWdfAoVfdQ1HTMW8nZy8FzGnhK/h7ygTvVXnxP
mR/jFu1RDOMzPsEGkV95sV1gEdc9KzbCwObcOyjgh83PYVmuLuMSOmda1c8NiVFV
/oFREai0upScFOUsZMWmHgJZ80K4lyjc8OdL3Kdd58lM2MLWsp7eU+RDKcEb38vy
5EIZcj3aUtC6a67BhCRKiG2C6+4HQNfFl2N3HRl3HwbCGZtFDTkNCr8l1oXTcJpO
ycWPIZcHHc3k6VwScFaY
=39v8
-----END PGP SIGNATURE-----

--f0PSjARDFl/vfYT5--
