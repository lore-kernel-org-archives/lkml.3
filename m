Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaB1CFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:05:44 -0500
Received: from ring0.de ([5.45.105.125]:34979 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaB1CFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:05:42 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 28 Feb 2014 03:05:37 +0100
From: Sebastian Reichel <sre@debian.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jonathan Cameron <jic23@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv1 1/2] rx51_battery: convert to iio consumer
Message-ID: <20140228020536.GB5427@earth.universe>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
 <1393375569-21751-2-git-send-email-sre@debian.org>
 <CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
 <20140226215452.GA11468@earth.universe>
 <CAAfyv340pA2ihUAoFytBgevLtedvtj5Z0aw_=G9Rbx5occtyqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <CAAfyv340pA2ihUAoFytBgevLtedvtj5Z0aw_=G9Rbx5occtyqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 27, 2014 at 10:34:35PM +0100, Belisko Marek wrote:
> Well I've tried and it's worse :). I got during booting:
> [    2.218383] ERROR: could not get IIO channel /battery:temp(0)
> [    2.224639] platform battery.4: Driver twl4030_madc_battery
> requests probe deferral
> Not sure if it's just error or warning but temp is always reported as
> 0 (and also other values in sysfs).

This is an error, which basically means, that twl4030-madc has not
yet been loaded. Do you get proper values when you use the old madc
API with the patchset applied?

-- Sebastian

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTD+7wAAoJENju1/PIO/qa6JYP/ipg0aUiNmm5wexY07vlTDjk
diG9GsobHlfN7WfGDVyD2o/ue9qTzHFGTKNNiB3qV4KZn1YPJyWBNnprBZ4Fpv13
8FE3gzMO2XqKoMg3YwK1nZAfdPS4IXYv8ZaNR2kReZ+87xnRUGdPLrm8Uk9ZMjsh
/eqTt4xV5yvcVP+cuFsHhM4tlSUxoHzkSdM5erQrZdaU7IqRL/M5ZFq2NRlhh8Fj
jefZJ89rhghOjEBnV2Z95+pOkOknZA0Hz8Y1O9hEpOJ2QEDMkTtduAyr31GZmeq6
HyyWcIjhGw4uMZW7mUgpsu3UwdaTUc8DEiYGS+h8YnWkzF9gKGiogDQo6j+TjzFk
AOow7h8BaIgD+FM+laMXc18TFzcUE4I9noUc8VV4OR+JbntTPb80Ji75a3GlHSXF
rXhWuaQPr3vlXmWLyNJETyTDoTCCCo45hpyEhjarowsd0nymevuuhY+OLqaNDsR0
gJp44XAYCkukAryk8ybQDCkVJWmU0HBmkEXl0EXErKr105F93hePvA9M7uhsidaZ
f4IP1P3qHNPXkuwz4DEiUeSOhzcB92cRGraFg45NubF18UiQTSXn5rj6spauz4m4
Mntxtd7ApcTtYkIlLOEfD4b5sFzA9PwiYoAFLvly46RIx4uMwCIY3qcuFlEM7pE+
tacrLHpKBEK6g855Y7uv
=eysa
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
