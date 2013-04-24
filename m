Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414Ab3DXJjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:39:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37180 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758179Ab3DXJi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:38:58 -0400
Date: Wed, 24 Apr 2013 10:38:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Taras Kondratiuk <taras@ti.com>
Cc: lgirdwood@gmail.com, rjw@sisk.pl, viresh.kumar@linaro.org,
        shawn.guo@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philip Rakity <prakity@nvidia.com>, Eric Miao <eric.y.miao@gmail.com>,
        "grygorii.strashko" <grygorii.strashko@ti.com>,
        Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Subject: Re: [RFC PATCH 1/2] regulator: core: Add regulator_set_voltage_min()
Message-ID: <20130424093852.GY5019@opensource.wolfsonmicro.com>
References: <1366372554-20866-1-git-send-email-taras@ti.com>
 <1366372554-20866-2-git-send-email-taras@ti.com>
 <20130422131904.GL30351@opensource.wolfsonmicro.com>
 <51756A21.3020405@ti.com>
 <20130423084838.GB5019@opensource.wolfsonmicro.com>
 <5176743A.9070201@ti.com>
 <20130423134512.GL5019@opensource.wolfsonmicro.com>
 <5176D6B5.3070305@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VIFPKPeEU/ajvd6j"
Content-Disposition: inline
In-Reply-To: <5176D6B5.3070305@ti.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VIFPKPeEU/ajvd6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 23, 2013 at 09:45:09PM +0300, Taras Kondratiuk wrote:

To repeat, you should leave blank lines between paragraphs and delete
irrelevant context to improve the legibility of your mails and help
people find whatever content you're adding.

> On 04/23/2013 04:45 PM, Mark Brown wrote:

> >>They don't know anything about chip limits.

> >Clearly at least the lower bound is known to the drivers...

> Do you mean a voltage of the lowest operation point?

Yes.

> I think I'm missing something.
> How can I pass chip limits to a driver in some generic way?

That doesn't seem like a hard problem - just add a new property or two
if there's no facility there.

--VIFPKPeEU/ajvd6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRd6glAAoJELSic+t+oim9kg4P/09XcBtUWhZ32kJZiZN5yGEc
xtDLiCY2epd2Wz1wPeKmWabUlZ5QbtW+R7zvrO5muKJzSdMRePPk3igzMEA3LDTa
ToOYry8QsHplrM/Lt3AUny7Y/qC0xPWmq4WtmkwqfdRBj+SMHt51LKgA9Fp02JU0
cwLlG/Aw9IldF7IL9vF60wJW58AUQes0oPxMlwyLDPwigWxZnr0P3OWmVs29KDQz
2qSmEWbo7qLWXYWxEa2KgMkUmPz5xJypFb99jOYds7TdPy0wCJCjAFfXTIsXO68M
LApAaPSIIf3YtWXhVVMrxuAboiNsr53FA5ZG/RUGaV9HIOsMsTo4Iio/+6XUbQgR
uYkHOXJ1Bsn27F+dzvYwJlrziUsCucA8YLoSLul3QrJxzFQ5Dd7EIGcTn/xh0z7g
MHCY3So0F0V39r2wPHLhL/vRHLpsxOHT5G4qCqvR7xDOsdx92ho1qFvwS3BTBwFQ
L4u/ewgYsR+rYgataMClrFJ9p8lNHr/E4x21CQbeDyEaAYMcz8HPArSQAUlb5YJS
uew6WSSIv9LfbaN3mUmFerxa5FEOFRrGb0dK//3bK/KwxJYrZpcojup6Xq5xVbKo
l1JHmc+Yig0p5WtyS+AaMGT/LNJnJ/AZ+iPf6rjicKenlH2qA9sXI69WBFvQYA++
VpEz6nJKYLaSqvjEajlg
=P/op
-----END PGP SIGNATURE-----

--VIFPKPeEU/ajvd6j--
